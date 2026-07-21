-- ═══════════════════════════════════════════════════════════════
-- Haven CRM — setup for the SHARED havens-honey-dos project
-- Safe to re-run: uses IF NOT EXISTS / DROP POLICY IF EXISTS.
--
-- The CRM shares this database with the Haven's Honey Do app, so:
--   • The CRM's task table is named crm_tasks (Honey Do owns "tasks").
--   • CRM tables only answer to Robin's emails (allowlist below) —
--     client/tech logins for Honey Do can never see CRM data.
--   • This script also REMOVES the accidental "Signed-in full access"
--     rule that an earlier run left on Honey Do's own tasks table.
--
-- HOW TO RUN: havens-honey-dos project → SQL Editor → paste → Run.
-- Then: Authentication → Users → Add user (one of the allowlist
-- emails + a password, check "Auto Confirm User") to create the login.
-- ═══════════════════════════════════════════════════════════════

-- ── CRM TABLES ──
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

-- Recurring appointments + end times (added 2026-07-20)
alter table public.appointments add column if not exists repeat text;
alter table public.appointments add column if not exists series_id text;
alter table public.appointments add column if not exists end_time text;

create table if not exists public.crm_tasks (
  id       text primary key,
  title    text not null,
  priority text default 'urgent',
  due      date,
  done     boolean default false,
  created  timestamptz default now()
);

create table if not exists public.email_logs (
  id         text primary key,
  contact_id text,
  subject    text not null,
  direction  text default 'sent',
  account    text,
  notes      text,
  date       timestamptz default now()
);

-- ── CRM ADMINS (added 2026-07-20) ──
-- Who can sign in and edit everything. Managed from the app's Settings
-- sheet; each admin also needs a login (Authentication → Add user).
create table if not exists public.crm_admins (
  email text primary key
);

insert into public.crm_admins (email) values
  ('robin@enjoyyourhaven.com'),
  ('robin@hpdallas.com'),
  ('robin@scoutre.net'),
  ('robin@enjoyyouracorn.com')
on conflict (email) do nothing;

create or replace function public.is_crm_admin()
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.crm_admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  )
$$;

alter table public.crm_admins enable row level security;
drop policy if exists "Admins manage admins" on public.crm_admins;
create policy "Admins manage admins" on public.crm_admins
  for all to authenticated using (public.is_crm_admin()) with check (public.is_crm_admin());

-- ── ROW LEVEL SECURITY ──
alter table public.contacts     enable row level security;
alter table public.appointments enable row level security;
alter table public.crm_tasks    enable row level security;
alter table public.email_logs   enable row level security;

-- Remove the old too-open rules from the earlier run (wherever they landed)
drop policy if exists "Signed-in full access" on public.contacts;
drop policy if exists "Signed-in full access" on public.appointments;
drop policy if exists "Signed-in full access" on public.email_logs;
drop policy if exists "Signed-in full access" on public.tasks;      -- Honey Do's table: accidental rule OFF
drop policy if exists "Signed-in full access" on public.crm_tasks;

-- CRM access = Robin's emails only
drop policy if exists "CRM owner access" on public.contacts;
create policy "CRM owner access" on public.contacts
  for all to authenticated
  using (public.is_crm_admin())
  with check (public.is_crm_admin());

drop policy if exists "CRM owner access" on public.appointments;
create policy "CRM owner access" on public.appointments
  for all to authenticated
  using (public.is_crm_admin())
  with check (public.is_crm_admin());

drop policy if exists "CRM owner access" on public.crm_tasks;
create policy "CRM owner access" on public.crm_tasks
  for all to authenticated
  using (public.is_crm_admin())
  with check (public.is_crm_admin());

drop policy if exists "CRM owner access" on public.email_logs;
create policy "CRM owner access" on public.email_logs
  for all to authenticated
  using (public.is_crm_admin())
  with check (public.is_crm_admin());
