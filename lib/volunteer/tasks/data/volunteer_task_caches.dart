import 'package:t3afy/app/local_storage.dart';

/// Drops every cached list/stat that shows this volunteer's assignments, so a
/// tab opened right after the volunteer's own write (check-in/out, report)
/// reads fresh rows instead of the cached ones (the realtime echo may still be
/// in flight, or realtime may be unavailable).
Future<void> invalidateVolunteerTaskCaches(String userId) => Future.wait([
  LocalAppStorage.invalidateCacheByPrefix('today_tasks_${userId}_'),
  LocalAppStorage.invalidateCacheByPrefix('vol_home_today_${userId}_'),
  LocalAppStorage.invalidateCache('completed_tasks_$userId'),
  LocalAppStorage.invalidateCache('tasks_stats_$userId'),
  LocalAppStorage.invalidateCache('vol_stats_v2_$userId'),
  LocalAppStorage.invalidateCache('perf_stats_$userId'),
  LocalAppStorage.invalidateCache('monthly_hours_$userId'),
]);
