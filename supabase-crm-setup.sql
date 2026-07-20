-- ═══════════════════════════════════════════════════════════════
-- Haven CRM — Supabase setup
-- Project: sstipdekzaywxxcdrjks (Haven CRM)
-- Safe to re-run: uses IF NOT EXISTS / DROP POLICY IF EXISTS.
--
-- HOW TO RUN: Supabase Dashboard → SQL Editor → paste this → Run.
-- Then: Dashboard → Authentication → Users → Add user
--   (email + password, check "Auto Confirm User") to create your login.
-- ═══════════════════════════════════════════════════════════════

-- ── CONTACTS ──
create table if not exists public.contacts (
  id         text primary key,
  first_name text,
  last_name  text,
  company    text,
  email      text,
  phone      text,
  cat        text default 'networking',
  notes      text,
  color      text,
  added      timestamptz default now()
);

-- ── APPOINTMENTS ──
create table if not exists public.appointments (
  id      text primary key,
  title   text not null,
  date    date not null,
  time    text,
  cat     text default 'work',
  notes   text,
  color   text,
  created timestamptz default now()
);

-- ── TASKS ──
create table if not exists public.tasks (
  id       text primary key,
  title    text not null,
  priority text default 'urgent',
  due      date,
  done     boolean default false,
  created  timestamptz default now()
);

-- ── EMAIL LOGS ──
create table if not exists public.email_logs (
  id         text primary key,
  contact_id text,
  subject    text not null,
  direction  text default 'sent',
  account    text,
  notes      text,
  date       timestamptz default now()
);

-- ── ROW LEVEL SECURITY ──
-- RLS on + policies for signed-in users only. Anyone holding just the
-- public anon key (no login) gets nothing.
alter table public.contacts     enable row level security;
alter table public.appointments enable row level security;
alter table public.tasks        enable row level security;
alter table public.email_logs   enable row level security;

drop policy if exists "Signed-in full access" on public.contacts;
create policy "Signed-in full access" on public.contacts
  for all to authenticated using (true) with check (true);

drop policy if exists "Signed-in full access" on public.appointments;
create policy "Signed-in full access" on public.appointments
  for all to authenticated using (true) with check (true);

drop policy if exists "Signed-in full access" on public.tasks;
create policy "Signed-in full access" on public.tasks
  for all to authenticated using (true) with check (true);

drop policy if exists "Signed-in full access" on public.email_logs;
create policy "Signed-in full access" on public.email_logs
  for all to authenticated using (true) with check (true);
