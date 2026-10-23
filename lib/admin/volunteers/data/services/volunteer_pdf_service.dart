import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:t3afy/core/utils/pdf_utils.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

/// Builds the volunteer report PDF.
///
/// Perf: font bytes are loaded from the bundle once and cached in static
/// fields; the ID photo is downloaded on the main isolate (async I/O, no jank);
/// the CPU-heavy part — font parsing, layout and `save()` — runs in a
/// background isolate via [Isolate.run], falling back to the main isolate if
/// spawning fails.
class VolunteerPdfService {
  // Brand palette (mirrors ColorManager tokens).
  static const PdfColor _brand = PdfColor.fromInt(0xFF00728F);
  static const PdfColor _brandSoft = PdfColor.fromInt(0xFFE3F1F4);
  static const PdfColor _ink = PdfColor.fromInt(0xFF0B2A33);
  static const PdfColor _inkMuted = PdfColor.fromInt(0xFF4A6169);
  static const PdfColor _line = PdfColor.fromInt(0xFFD7E3E6);
  static const PdfColor _canvas = PdfColor.fromInt(0xFFEEF5F6);
  static const PdfColor _sprout = PdfColor.fromInt(0xFF2FA37A);
  static const PdfColor _star = PdfColor.fromInt(0xFFF2B230);
  static const PdfColor _white = PdfColor.fromInt(0xFFFFFFFF);

  static const _fontDir = 'assets/fonts/IBMPlexSansArabic';
  static ByteData? _regularData;
  static ByteData? _boldData;
  static ByteData? _semiBoldData;

  static Future<void> _ensureFonts() async {
    _regularData ??= await rootBundle.load('$_fontDir-Regular.ttf');
    _boldData ??= await rootBundle.load('$_fontDir-Bold.ttf');
    _semiBoldData ??= await rootBundle.load('$_fontDir-SemiBold.ttf');
  }

  static Future<Uint8List> generate({
    required VolunteerDetailsEntity details,
    required List<Map<String, dynamic>> assessments,
    required List<Map<String, dynamic>> tasks,
  }) async {
    await _ensureFonts();
    final regular = _regularData!;
    final bold = _boldData!;
    final semiBold = _semiBoldData!;

    Uint8List? idImage;
    if (details.idFileUrl != null && details.idFileUrl!.isNotEmpty) {
      idImage = await _fetchImage(details.idFileUrl!);
    }

    Future<Uint8List> render() => _render(
      details: details,
      assessments: assessments,
      tasks: tasks,
      regularData: regular,
      boldData: bold,
      semiBoldData: semiBold,
      idImageBytes: idImage,
    );

    try {
      return await Isolate.run(render);
    } catch (e) {
      debugPrint('PDF isolate failed, rendering on main isolate: $e');
      return render();
    }
  }

  static Future<Uint8List> _render({
    required VolunteerDetailsEntity details,
    required List<Map<String, dynamic>> assessments,
    required List<Map<String, dynamic>> tasks,
    required ByteData regularData,
    required ByteData boldData,
    required ByteData semiBoldData,
    required Uint8List? idImageBytes,
  }) async {
    final regular = pw.Font.ttf(regularData);
    final bold = pw.Font.ttf(boldData);
    final semiBold = pw.Font.ttf(semiBoldData);
    final pdf = pw.Document();
    try {
      final baseTheme = pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          font: regular,
          fontSize: 10,
          color: _ink,
        ),
      );

      final pw.ImageProvider? idImage = idImageBytes == null
          ? null
          : pw.MemoryImage(idImageBytes);
      final now = DateTime.now();
      final generatedDate = _formatDate(now);

