# Haven CRM

Mobile CRM for Haven Property Services — contacts, calendar, tasks, and email logs.
One file (`index.html`), backed by Supabase.

The CRM **shares the `havens-honey-dos` Supabase project** (`sstipdekzaywxxcdrjks`)
with the Haven's Honey Do app. Because of that:
- the CRM's task table is `crm_tasks` (Honey Do owns `tasks`), and
- CRM tables are locked to Robin's emails only — Honey Do client/tech logins
  can never read CRM data.

## One-time setup

1. **Run the SQL** — havens-honey-dos project → SQL Editor → paste
   `supabase-crm-setup.sql` → Run. (Safe to run twice.)
2. **Create your login** — same project → Authentication → Users → Add user →
   one of the allowlisted emails + a password, check **Auto Confirm User** → Create.
3. Open the app and sign in with that email and password.

## Where it runs

GitHub Pages serves this repo at: https://enjoyyourhaven.github.io/haven-crm/

After any change is pushed, give it a minute, then hard-refresh (Cmd+Shift+R).

## Notes

- Data is protected by login + Row Level Security. Without signing in, nobody can
  read or change anything, even though this repo is public.
- Sign out from the avatar (top right) → Sign Out.
