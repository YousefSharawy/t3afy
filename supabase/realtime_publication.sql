-- Realtime publication for T3afy (apply manually in the Supabase SQL editor).
--
-- Probe result (2026-10-23, anon key, Phoenix postgres_changes join):
--   task_reports        -> "Subscribed to PostgreSQL"   (already published)
--   users, tasks, task_assignments, admin_notes, volunteer_locations
--                       -> "Unable to subscribe to changes with given parameters.
--                           Please check Realtime is enabled ..."  (NOT published)
-- So today no manager action (assign, edit/pause campaign, announcement, rating)
-- reaches the volunteer app in realtime, and check-ins / GPS pings do not reach
-- the manager; screens only update on reload / pull-to-refresh / timers.
--
-- Safe to run more than once.

do $$
declare
  t text;
begin
  foreach t in array array[
    'users', 'tasks', 'task_assignments', 'task_reports',
    'admin_notes', 'volunteer_locations'
  ] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;

-- Old-record diffs. With REPLICA IDENTITY FULL an UPDATE/DELETE payload carries
-- the whole previous row, which the app uses to:
--   users            : tell the 60 s presence heartbeat apart from real changes
--                      (rating / level / role) without a refetch;
--   task_assignments : know whose assignment was DELETED (unassign) - with the
--                      default identity the old record only has `id`, and
--                      postgres_changes filters can't be applied to deletes;
--   admin_notes      : same for deleted notes (volunteer_id);
--   task_reports     : status diff on approve / reject.
-- volunteer_locations is insert-only (GPS pings), tasks updates are read from
-- the new record, so both keep the default identity (less WAL).
alter table public.users            replica identity full;
alter table public.task_assignments replica identity full;
alter table public.admin_notes      replica identity full;
alter table public.task_reports     replica identity full;

-- Note: the app connects with the anon key (no Supabase auth session), so
-- Realtime only delivers rows that the `anon` role can SELECT under RLS.
-- If a table has RLS enabled without an anon SELECT policy, its events are
-- silently dropped even after it is published.

-- Verify:
-- select tablename from pg_publication_tables where pubname = 'supabase_realtime' order by 1;
-- select relname, relreplident from pg_class where relname in
--   ('users','tasks','task_assignments','task_reports','admin_notes','volunteer_locations');
--   (relreplident: d = default, f = full)