      pw.Widget footer(pw.Context ctx) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: _line, width: 0.5),
            ),
          ),
          padding: const pw.EdgeInsets.only(top: 6),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                sanitizeForPdf('صفحة ${ctx.pageNumber} من ${ctx.pagesCount}'),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 8,
                  color: _inkMuted,
                ),
              ),
              pw.Text(
                sanitizeForPdf(
                  'تم إنشاء هذا التقرير بواسطة تطبيق تعافي | $generatedDate',
                ),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 8,
                  color: _inkMuted,
                ),
              ),
            ],
          ),
        ),
      );

      // ── Page 1: Personal Profile ──────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          footer: footer,
          build: (ctx) => [
            _buildPageHeader(bold, semiBold, details.name, generatedDate),
            pw.SizedBox(height: 16),
            _buildPersonalInfo(regular, bold, semiBold, details),
            pw.SizedBox(height: 16),
            if (idImage != null) ...[
              _buildSectionTitle(bold, 'صورة الهوية'),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.ClipRRect(
                  horizontalRadius: 6,
                  verticalRadius: 6,
                  child: pw.Image(idImage, height: 160, fit: pw.BoxFit.contain),
                ),
              ),
              pw.SizedBox(height: 16),
            ],
            _buildStatsBox(bold, semiBold, regular, details),
          ],
        ),
      );

      // ── Page 2: Task History ──────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          footer: footer,
          build: (ctx) => [
            _buildPageSubHeader(bold, 'سجل المهام'),
            pw.SizedBox(height: 12),
            tasks.isEmpty
                ? _buildEmptyState(regular, 'لا توجد مهام مسجلة')
                : _buildTasksTable(regular, bold, semiBold, tasks),
          ],
        ),
      );

      // ── Page 3: Performance & Assessments ────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          footer: footer,
          build: (ctx) => [
            _buildPageSubHeader(bold, 'الأداء والتقييمات'),
            pw.SizedBox(height: 12),
            _buildAttendanceSummary(regular, bold, semiBold, tasks),
            pw.SizedBox(height: 16),
            if (details.volunteerAreas.isNotEmpty) ...[
              _buildSectionTitle(bold, 'مجالات التطوع'),
              pw.SizedBox(height: 8),
              _buildAreaChips(regular, details.volunteerAreas),
              pw.SizedBox(height: 16),
            ],
            _buildSectionTitle(bold, 'سجل التقييمات'),
            pw.SizedBox(height: 8),
            assessments.isEmpty
                ? _buildEmptyState(regular, 'لا توجد تقييمات مسجلة')
                : _buildAssessmentsTable(regular, bold, assessments),
          ],
        ),
      );

      return await pdf.save();
    } catch (e) {
      debugPrint('Full PDF failed: $e');
      debugPrint('Generating fallback PDF...');

      final fallbackPdf = pw.Document();
      fallbackPdf.addPage(
        pw.Page(
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: regular, bold: bold),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  sanitizeForPdf('تقرير المتطوع'),
                  style: pw.TextStyle(font: bold, fontSize: 24),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  sanitizeForPdf('تعذر انشاء التقرير الكامل'),
                  style: pw.TextStyle(font: regular, fontSize: 14),
                ),
                pw.Text(
                  'Error: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
      );
      return await fallbackPdf.save();
    }
  }

  // ── Header ────────────────────────────────────────────────────────────────

  static pw.Widget _buildPageHeader(
    pw.Font bold,
    pw.Font semiBold,
    String volunteerName,
    String date,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          color: _brand,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  sanitizeForPdf('تقرير بيانات المتطوع'),
                  style: pw.TextStyle(font: bold, fontSize: 16, color: _white),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  sanitizeForPdf(volunteerName),
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 13,
                    color: _white,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  sanitizeForPdf('تطبيق تعافي'),
                  style: pw.TextStyle(font: bold, fontSize: 14, color: _white),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  sanitizeForPdf(date),
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 9,
                    color: _white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildPageSubHeader(pw.Font bold, String title) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: pw.BoxDecoration(
          color: _brand,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        child: pw.Text(
          sanitizeForPdf(title),
          style: pw.TextStyle(font: bold, fontSize: 14, color: _white),
        ),
      ),
    );
  }

  static pw.Widget _buildSectionTitle(pw.Font bold, String title) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: pw.BoxDecoration(
          color: _brandSoft,
          border: const pw.Border(
            right: pw.BorderSide(color: _brand, width: 3),
          ),
        ),
        child: pw.Text(
          sanitizeForPdf(title),
          style: pw.TextStyle(font: bold, fontSize: 11, color: _brand),
        ),
      ),
    );
  }

  // ── Personal Info ─────────────────────────────────────────────────────────

  static pw.Widget _buildPersonalInfo(
    pw.Font regular,
    pw.Font bold,
    pw.Font semiBold,
    VolunteerDetailsEntity details,
  ) {
    final rows = [
      ('الاسم', details.name),
      ('البريد الإلكتروني', details.email ?? '-'),
      ('الهاتف', details.phone ?? '-'),
      ('المنطقة', details.region ?? '-'),
      ('المؤهل', details.qualification ?? '-'),
      (
        'تاريخ الانضمام',
        details.joinedAt != null ? _formatDate(details.joinedAt!) : '-',
      ),
      ('حالة الحساب', details.status),
      (
        'الدور',
        details.role == 'volunteer'
            ? 'متطوع'
            : details.role == 'admin'
            ? 'مشرف'
            : 'قيد المراجعة',
      ),
    ];

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(bold, 'البيانات الشخصية'),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _line, width: 0.5),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              children: rows.asMap().entries.map((entry) {
                final isEven = entry.key.isEven;
                return pw.Container(
                  color: isEven ? _canvas : _white,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 120,
                        child: pw.Text(
                          sanitizeForPdf(entry.value.$1),
                          style: pw.TextStyle(
                            font: semiBold,
                            fontSize: 10,
                            color: _inkMuted,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          sanitizeForPdf(entry.value.$2),
                          style: pw.TextStyle(font: regular, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Box ─────────────────────────────────────────────────────────────

  static pw.Widget _buildStatsBox(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    VolunteerDetailsEntity details,
  ) {
    final stats = [
      ('المستوى', '${details.level} - ${details.levelTitle}'),
      ('التقييم', '${details.rating.toStringAsFixed(1)} / 5'),
      ('إجمالي الساعات', '${details.totalHours} ساعة'),
      ('إجمالي المهام', '${details.totalTasks} مهمة'),
      ('إجمالي النقاط', '${details.totalPoints} نقطة'),
      ('الأماكن المزارة', '${details.placesVisited} مكان'),
    ];

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(bold, 'الإحصائيات'),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: stats.map((s) {
              return pw.Container(
                width: 155,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: pw.BoxDecoration(
                  color: _brandSoft,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                  border: pw.Border.all(color: _brand, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      sanitizeForPdf(s.$1),
                      style: pw.TextStyle(
                        font: semiBold,
                        fontSize: 9,
                        color: _brand,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      sanitizeForPdf(s.$2),
                      style: pw.TextStyle(font: bold, fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Tasks Table ───────────────────────────────────────────────────────────

  static pw.Widget _buildTasksTable(
    pw.Font regular,
    pw.Font bold,
    pw.Font semiBold,
    List<Map<String, dynamic>> tasks,
  ) {
    final headers = [
      'المهمة',
      'النوع',
      'التاريخ',
      'الحالة',
      'المدة',
      'الحضور',
      'الانصراف',
      'الساعات المؤكدة',
      'تم التحقق',
    ];

    final colWidths = [
      pw.FlexColumnWidth(2.2),
      pw.FlexColumnWidth(1.2),
      pw.FlexColumnWidth(1.2),
      pw.FlexColumnWidth(1.0),
      pw.FlexColumnWidth(0.9),
      pw.FlexColumnWidth(1.1),
      pw.FlexColumnWidth(1.1),
      pw.FlexColumnWidth(1.2),
      pw.FlexColumnWidth(0.9),
    ];

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.TableHelper.fromTextArray(
        headers: headers,
        data: tasks.map((t) {
          final task = t['tasks'] as Map<String, dynamic>?;
          final isVerified = (t['is_verified'] as bool?) ?? false;
          final checkedIn = t['checked_in_at'] as String?;
          final checkedOut = t['checked_out_at'] as String?;
          final assignedAt = t['assigned_at'] as String?;
          final verifiedHours = t['verified_hours'];
          final status = t['status'] as String? ?? '';
          return [
            task?['title'] as String? ?? '-',
            _translateTaskType(task?['type'] as String? ?? ''),
            assignedAt != null
                ? _formatDateShort(DateTime.tryParse(assignedAt))
                : '-',
            _translateStatus(status),
            '${((task?['duration_hours'] as num?) ?? 0).toStringAsFixed(1)} س',
            checkedIn != null ? _formatTime(DateTime.tryParse(checkedIn)) : '-',
            checkedOut != null
                ? _formatTime(DateTime.tryParse(checkedOut))
                : '-',
            verifiedHours != null
                ? '${(verifiedHours as num).toStringAsFixed(1)} س'
                : '-',
            isVerified ? 'نعم' : 'لا',
          ].map((e) => pdfSafe(e)).toList();
        }).toList(),
        headerStyle: pw.TextStyle(font: bold, fontSize: 8, color: _white),
        headerDecoration: const pw.BoxDecoration(color: _brand),
        cellStyle: pw.TextStyle(font: regular, fontSize: 7.5),
        cellAlignments: {
          for (int i = 0; i < headers.length; i++) i: pw.Alignment.centerRight,
        },
        columnWidths: {
          for (int i = 0; i < colWidths.length; i++) i: colWidths[i],
        },
        rowDecoration: const pw.BoxDecoration(color: _white),
        oddRowDecoration: const pw.BoxDecoration(color: _canvas),
        border: pw.TableBorder.all(color: _line, width: 0.4),
        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
    );
  }

  // ── Attendance Summary ────────────────────────────────────────────────────

  static pw.Widget _buildAttendanceSummary(
    pw.Font regular,
    pw.Font bold,
    pw.Font semiBold,
    List<Map<String, dynamic>> tasks,
  ) {
    final total = tasks.length;
    final verified = tasks
        .where((t) => (t['is_verified'] as bool?) == true)
        .length;
    final rate = total > 0 ? (verified / total * 100).toStringAsFixed(0) : '0';
    final totalVerifiedHours = tasks.fold<double>(0, (sum, t) {
      final h = t['verified_hours'];
      return sum + (h != null ? (h as num).toDouble() : 0);
    });
    final avgHours = verified > 0
        ? (totalVerifiedHours / verified).toStringAsFixed(1)
        : '0';

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(bold, 'ملخص الحضور'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _statCard(
                bold,
                semiBold,
                'إجمالي المهام المسجلة',
                '$total',
                _brand,
              ),
              pw.SizedBox(width: 8),
              _statCard(
                bold,
                semiBold,
                'المهام الموثقة',
                '$verified',
                _sprout,
              ),
              pw.SizedBox(width: 8),
              _statCard(
                bold,
                semiBold,
                'نسبة الحضور',
                '$rate%',
                _star,
              ),
              pw.SizedBox(width: 8),
              _statCard(
                bold,
                semiBold,
                'متوسط الساعات/مهمة',
                '$avgHours س',
                _brand,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _statCard(
    pw.Font bold,
    pw.Font semiBold,
    String label,
    String value,
    PdfColor color,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 0.8),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              sanitizeForPdf(label),
              style: pw.TextStyle(
                font: semiBold,
                fontSize: 8,
                color: _inkMuted,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              sanitizeForPdf(value),
              style: pw.TextStyle(font: bold, fontSize: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // ── Areas ─────────────────────────────────────────────────────────────────

  static pw.Widget _buildAreaChips(pw.Font regular, List<String> areas) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Wrap(
        spacing: 6,
        runSpacing: 6,
        children: areas.map((area) {
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: pw.BoxDecoration(
              color: _brandSoft,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
              border: pw.Border.all(color: _brand, width: 0.5),
            ),
            child: pw.Text(
              sanitizeForPdf(area),
              style: pw.TextStyle(font: regular, fontSize: 9, color: _brand),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Assessments Table ─────────────────────────────────────────────────────

  static pw.Widget _buildAssessmentsTable(
    pw.Font regular,
    pw.Font bold,
    List<Map<String, dynamic>> assessments,
  ) {
    final headers = ['التاريخ', 'التقييم', 'الملاحظة', 'المقيم'];

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.TableHelper.fromTextArray(
        headers: headers,
        data: assessments.map((a) {
          final createdAt = a['created_at'] as String?;
          final rating = (a['rating'] as num?)?.toInt() ?? 0;
          final adminName =
              (a['users'] as Map<String, dynamic>?)?['name'] as String? ?? '-';
          return [
            createdAt != null
                ? _formatDateShort(DateTime.tryParse(createdAt))
                : '-',
            '$rating / 5',
            a['comment'] as String? ?? '-',
            adminName,
          ].map((e) => pdfSafe(e)).toList();
        }).toList(),
        headerStyle: pw.TextStyle(font: bold, fontSize: 9, color: _white),
        headerDecoration: const pw.BoxDecoration(color: _brand),
        cellStyle: pw.TextStyle(font: regular, fontSize: 9),
        cellAlignments: {
          0: pw.Alignment.centerRight,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(1.2),
          1: const pw.FlexColumnWidth(0.8),
          2: const pw.FlexColumnWidth(2.5),
          3: const pw.FlexColumnWidth(1.2),
        },
        rowDecoration: const pw.BoxDecoration(color: _white),
        oddRowDecoration: const pw.BoxDecoration(color: _canvas),
        border: pw.TableBorder.all(color: _line, width: 0.4),
        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  static pw.Widget _buildEmptyState(pw.Font regular, String message) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 24),
        decoration: pw.BoxDecoration(
          color: _canvas,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: _line, width: 0.5),
        ),
        child: pw.Center(
          child: pw.Text(
            sanitizeForPdf(message),
            style: pw.TextStyle(
              font: regular,
              fontSize: 10,
              color: _inkMuted,
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Future<Uint8List?> _fetchImage(String url) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        final bytes = await response.fold<List<int>>(
          [],
          (acc, chunk) => acc..addAll(chunk),
        );
        client.close();
        return Uint8List.fromList(bytes);
      }
      client.close();
    } catch (_) {}
    return null;
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  static String _formatDateShort(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _translateStatus(String status) {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'active':
        return 'نشطة';
      case 'pending':
        return 'معلقة';
      case 'cancelled':
        return 'ملغاة';
      default:
        return status;
    }
  }

  static String _translateTaskType(String type) {
    switch (type) {
      case 'field':
        return 'ميداني';
      case 'remote':
        return 'عن بُعد';
      case 'training':
        return 'تدريبي';
      default:
        return type;
    }
  }
}
