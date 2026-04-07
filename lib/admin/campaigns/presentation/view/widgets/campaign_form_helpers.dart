import 'package:flutter/material.dart';

const arabicMonths = [
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

String formatArabicDate(DateTime d) =>
    '${d.day} ${arabicMonths[d.month - 1]} ${d.year}';

String formatArabicTime(TimeOfDay t) {
  final h = t.hour;
  final m = t.minute.toString().padLeft(2, '0');
  if (h == 0) return '12:$m ص';
  if (h < 12) return '$h:$m ص';
  if (h == 12) return '12:$m م';
  return '${h - 12}:$m م';
}

String combinedTimeLabel(TimeOfDay? start, TimeOfDay? end) {
  final s = start != null ? formatArabicTime(start) : '--:--';
  final e = end != null ? formatArabicTime(end) : '--:--';
  return '$s - $e';
}
