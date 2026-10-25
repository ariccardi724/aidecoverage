-- Aide Shifts: run this once in Supabase > SQL Editor > New query > Run.
-- Creates the tables, opens them to the app's public key, turns on live updates,
-- and loads the team and the week of Oct 26, 2026 from shift-schedule.html.

create extension if not exists pgcrypto;

-- People who can use the app. Role "Aide" appears in shift dropdowns; "Staff" can edit but isn't scheduled.
create table if not exists public.team (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  role text not null default 'Aide' check (role in ('Aide', 'Staff')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- One row per shift. aide_id null = open shift. Times are "HH:MM" text (24-hour).
create table if not exists public.shifts (
  id uuid primary key default gen_random_uuid(),
  shift_date date not null,
  start_time text not null check (start_time ~ '^\d{2}:\d{2}$'),
  end_time text not null check (end_time ~ '^\d{2}:\d{2}$'),
  aide_id uuid references public.team(id) on delete set null,
  updated_by text,
  updated_at timestamptz not null default now(),
  check (end_time > start_time)
);
create index if not exists shifts_date_idx on public.shifts (shift_date);

-- Who changed what and when. Append-only: the app can add and read entries, never edit or delete them.
create table if not exists public.activity_log (
  id uuid primary key default gen_random_uuid(),
  at timestamptz not null default now(),
  actor text not null,
  action text not null,
  summary text not null,
  shift_date date,
  details jsonb
);
create index if not exists activity_log_at_idx on public.activity_log (at desc);

-- Row Level Security: the app uses the public "anon" key, so these policies decide what it can do.
alter table public.team enable row level security;
alter table public.shifts enable row level security;
alter table public.activity_log enable row level security;

drop policy if exists "team read" on public.team;
drop policy if exists "team write" on public.team;
drop policy if exists "team update" on public.team;
create policy "team read"   on public.team for select to anon, authenticated using (true);
create policy "team write"  on public.team for insert to anon, authenticated with check (true);
create policy "team update" on public.team for update to anon, authenticated using (true) with check (true);

drop policy if exists "shifts read" on public.shifts;
drop policy if exists "shifts insert" on public.shifts;
drop policy if exists "shifts update" on public.shifts;
drop policy if exists "shifts delete" on public.shifts;
create policy "shifts read"   on public.shifts for select to anon, authenticated using (true);
create policy "shifts insert" on public.shifts for insert to anon, authenticated with check (true);
create policy "shifts update" on public.shifts for update to anon, authenticated using (true) with check (true);
create policy "shifts delete" on public.shifts for delete to anon, authenticated using (true);

drop policy if exists "log read" on public.activity_log;
drop policy if exists "log insert" on public.activity_log;
create policy "log read"   on public.activity_log for select to anon, authenticated using (true);
create policy "log insert" on public.activity_log for insert to anon, authenticated with check (true);
-- No update or delete policy on activity_log, so the history can't be rewritten from the app.

-- Live updates: everyone viewing the app sees changes immediately.
do $$
begin
  begin alter publication supabase_realtime add table public.team; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.shifts; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.activity_log; exception when duplicate_object then null; end;
end $$;

-- ---------- Starting data from shift-schedule.html ----------
insert into public.team (name, role) values
  ('Makaiya', 'Aide'), ('Kay', 'Aide'), ('Malik', 'Aide'), ('Tatum', 'Aide'), ('Sabrina', 'Aide'),
  ('Clinic Director', 'Staff')
on conflict (name) do nothing;

-- Week of Mon Oct 26, 2026. Rows with no name are open shifts (the gaps in the old schedule).
insert into public.shifts (shift_date, start_time, end_time, aide_id, updated_by)
select v.d::date, v.s, v.e, t.id, 'Setup'
from (values
  ('2026-10-26','07:00','08:00', null),
  ('2026-10-26','08:00','16:00','Makaiya'),
  ('2026-10-26','16:00','19:00', null),
  ('2026-10-27','07:00','08:00', null),
  ('2026-10-27','08:00','15:00','Makaiya'),
  ('2026-10-27','12:00','18:00','Kay'),
  ('2026-10-27','16:00','19:00','Malik'),
  ('2026-10-28','07:00','15:00','Makaiya'),
  ('2026-10-28','09:00','16:00','Tatum'),
  ('2026-10-28','16:00','19:00', null),
  ('2026-10-29','07:00','12:00','Kay'),
  ('2026-10-29','08:00','16:00','Makaiya'),
  ('2026-10-29','16:00','19:00','Sabrina'),
  ('2026-10-30','07:00','15:00','Makaiya'),
  ('2026-10-30','15:00','19:00', null),
  ('2026-10-31','08:00','12:00','Malik')
) as v(d, s, e, n)
left join public.team t on t.name = v.n
where not exists (select 1 from public.shifts where shift_date between '2026-10-26' and '2026-10-31');

insert into public.activity_log (actor, action, summary, shift_date)
select 'Setup', 'setup', 'Loaded the team and the week of Oct 26 from shift-schedule.html', '2026-10-26'
where not exists (select 1 from public.activity_log where action = 'setup');
