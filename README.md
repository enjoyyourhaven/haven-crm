# Haven CRM

Mobile CRM for Haven Property Services — contacts, calendar, tasks, and email logs.
One file (`index.html`), backed by Supabase (project `sstipdekzaywxxcdrjks`).

## One-time setup

1. **Run the SQL** — Supabase Dashboard → SQL Editor → paste `supabase-crm-setup.sql` → Run.
   (Safe to run twice.)
2. **Create your login** — Supabase Dashboard → Authentication → Users → Add user →
   enter your email and a password, check **Auto Confirm User** → Create.
3. Open the app and sign in with that email and password.

## Where it runs

GitHub Pages serves this repo at: https://enjoyyourhaven.github.io/haven-crm/

After any change is pushed, give it a minute, then hard-refresh (Cmd+Shift+R).

## Notes

- Data is protected by login + Row Level Security. Without signing in, nobody can
  read or change anything, even though this repo is public.
- Sign out from the avatar (top right) → Sign Out.
