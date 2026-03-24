-- =============================================================================
-- Migration: Add 'missed' status to task_assignments and tasks
-- Timezone: Asia/Riyadh (UTC+3)
-- =============================================================================

-- 1A. Backfill existing missed assignments
-- Marks 'assigned' assignments as 'missed' when their task's deadline has passed
UPDATE task_assignments
SET status = 'missed'
FROM tasks
WHERE task_assignments.task_id = tasks.id
  AND task_assignments.status = 'assigned'
  AND (
    tasks.date::date + COALESCE(tasks.time_end::time, '23:59'::time)
  ) < (now() AT TIME ZONE 'Asia/Riyadh');

-- 1B. Backfill existing missed tasks
-- Marks tasks as 'missed' when deadline has passed and no one completed them
UPDATE tasks
SET status = 'missed'
WHERE status IN ('upcoming', 'active')
  AND (
    date::date + COALESCE(time_end::time, '23:59'::time)
  ) < (now() AT TIME ZONE 'Asia/Riyadh')
  AND NOT EXISTS (
    SELECT 1 FROM task_assignments
    WHERE task_assignments.task_id = tasks.id
      AND task_assignments.status = 'completed'
  );

-- 1C. Create reusable function called by the cron job
CREATE OR REPLACE FUNCTION check_missed_tasks()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  -- Mark assignments as missed
  UPDATE task_assignments
  SET status = 'missed'
  FROM tasks
  WHERE task_assignments.task_id = tasks.id
    AND task_assignments.status = 'assigned'
    AND (
      tasks.date::date + COALESCE(tasks.time_end::time, '23:59'::time)
    ) < (now() AT TIME ZONE 'Asia/Riyadh');

  -- Mark tasks as missed
  UPDATE tasks
  SET status = 'missed'
  WHERE status IN ('upcoming', 'active')
    AND (
      date::date + COALESCE(time_end::time, '23:59'::time)
    ) < (now() AT TIME ZONE 'Asia/Riyadh')
    AND NOT EXISTS (
      SELECT 1 FROM task_assignments
      WHERE task_assignments.task_id = tasks.id
        AND task_assignments.status = 'completed'
    );
END;
$$;

-- 1D. Schedule pg_cron job to run every 30 minutes
SELECT cron.schedule(
  'check-missed-tasks',
  '*/30 * * * *',
  $$SELECT check_missed_tasks();$$
);

-- 1E. Verification queries
SELECT count(*) AS missed_assignments FROM task_assignments WHERE status = 'missed';
SELECT count(*) AS missed_tasks FROM tasks WHERE status = 'missed';
SELECT * FROM cron.job WHERE jobname = 'check-missed-tasks';
