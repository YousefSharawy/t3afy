/// One place for Arabic date/time text. Replaces the month arrays and
/// time-ago helpers that were copied across screens.
class DateAr {
  static const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  /// Indexed by [DateTime.weekday] - 1 (Monday first).
  static const weekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static DateTime? tryParse(Object? v) {
    if (v == null) return null;
    if (v is DateTime) return v.toLocal();
    return DateTime.tryParse(v.toString())?.toLocal();
  }

  static String month(int m) => months[(m - 1).clamp(0, 11)];
  static String weekday(DateTime d) => weekdays[d.weekday - 1];

  /// 23 أكتوبر 2026
  static String date(DateTime d) => '${d.day} ${month(d.month)} ${d.year}';

  /// 23 أكتوبر
  static String dayMonth(DateTime d) => '${d.day} ${month(d.month)}';

  /// الخميس، 23 أكتوبر
  static String weekdayDate(DateTime d) => '${weekday(d)}، ${dayMonth(d)}';

  /// 3:05 م — correct ص/م (the old code always printed ص).
  static String time(DateTime d) {
    final h12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final mm = d.minute.toString().padLeft(2, '0');
    return '$h12:$mm ${d.hour < 12 ? 'ص' : 'م'}';
  }

  /// Accepts "HH:mm" or "HH:mm:ss" (Postgres `time`) and formats as [time].
  static String timeOfDay(String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return '';
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]);
    final m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (h == null || m == null) return hhmm;
    return time(DateTime(2000, 1, 1, h, m));
  }

  /// 3:00 م – 6:00 م
  static String timeRange(String? start, String? end) {
    final s = timeOfDay(start);
    final e = timeOfDay(end);
    if (s.isEmpty) return e;
    if (e.isEmpty) return s;
    return '$s – $e';
  }

  /// منذ 5 دقائق / منذ ساعتين / أمس / 23 أكتوبر
  static String timeAgo(Object? value) {
    final d = tryParse(value);
    if (d == null) return '';
    final diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${_plural(diff.inMinutes, 'دقيقة', 'دقيقتين', 'دقائق')}';
    if (diff.inHours < 24) return 'منذ ${_plural(diff.inHours, 'ساعة', 'ساعتين', 'ساعات')}';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${_plural(diff.inDays, 'يوم', 'يومين', 'أيام')}';
    return dayMonth(d);
  }

  /// "4 ساعات 30 دقيقة" style duration.
  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h == 0) return _plural(m, 'دقيقة', 'دقيقتين', 'دقائق');
    if (m == 0) return _plural(h, 'ساعة', 'ساعتين', 'ساعات');
    return '${_plural(h, 'ساعة', 'ساعتين', 'ساعات')} $m د';
  }

  static String _plural(int n, String one, String two, String few) {
    if (n == 1) return one;
    if (n == 2) return two;
    if (n >= 3 && n <= 10) return '$n $few';
    return '$n $one';
  }
}
