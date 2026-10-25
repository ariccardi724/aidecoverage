# Aide Shifts: Ivy Rehab Bala Cynwyd North

A live weekly schedule for PT aides. Pick an aide for each shift from a dropdown, change any start or end time, and everyone with the link sees the change within a second or two. Every change is recorded in the Activity log with who made it and when.

## What's in this folder

| File | What it does |
|---|---|
| `index.html` | The whole app |
| `config.js` | Your Supabase keys, clinic hours, and the standard week |
| `ivy-logo.png` | Logo for the top-right of the banner |
| `manifest.webmanifest`, `sw.js`, `icon-*.png`, `apple-touch-icon.png`, `favicon-64.png` | Let the app be installed on phones and computers |
| `supabase/schema.sql` | Creates the database and loads your team and the week of Oct 26 |

Open `index.html` before setup and it runs in **demo mode**: fully working, but changes stay in that one browser.

## Setup (about 15 minutes, once)

### 1. Create the database (Supabase, free plan)
1. Go to supabase.com, sign up, and click **New project**. Pick any name and a database password, region US East.
2. When it finishes, open **SQL Editor > New query**, paste everything from `supabase/schema.sql`, and click **Run**. You should see "Success".
3. Open **Project Settings > API** (sometimes labeled "Data API" / "API Keys"). Copy the **Project URL** and the **anon public** key.

### 2. Connect the app
Open `config.js` and paste the two values:

```js
SUPABASE_URL: "https://abcdefgh.supabase.co",
SUPABASE_ANON_KEY: "eyJhbGciOi...",
```

The anon key is designed to be public; what it can do is limited by the rules in `schema.sql`. Never paste the **service_role** key here.

### 3. Host it (GitHub Pages, free)
1. On github.com, click **New repository**, name it e.g. `aide-shifts`, set it to **Public** (Pages on private repos needs a paid plan), and create it.
2. Click **Add file > Upload files** and drag in everything from this folder, keeping `supabase/` as a folder. Commit.
3. Go to **Settings > Pages**, set Source to **Deploy from a branch**, branch `main`, folder `/ (root)`, and Save.
4. After a minute your link appears: `https://<your-username>.github.io/aide-shifts/`. Share that with the team.

The banner should now say **Live** with a green dot. If it says "Reconnecting", check the URL and key in `config.js`.

**Updating later:** edit a file on GitHub (the pencil icon) or upload a new version. Pages redeploys on its own in about a minute.

## Using it

- **First open:** everyone picks their name on "Who's using the app?" It's remembered on that device. "Switch" in the top bar changes it. Anyone not listed can type their name and is added as Staff.
- **Schedule:** each day shows a coverage bar for clinic hours. Green means an aide is on, striped amber means an open shift, red means no shift at all. Choose an aide from the dropdown; people already working at that time are listed separately under "Already working then".
- **Times:** click a start or end time to change it (30-minute steps, 6 am to 9 pm).
- **New weeks:** an empty week offers **Add the standard shifts** (from `config.js`) or **Copy last week**.
- **Team tab:** add aides or staff, rename, or remove someone. Removed people keep their history.
- **Activity log:** every change with name and time, filterable by person. It can't be edited or deleted from the app.

## Installing as an app

When someone opens the link, an **Install Aide Shifts** button appears at the bottom of the screen.
- **Android, Chrome or Edge on a computer:** tap **Install**. The app gets its own icon and opens in its own window.
- **iPhone or iPad:** the button says **Add to Home Screen**. Tap **How** for the three Safari steps, since Apple doesn't allow a one-tap install.
- Closing the button with **×** hides it for two weeks on that device. It never shows once the app is installed.

Installing only works from the hosted https link (GitHub Pages), not from a file opened on your computer.

## Changing the defaults

In `config.js`: `CLINIC_HOURS` sets each day's open hours (remove a day to hide it), and `STANDARD_WEEK` is the template for "Add the standard shifts" (`aide: null` makes an open shift).

## Good to know

- **The name picker is not a login.** Anyone with the link can view and edit, and could pick someone else's name. For a small team sharing a link this is usually fine, and the log makes changes visible. If you need real sign-in later, Supabase Auth (email magic links) can be added and the database rules tightened to signed-in users only.
- Two people changing the same shift at the same moment: the last change wins, and both appear in the log.
- Supabase free projects pause after a week with no activity. Opening the Supabase dashboard and clicking **Restore** wakes it. Regular weekly use keeps it awake.
- If a work network blocks `github.io` or `supabase.co`, ask IT to allow those two exact addresses.
