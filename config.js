/* Aide Shifts settings
 * 1. Paste your Supabase Project URL and anon public key below (Supabase > Project Settings > API).
 * 2. Leave them blank to run in demo mode: changes stay in this browser only.
 */
window.APP_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: "",

  CLINIC_NAME: "Ivy Rehab Bala Cynwyd North",

  // Clinic hours by weekday (1 = Monday ... 6 = Saturday). Remove a day to hide it.
  CLINIC_HOURS: {
    1: ["07:00", "19:00"],
    2: ["07:00", "19:00"],
    3: ["07:00", "19:00"],
    4: ["07:00", "19:00"],
    5: ["07:00", "19:00"],
    6: ["08:00", "12:00"],
  },

  // Starting team (used in demo mode; the live database is seeded by schema.sql).
  SEED_TEAM: [
    { name: "Makaiya", role: "Aide" },
    { name: "Kay", role: "Aide" },
    { name: "Malik", role: "Aide" },
    { name: "Tatum", role: "Aide" },
    { name: "Sabrina", role: "Aide" },
    { name: "Clinic Director", role: "Staff" },
  ],

  // The standard week, read from shift-schedule.html.
  // aide: null = an open shift that still needs someone (the gaps in the old schedule).
  STANDARD_WEEK: [
    { day: 1, start: "07:00", end: "08:00", aide: null },
    { day: 1, start: "08:00", end: "16:00", aide: "Makaiya" },
    { day: 1, start: "16:00", end: "19:00", aide: null },
    { day: 2, start: "07:00", end: "08:00", aide: null },
    { day: 2, start: "08:00", end: "15:00", aide: "Makaiya" },
    { day: 2, start: "12:00", end: "18:00", aide: "Kay" },
    { day: 2, start: "16:00", end: "19:00", aide: "Malik" },
    { day: 3, start: "07:00", end: "15:00", aide: "Makaiya" },
    { day: 3, start: "09:00", end: "16:00", aide: "Tatum" },
    { day: 3, start: "16:00", end: "19:00", aide: null },
    { day: 4, start: "07:00", end: "12:00", aide: "Kay" },
    { day: 4, start: "08:00", end: "16:00", aide: "Makaiya" },
    { day: 4, start: "16:00", end: "19:00", aide: "Sabrina" },
    { day: 5, start: "07:00", end: "15:00", aide: "Makaiya" },
    { day: 5, start: "15:00", end: "19:00", aide: null },
    { day: 6, start: "08:00", end: "12:00", aide: "Malik" },
  ],
};
