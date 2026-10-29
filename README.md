# تعافي — T3afy

Team and volunteer management app for addiction-recovery field work. It has two
roles: **مشرف** (supervisor/admin) and **متطوع** (volunteer).

## Run it

Requirements: Flutter 3.47+ and Dart 3.13+.

1. Copy `.env.example` to `.env`, then fill in the Supabase project URL and anon key.
2. Install dependencies and run:

   ```bash
   flutter pub get
   flutter run
   ```

## Build the Android APK

```bash
flutter build apk --release
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

## Backend

The backend is Supabase (Postgres, Realtime and Storage). Two SQL scripts in
`supabase/` set it up:

- `realtime_publication.sql` turns on live updates between the supervisor and
  volunteer apps.
- `missed_tasks_migration.sql` marks overdue tasks as missed.
