import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/home/data/models/analytics_data_model.dart';
import 'package:t3afy/core/utils/pdf_utils.dart';

class AnalyticsPdfService {
  // ── Colors ────────────────────────────────────────────────────────────────
  static const PdfColor _primary = PdfColor.fromInt(0xFF007599);
  static const PdfColor _primaryLight = PdfColor.fromInt(0xFFE6F2F5);
  static const PdfColor _primary200 = PdfColor.fromInt(0xFF8AC0D0);
  static const PdfColor _natural900 = PdfColor.fromInt(0xFF111827);
  static const PdfColor _natural600 = PdfColor.fromInt(0xFF4B5563);
  static const PdfColor _natural200 = PdfColor.fromInt(0xFFD8DCE3);
  static const PdfColor _white = PdfColor.fromInt(0xFFFFFFFF);
  static const PdfColor _bg = PdfColor.fromInt(0xFFF7F8FA);
  static const PdfColor _green = PdfColor.fromInt(0xFF166534);
  static const PdfColor _greenLight = PdfColor.fromInt(0xFFDCFCE7);
  static const PdfColor _orange = PdfColor.fromInt(0xFFD97706);
  static const PdfColor _red = PdfColor.fromInt(0xFFDC2626);
  static const PdfColor _redLight = PdfColor.fromInt(0xFFFEE2E2);

  // ── Data fetching ─────────────────────────────────────────────────────────

  static Future<AnalyticsDataModel> fetchAllData() async {
    final client = Supabase.instance.client;
    final adminName =
        client.auth.currentUser?.userMetadata?['name'] as String? ?? 'المشرف';

    List<dynamic> volunteers = [];
    try {
      volunteers = await client
          .from('users')
          .select('*')
          .inFilter('role', ['volunteer', 'user', 'suspended'])
          .order('name');
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch volunteers: $e');
        debugPrint('Stack trace: $st');
      }
    }

    List<dynamic> campaigns = [];
    try {
      campaigns = await client
          .from('tasks')
          .select('*')
          .order('date', ascending: false);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch campaigns: $e\n$st');
      }
    }

    List<dynamic> assignments = [];
    try {
      assignments = await client
          .from('task_assignments')
          .select(
            '*, tasks(id, title, type, date, duration_hours, points), users!task_assignments_user_id_fkey(name)',
          )
          .order('assigned_at', ascending: false);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch assignments: $e\n$st');
      }
    }

    List<dynamic> reports = [];
    try {
      reports = await client
          .from('task_reports')
          .select('*, tasks(title), users!task_reports_user_id_fkey(name)')
          .order('created_at', ascending: false);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch reports: $e\n$st');
      }
    }

    List<dynamic> assessments = [];
    try {
      assessments = await client
          .from('assessments')
          .select(
            '*, users!assessments_volunteer_id_fkey(name), admin:users!assessments_admin_id_fkey(name)',
          )
          .order('created_at', ascending: false);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to fetch assessments: $e\n$st');
      }
    }

    return AnalyticsDataModel(
      adminName: adminName,
      volunteers: List<Map<String, dynamic>>.from(volunteers),
      campaigns: List<Map<String, dynamic>>.from(campaigns),
      assignments: List<Map<String, dynamic>>.from(assignments),
      reports: List<Map<String, dynamic>>.from(reports),
      assessments: List<Map<String, dynamic>>.from(assessments),
      generatedAt: DateTime.now(),
    );
  }

  // ── PDF generation ────────────────────────────────────────────────────────

  static Future<Map<String, pw.Font>> loadFonts() async {
    return {
      'regular': pw.Font.ttf(
        await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
      ),
      'bold': pw.Font.ttf(
        await rootBundle.load('assets/fonts/Cairo-Bold.ttf'),
      ),
      'semiBold': pw.Font.ttf(
        await rootBundle.load('assets/fonts/Cairo-SemiBold.ttf'),
      ),
      'medium': pw.Font.ttf(
        await rootBundle.load('assets/fonts/Cairo-Medium.ttf'),
      ),
    };
  }

  static Future<Uint8List> generate(
    AnalyticsDataModel data, {
    Map<String, pw.Font>? fonts,
  }) async {
    final pdf = pw.Document();

    try {
      final fontMap = fonts ?? await loadFonts();
      final regular = fontMap['regular']!;
      final bold = fontMap['bold']!;
      final semiBold = fontMap['semiBold']!;
      final medium = fontMap['medium']!;

      final baseTheme = pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          font: regular,
          fontSize: 10,
          color: _natural900,
        ),
      );

      final generatedDate = _fmtDate(data.generatedAt);
      final generatedDateTime =
          '$generatedDate - ${_fmtTime(data.generatedAt)}';

      pw.Widget pageFooter(pw.Context ctx) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: _natural200, width: 0.5),
            ),
          ),
          padding: const pw.EdgeInsets.only(top: 5),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                sanitizeForPdf('سري - للاستخدام الداخلي فقط'),
                style: pw.TextStyle(font: medium, fontSize: 7.5, color: _red),
              ),
              pw.Text(
                sanitizeForPdf(
                  'تعافي | التقرير التحليلي الشامل | صفحة ${ctx.pageNumber} من ${ctx.pagesCount} | $generatedDateTime',
                ),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7.5,
                  color: _natural600,
                ),
              ),
            ],
          ),
        ),
      );

      // ── Cover page ────────────────────────────────────────────────────────
      pdf.addPage(
        pw.Page(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (ctx) => _buildCoverPage(
            bold: bold,
            semiBold: semiBold,
            regular: regular,
            medium: medium,
            data: data,
            generatedDateTime: generatedDateTime,
          ),
        ),
      );

      // ── Executive summary ─────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          footer: pageFooter,
          build: (ctx) => [
            _pageHeader(bold, 'ملخص تنفيذي', 'Executive Summary'),
            pw.SizedBox(height: 14),
            _buildExecutiveSummary(bold, semiBold, regular, medium, data),
          ],
        ),
      );

      // ── Campaign analysis ─────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          footer: pageFooter,
          build: (ctx) => [
            _pageHeader(bold, 'تحليل الحملات', 'Campaign Analysis'),
            pw.SizedBox(height: 14),
            _buildCampaignAnalysis(bold, semiBold, regular, medium, data),
          ],
        ),
      );

      // ── Volunteer analysis ────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          footer: pageFooter,
          build: (ctx) => [
            _pageHeader(bold, 'تحليل المتطوعين', 'Volunteer Analysis'),
            pw.SizedBox(height: 14),
            _buildVolunteerAnalysis(bold, semiBold, regular, medium, data),
          ],
        ),
      );

      // ── GPS / Reports / Assessments ───────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          footer: pageFooter,
          build: (ctx) => [
            _pageHeader(
              bold,
              'الحضور والتقارير والتقييمات',
              'Attendance . Reports . Assessments',
            ),
            pw.SizedBox(height: 14),
            _buildAttendanceSection(bold, semiBold, regular, medium, data),
            pw.SizedBox(height: 18),
            _buildReportsSection(bold, semiBold, regular, medium, data),
            pw.SizedBox(height: 18),
            _buildAssessmentsSection(bold, semiBold, regular, medium, data),
          ],
        ),
      );

      // ── Recommendations ───────────────────────────────────────────────────
      pdf.addPage(
        pw.MultiPage(
          theme: baseTheme,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          footer: pageFooter,
          build: (ctx) => [
            _pageHeader(bold, 'التوصيات', 'Recommendations'),
            pw.SizedBox(height: 14),
            _buildRecommendations(bold, semiBold, regular, data),
          ],
        ),
      );

      return await pdf.save();
    } catch (e) {
      debugPrint('Full PDF failed: $e');
      debugPrint('Generating fallback PDF...');

      final fallbackPdf = pw.Document();
      final fontMap = fonts ?? await loadFonts();
      final regular = fontMap['regular']!;
      final bold = fontMap['bold']!;
      fallbackPdf.addPage(
        pw.Page(
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: regular, bold: bold),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  sanitizeForPdf('تقرير تعافي'),
                  style: pw.TextStyle(font: bold, fontSize: 24),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  sanitizeForPdf('تعذر انشاء التقرير الكامل'),
                  style: pw.TextStyle(font: regular, fontSize: 14),
                ),
                pw.Text(
                  sanitizeForPdf(
                    'Error: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}',
                  ),
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

  // ── Cover page ────────────────────────────────────────────────────────────

  static pw.Widget _buildCoverPage({
    required pw.Font bold,
    required pw.Font semiBold,
    required pw.Font regular,
    required pw.Font medium,
    required AnalyticsDataModel data,
    required String generatedDateTime,
  }) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Stack(
        children: [
          // Background gradient strip
          pw.Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: pw.SizedBox(
              height: PdfPageFormat.a4.height * 0.45,
              child: pw.Container(color: _primary),
            ),
          ),
          pw.Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: pw.SizedBox(
              height: PdfPageFormat.a4.height * 0.55,
              child: pw.Container(color: _bg),
            ),
          ),
          // Content
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 60,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 30),
                // Logo area
                pw.Container(
                  width: 90,
                  height: 90,
                  decoration: pw.BoxDecoration(
                    color: _white,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      sanitizeForPdf('تعافي'),
                      style: pw.TextStyle(
                        font: bold,
                        fontSize: 22,
                        color: _primary,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 28),
                pw.Text(
                  sanitizeForPdf('التقرير التحليلي الشامل'),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: bold, fontSize: 26, color: _white),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  sanitizeForPdf('منصة تعافي لإدارة المتطوعين'),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 14,
                    color: _primary200,
                  ),
                ),
                pw.SizedBox(height: 60),
                // Info card
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: _white,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(12),
                    ),
                    boxShadow: [
                      const pw.BoxShadow(
                        color: PdfColor.fromInt(0x22000000),
                        blurRadius: 8,
                        offset: PdfPoint(0, 3),
                      ),
                    ],
                  ),
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 22,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _coverInfoRow(
                        regular,
                        semiBold,
                        'تاريخ الإصدار',
                        generatedDateTime,
                      ),
                      pw.Divider(color: _natural200, thickness: 0.5),
                      _coverInfoRow(
                        regular,
                        semiBold,
                        'أُعدّ بواسطة',
                        data.adminName,
                      ),
                      pw.Divider(color: _natural200, thickness: 0.5),
                      _coverInfoRow(
                        regular,
                        semiBold,
                        'فترة التقرير',
                        'من ${_fmtDate(data.firstCampaignDate)} إلى ${_fmtDate(data.generatedAt)}',
                      ),
                      pw.Divider(color: _natural200, thickness: 0.5),
                      _coverInfoRow(
                        regular,
                        semiBold,
                        'إجمالي المتطوعين',
                        '${data.totalVolunteers} متطوع',
                      ),
                      pw.Divider(color: _natural200, thickness: 0.5),
                      _coverInfoRow(
                        regular,
                        semiBold,
                        'إجمالي الحملات',
                        '${data.totalCampaigns} حملة',
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: _redLight,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(20),
                    ),
                  ),
                  child: pw.Text(
                    sanitizeForPdf('سري - للاستخدام الداخلي فقط'),
                    style: pw.TextStyle(font: medium, fontSize: 9, color: _red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _coverInfoRow(
    pw.Font regular,
    pw.Font semiBold,
    String label,
    String value,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            sanitizeForPdf(label),
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 10,
              color: _natural600,
            ),
          ),
          pw.Text(
            sanitizeForPdf(value),
            style: pw.TextStyle(
              font: regular,
              fontSize: 10,
              color: _natural900,
            ),
          ),
        ],
      ),
    );
  }

  // ── Page header ────────────────────────────────────────────────────────────

  static pw.Widget _pageHeader(
    pw.Font bold,
    String arabicTitle,
    String engSubtitle,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: pw.BoxDecoration(
          color: _primary,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              sanitizeForPdf(arabicTitle),
              style: pw.TextStyle(font: bold, fontSize: 15, color: _white),
            ),
            pw.Text(
              sanitizeForPdf(engSubtitle),
              style: pw.TextStyle(font: bold, fontSize: 9, color: _primary200),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ──────────────────────────────────────────────────────────

  static pw.Widget _sectionTitle(pw.Font bold, String title) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: pw.BoxDecoration(
          color: _primaryLight,
          border: const pw.Border(
            right: pw.BorderSide(color: _primary, width: 3),
          ),
        ),
        child: pw.Text(
          sanitizeForPdf(title),
          style: pw.TextStyle(font: bold, fontSize: 11, color: _primary),
        ),
      ),
    );
  }

  // ── Executive summary ──────────────────────────────────────────────────────

  static pw.Widget _buildExecutiveSummary(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    final metrics = [
      // Volunteers
      ('إجمالي المتطوعين', '${data.totalVolunteers}', _primary),
      ('المتطوعون النشطون', '${data.activeVolunteers}', _green),
      ('قيد المراجعة', '${data.pendingVolunteers}', _orange),
      ('الموقوفون', '${data.suspendedVolunteers}', _red),
      // Campaigns
      ('إجمالي الحملات', '${data.totalCampaigns}', _primary),
      ('الحملات المكتملة', '${data.completedCampaigns}', _green),
      ('الحملات الجارية', '${data.activeCampaigns}', _orange),
      ('الحملات القادمة', '${data.upcomingCampaigns}', _primary),
      // Hours / points
      (
        'إجمالي ساعات التطوع',
        '${data.totalPlannedHours.toStringAsFixed(0)} س',
        _primary,
      ),
      (
        'الساعات المؤكدة بـ GPS',
        '${data.totalVerifiedHours.toStringAsFixed(0)} س',
        _green,
      ),
      ('إجمالي النقاط الممنوحة', '${data.totalPoints}', _primary),
      // Rates
      ('متوسط تقييم المتطوعين', data.averageRating.toStringAsFixed(1), _orange),
      (
        'معدل الحضور المؤكد',
        '${data.attendanceRate.toStringAsFixed(1)}%',
        _primary,
      ),
      (
        'معدل تقديم التقارير',
        '${data.reportSubmissionRate.toStringAsFixed(1)}%',
        _primary,
      ),
      // Reports
      ('التقارير المقبولة', '${data.approvedReports}', _green),
      ('التقارير المرفوضة', '${data.rejectedReports}', _red),
    ];

    // 4 per row
    final rows = <pw.Widget>[];
    for (int i = 0; i < metrics.length; i += 4) {
      final rowItems = metrics.sublist(i, (i + 4).clamp(0, metrics.length));
      rows.add(
        pw.Row(
          children: [
            for (int j = 0; j < rowItems.length; j++) ...[
              pw.Expanded(
                child: _metricBox(
                  bold: bold,
                  semiBold: semiBold,
                  label: rowItems[j].$1,
                  value: rowItems[j].$2,
                  color: rowItems[j].$3,
                ),
              ),
              if (j < rowItems.length - 1) pw.SizedBox(width: 7),
            ],
            // Fill remaining spots so last row aligns
            for (int k = rowItems.length; k < 4; k++) ...[
              pw.SizedBox(width: 7),
              pw.Expanded(child: pw.SizedBox()),
            ],
          ],
        ),
      );
      rows.add(pw.SizedBox(height: 7));
    }

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  static pw.Widget _metricBox({
    required pw.Font bold,
    required pw.Font semiBold,
    required String label,
    required String value,
    required PdfColor color,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: pw.BoxDecoration(
        color: _white,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: _natural200, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            sanitizeForPdf(value),
            style: pw.TextStyle(font: bold, fontSize: 18, color: color),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            sanitizeForPdf(label),
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 8,
              color: _natural600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Campaign analysis ──────────────────────────────────────────────────────

  static pw.Widget _buildCampaignAnalysis(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Status breakdown
          _sectionTitle(bold, 'توزيع الحملات حسب الحالة'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'مكتملة',
                '${data.completedCampaigns}',
                _green,
                _greenLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'جارية',
                '${data.activeCampaigns}',
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'قادمة',
                '${data.upcomingCampaigns}',
                _primary,
                _primaryLight,
              ),
            ],
          ),
          pw.SizedBox(height: 14),

          // Type breakdown
          if (data.campaignTypeDistribution.isNotEmpty) ...[
            _sectionTitle(bold, 'توزيع الحملات حسب النوع'),
            pw.SizedBox(height: 8),
            _buildSimpleTable(
              regular: regular,
              bold: bold,
              headers: [
                'نوع الحملة',
                'العدد',
                'النسبة',
              ].map((e) => sanitizeForPdf(e)).toList(),
              rows: data.campaignTypeDistribution.entries.map((e) {
                final pct = data.totalCampaigns > 0
                    ? (e.value / data.totalCampaigns * 100).toStringAsFixed(1)
                    : '0';
                return [
                  _translateType(e.key),
                  '${e.value}',
                  '$pct%',
                ].map((e) => pdfSafe(e)).toList();
              }).toList(),
              colWidths: [
                const pw.FlexColumnWidth(2.5),
                const pw.FlexColumnWidth(1),
                const pw.FlexColumnWidth(1),
              ],
            ),
            pw.SizedBox(height: 14),
          ],

          // Monthly trend
          _sectionTitle(bold, 'الحملات الشهرية (آخر 12 شهراً)'),
          pw.SizedBox(height: 8),
          _buildSimpleTable(
            regular: regular,
            bold: bold,
            headers: [
              'الشهر',
              'عدد الحملات',
            ].map((e) => sanitizeForPdf(e)).toList(),
            rows: data.campaignsPerMonth.entries.map((e) {
              return [
                _fmtMonthKey(e.key),
                '${e.value}',
              ].map((e) => pdfSafe(e)).toList();
            }).toList(),
            colWidths: [
              const pw.FlexColumnWidth(2),
              const pw.FlexColumnWidth(1),
            ],
          ),
          pw.SizedBox(height: 14),

          // Campaign summary table (top 20 sorted by date)
          _sectionTitle(bold, 'جدول الحملات'),
          pw.SizedBox(height: 8),
          data.campaigns.isEmpty
              ? _emptyState(regular, 'لا توجد حملات مسجلة')
              : _buildCampaignsTable(regular, bold, data),
        ],
      ),
    );
  }

  static pw.Widget _buildCampaignsTable(
    pw.Font regular,
    pw.Font bold,
    AnalyticsDataModel data,
  ) {
    final shown = data.campaigns.take(20).toList();
    return pw.TableHelper.fromTextArray(
      headers: [
        'العنوان',
        'النوع',
        'التاريخ',
        'الحالة',
        'النقاط',
      ].map((e) => sanitizeForPdf(e)).toList(),
      data: shown.map((c) {
        final dateStr = c['date'] as String?;
        return [
          c['title'] as String? ?? '-',
          _translateType(c['type'] as String? ?? ''),
          dateStr != null ? _fmtDateShort(DateTime.tryParse(dateStr)) : '-',
          _translateStatus(c['status'] as String? ?? ''),
          '${(c['points'] as num?) ?? 0}',
        ].map((e) => pdfSafe(e)).toList();
      }).toList(),
      headerStyle: pw.TextStyle(font: bold, fontSize: 8, color: _white),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      cellStyle: pw.TextStyle(font: regular, fontSize: 7.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.2),
        4: const pw.FlexColumnWidth(0.8),
      },
      cellAlignments: {for (int i = 0; i < 5; i++) i: pw.Alignment.centerRight},
      rowDecoration: const pw.BoxDecoration(color: _white),
      oddRowDecoration: const pw.BoxDecoration(color: _bg),
      border: pw.TableBorder.all(color: _natural200, width: 0.4),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    );
  }

  // ── Volunteer analysis ─────────────────────────────────────────────────────

  static pw.Widget _buildVolunteerAnalysis(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    final avgHours = data.activeVolunteers > 0
        ? (data.totalPlannedHours / data.activeVolunteers).toStringAsFixed(1)
        : '0';
    final avgTasks = data.activeVolunteers > 0
        ? (data.volunteers.fold<int>(
                    0,
                    (s, v) => s + ((v['total_tasks'] as num?) ?? 0).toInt(),
                  ) /
                  data.activeVolunteers)
              .toStringAsFixed(1)
        : '0';

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Activity summary
          _sectionTitle(bold, 'ملخص النشاط'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'متوسط الساعات/متطوع',
                avgHours,
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'متوسط المهام/متطوع',
                avgTasks,
                _green,
                _greenLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'متطوعون بدون مهام',
                '${data.inactiveVolunteers}',
                _red,
                _redLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'جدد هذا الشهر',
                '${data.newVolunteersThisMonth}',
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
            ],
          ),
          pw.SizedBox(height: 14),

          // Level distribution
          if (data.levelDistribution.isNotEmpty) ...[
            _sectionTitle(bold, 'توزيع المستويات'),
            pw.SizedBox(height: 8),
            _buildSimpleTable(
              regular: regular,
              bold: bold,
              headers: [
                'المستوى',
                'العنوان',
                'العدد',
              ].map((e) => sanitizeForPdf(e)).toList(),
              rows: data.levelDistribution.entries.map((e) {
                return [
                  'المستوى ${e.key}',
                  _levelTitle(e.key),
                  '${e.value}',
                ].map((e) => pdfSafe(e)).toList();
              }).toList(),
              colWidths: [
                const pw.FlexColumnWidth(1),
                const pw.FlexColumnWidth(1.5),
                const pw.FlexColumnWidth(0.8),
              ],
            ),
            pw.SizedBox(height: 14),
          ],

          // Region distribution
          if (data.regionDistribution.isNotEmpty) ...[
            _sectionTitle(bold, 'توزيع المناطق'),
            pw.SizedBox(height: 8),
            _buildSimpleTable(
              regular: regular,
              bold: bold,
              headers: [
                'المنطقة',
                'العدد',
                'النسبة',
              ].map((e) => sanitizeForPdf(e)).toList(),
              rows: data.regionDistribution.entries.map((e) {
                final pct = data.totalVolunteers > 0
                    ? (e.value / data.totalVolunteers * 100).toStringAsFixed(1)
                    : '0';
                return [
                  e.key,
                  '${e.value}',
                  '$pct%',
                ].map((e) => pdfSafe(e)).toList();
              }).toList(),
              colWidths: [
                const pw.FlexColumnWidth(2),
                const pw.FlexColumnWidth(0.8),
                const pw.FlexColumnWidth(0.8),
              ],
            ),
            pw.SizedBox(height: 14),
          ],

          // Top 10 by hours
          _sectionTitle(bold, 'أفضل 10 متطوعين - الساعات'),
          pw.SizedBox(height: 8),
          _buildVolunteerRankTable(
            regular,
            bold,
            data.topByHours,
            'الساعات',
            'total_hours',
          ),
          pw.SizedBox(height: 14),

          // Top 10 by points
          _sectionTitle(bold, 'أفضل 10 متطوعين - النقاط'),
          pw.SizedBox(height: 8),
          _buildVolunteerRankTable(
            regular,
            bold,
            data.topByPoints,
            'النقاط',
            'total_points',
          ),
          pw.SizedBox(height: 14),

          // Top 10 by rating
          _sectionTitle(bold, 'أفضل 10 متطوعين - التقييم'),
          pw.SizedBox(height: 8),
          _buildVolunteerRankTable(
            regular,
            bold,
            data.topByRating,
            'التقييم',
            'rating',
          ),
          pw.SizedBox(height: 14),

          // Full volunteer table (first 30)
          _sectionTitle(bold, 'جدول المتطوعين'),
          pw.SizedBox(height: 8),
          data.volunteers.isEmpty
              ? _emptyState(regular, 'لا يوجد متطوعون مسجلون')
              : _buildVolunteerTable(regular, bold, data),
        ],
      ),
    );
  }

  static pw.Widget _buildVolunteerRankTable(
    pw.Font regular,
    pw.Font bold,
    List<Map<String, dynamic>> vols,
    String metricLabel,
    String metricKey,
  ) {
    if (vols.isEmpty) return _emptyState(regular, 'لا توجد بيانات');
    return pw.TableHelper.fromTextArray(
      headers: [
        '#',
        'الاسم',
        'المنطقة',
        metricLabel,
      ].map((e) => sanitizeForPdf(e)).toList(),
      data: vols.asMap().entries.map((e) {
        final v = e.value;
        final metricVal = v[metricKey];
        final display = metricVal is double
            ? metricVal.toStringAsFixed(1)
            : (metricVal?.toString() ?? '0');
        return [
          '${e.key + 1}',
          v['name'] as String? ?? '-',
          v['region'] as String? ?? '-',
          display,
        ].map((e) => pdfSafe(e)).toList();
      }).toList(),
      headerStyle: pw.TextStyle(font: bold, fontSize: 8, color: _white),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      cellStyle: pw.TextStyle(font: regular, fontSize: 8),
      columnWidths: {
        0: const pw.FlexColumnWidth(0.4),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(0.8),
      },
      cellAlignments: {for (int i = 0; i < 4; i++) i: pw.Alignment.centerRight},
      rowDecoration: const pw.BoxDecoration(color: _white),
      oddRowDecoration: const pw.BoxDecoration(color: _bg),
      border: pw.TableBorder.all(color: _natural200, width: 0.4),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    );
  }

  static pw.Widget _buildVolunteerTable(
    pw.Font regular,
    pw.Font bold,
    AnalyticsDataModel data,
  ) {
    final shown = data.volunteers.take(30).toList();
    return pw.TableHelper.fromTextArray(
      headers: [
        'الاسم',
        'المنطقة',
        'المستوى',
        'التقييم',
        'الساعات',
        'المهام',
        'النقاط',
        'الحالة',
      ].map((e) => sanitizeForPdf(e)).toList(),
      data: shown.map((v) {
        final role = v['role'] as String? ?? '';
        return [
          v['name'] as String? ?? '-',
          v['region'] as String? ?? '-',
          '${(v['level'] as num?) ?? 1}',
          ((v['rating'] as num?) ?? 0).toStringAsFixed(1),
          '${(v['total_hours'] as num?) ?? 0}',
          '${(v['total_tasks'] as num?) ?? 0}',
          '${(v['total_points'] as num?) ?? 0}',
          _translateRole(role),
        ].map((e) => pdfSafe(e)).toList();
      }).toList(),
      headerStyle: pw.TextStyle(font: bold, fontSize: 7.5, color: _white),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      cellStyle: pw.TextStyle(font: regular, fontSize: 7),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.8),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(0.6),
        3: const pw.FlexColumnWidth(0.6),
        4: const pw.FlexColumnWidth(0.7),
        5: const pw.FlexColumnWidth(0.6),
        6: const pw.FlexColumnWidth(0.7),
        7: const pw.FlexColumnWidth(0.9),
      },
      cellAlignments: {for (int i = 0; i < 8; i++) i: pw.Alignment.centerRight},
      rowDecoration: const pw.BoxDecoration(color: _white),
      oddRowDecoration: const pw.BoxDecoration(color: _bg),
      border: pw.TableBorder.all(color: _natural200, width: 0.3),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
    );
  }

  // ── Attendance section ─────────────────────────────────────────────────────

  static pw.Widget _buildAttendanceSection(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle(bold, 'تحليل التحقق من الحضور بـ GPS'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'إجمالي التعيينات',
                '${data.totalAssignments}',
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'موثقة بـ GPS',
                '${data.verifiedAssignments}',
                _green,
                _greenLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'معدل التحقق',
                '${data.attendanceRate.toStringAsFixed(1)}%',
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'متوسط الساعات المؤكدة',
                data.verifiedAssignments > 0
                    ? '${(data.totalVerifiedHours / data.verifiedAssignments).toStringAsFixed(1)} س'
                    : '-',
                _primary,
                _primaryLight,
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'الساعات المخططة',
                '${data.totalPlannedHours.toStringAsFixed(0)} س',
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'الساعات المؤكدة',
                '${data.totalVerifiedHours.toStringAsFixed(0)} س',
                _green,
                _greenLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'نسبة الإنجاز',
                data.totalPlannedHours > 0
                    ? '${(data.totalVerifiedHours / data.totalPlannedHours * 100).toStringAsFixed(1)}%'
                    : '-',
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(child: pw.SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  // ── Reports section ────────────────────────────────────────────────────────

  static pw.Widget _buildReportsSection(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle(bold, 'تحليل التقارير'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'إجمالي التقارير',
                '${data.totalReports}',
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'مقبولة',
                '${data.approvedReports}',
                _green,
                _greenLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'مرفوضة',
                '${data.rejectedReports}',
                _red,
                _redLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'قيد المراجعة',
                '${data.pendingReports}',
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'معدل تقديم التقارير',
                '${data.reportSubmissionRate.toStringAsFixed(1)}%',
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(child: pw.SizedBox()),
              pw.Expanded(child: pw.SizedBox()),
              pw.Expanded(child: pw.SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  // ── Assessments section ────────────────────────────────────────────────────

  static pw.Widget _buildAssessmentsSection(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font medium,
    AnalyticsDataModel data,
  ) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle(bold, 'تحليل التقييمات'),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _pillStat(
                semiBold,
                regular,
                'إجمالي التقييمات',
                '${data.totalAssessments}',
                _primary,
                _primaryLight,
              ),
              pw.SizedBox(width: 8),
              _pillStat(
                semiBold,
                regular,
                'متوسط التقييم',
                data.averageAssessmentRating.toStringAsFixed(1),
                _orange,
                const PdfColor.fromInt(0xFFFEF9C3),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(child: pw.SizedBox()),
              pw.Expanded(child: pw.SizedBox()),
            ],
          ),
          pw.SizedBox(height: 10),
          if (data.totalAssessments > 0) ...[
            _sectionTitle(bold, 'توزيع التقييمات'),
            pw.SizedBox(height: 8),
            _buildSimpleTable(
              regular: regular,
              bold: bold,
              headers: [
                'النجوم',
                'العدد',
                'النسبة',
              ].map((e) => sanitizeForPdf(e)).toList(),
              rows: data.ratingDistribution.entries.map((e) {
                final pct = data.totalAssessments > 0
                    ? (e.value / data.totalAssessments * 100).toStringAsFixed(1)
                    : '0';
                return [
                  '${e.key} / 5',
                  '${e.value}',
                  '$pct%',
                ].map((e) => pdfSafe(e)).toList();
              }).toList(),
              colWidths: [
                const pw.FlexColumnWidth(1),
                const pw.FlexColumnWidth(0.8),
                const pw.FlexColumnWidth(0.8),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Recommendations ────────────────────────────────────────────────────────

  static pw.Widget _buildRecommendations(
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    AnalyticsDataModel data,
  ) {
    final recs = <(String, String, PdfColor)>[];

    if (data.attendanceRate < 70) {
      recs.add((
        'تحسين معدل الحضور',
        'معدل الحضور الحالي ${data.attendanceRate.toStringAsFixed(1)}% - يُوصى بتحسين آلية إشعارات المتطوعين قبيل بدء كل مهمة لرفع معدل الحضور.',
        _orange,
      ));
    }

    if (data.inactiveVolunteers > 0) {
      recs.add((
        'تفعيل المتطوعين الخاملين',
        'يوجد ${data.inactiveVolunteers} متطوع بدون أي مهمة - يُوصى بتوزيع المهام بشكل أفضل أو التواصل معهم لتحديد عوائق المشاركة.',
        _red,
      ));
    }

    if (data.reportSubmissionRate < 50) {
      recs.add((
        'رفع معدل تقديم التقارير',
        'معدل تقديم التقارير ${data.reportSubmissionRate.toStringAsFixed(1)}% - يُوصى بإرسال تذكيرات تلقائية للمتطوعين لتقديم تقاريرهم بعد إنهاء المهام.',
        _orange,
      ));
    }

    final topV = data.topVolunteer;
    if (topV.$2 > 0) {
      recs.add((
        'تكريم أفضل المتطوعين',
        'المتطوع "${topV.$1}" حقق أعلى عدد ساعات (${topV.$2.toStringAsFixed(0)} ساعة) ويستحق التكريم والتقدير أمام بقية الفريق.',
        _green,
      ));
    }

    if (data.pendingVolunteers > 0) {
      recs.add((
        'مراجعة طلبات الانضمام',
        'يوجد ${data.pendingVolunteers} طلب انضمام قيد المراجعة - يُوصى بمراجعتها في أقرب وقت لضمان عدم تأخير قبول المتطوعين الجدد.',
        _primary,
      ));
    }

    if (data.completedCampaigns == 0 && data.totalCampaigns > 0) {
      recs.add((
        'إتمام الحملات',
        'لا توجد حملات مكتملة حتى الآن - يُوصى بمتابعة سير الحملات الجارية وتحديث حالتها بانتظام.',
        _red,
      ));
    }

    if (recs.isEmpty) {
      recs.add((
        'أداء ممتاز',
        'تسير المنصة بشكل جيد - جميع المؤشرات ضمن النطاق المقبول. استمروا في هذا المستوى الرائع!',
        _green,
      ));
    }

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: recs.asMap().entries.map((entry) {
          final i = entry.key;
          final rec = entry.value;
          return pw.Padding(
            padding: pw.EdgeInsets.only(bottom: i < recs.length - 1 ? 10 : 0),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                color: _white,
                border: pw.Border(
                  right: pw.BorderSide(color: rec.$3, width: 4),
                  top: pw.BorderSide(color: _natural200, width: 0.5),
                  bottom: pw.BorderSide(color: _natural200, width: 0.5),
                  left: pw.BorderSide(color: _natural200, width: 0.5),
                ),
              ),
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 22,
                        height: 22,
                        decoration: pw.BoxDecoration(
                          color: rec.$3,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            sanitizeForPdf('${i + 1}'),
                            style: pw.TextStyle(
                              font: bold,
                              fontSize: 10,
                              color: _white,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        sanitizeForPdf(rec.$1),
                        style: pw.TextStyle(
                          font: bold,
                          fontSize: 11,
                          color: rec.$3,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    sanitizeForPdf(rec.$2),
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 9.5,
                      color: _natural600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  static pw.Widget _buildSimpleTable({
    required pw.Font regular,
    required pw.Font bold,
    required List<String> headers,
    required List<List<String>> rows,
    required List<pw.TableColumnWidth> colWidths,
  }) {
    if (rows.isEmpty) return _emptyState(regular, 'لا توجد بيانات');
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.TableHelper.fromTextArray(
        headers: headers,
        data: rows.map((r) => r.map((c) => pdfSafe(c)).toList()).toList(),
        headerStyle: pw.TextStyle(font: bold, fontSize: 8.5, color: _white),
        headerDecoration: const pw.BoxDecoration(color: _primary),
        cellStyle: pw.TextStyle(font: regular, fontSize: 8.5),
        columnWidths: {
          for (int i = 0; i < colWidths.length; i++) i: colWidths[i],
        },
        cellAlignments: {
          for (int i = 0; i < headers.length; i++) i: pw.Alignment.centerRight,
        },
        rowDecoration: const pw.BoxDecoration(color: _white),
        oddRowDecoration: const pw.BoxDecoration(color: _bg),
        border: pw.TableBorder.all(color: _natural200, width: 0.4),
        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
    );
  }

  static pw.Widget _pillStat(
    pw.Font semiBold,
    pw.Font regular,
    String label,
    String value,
    PdfColor color,
    PdfColor bg,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: pw.BoxDecoration(
          color: bg,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: color, width: 0.6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              sanitizeForPdf(value),
              style: pw.TextStyle(font: semiBold, fontSize: 14, color: color),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              sanitizeForPdf(label),
              style: pw.TextStyle(
                font: regular,
                fontSize: 7.5,
                color: _natural600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _emptyState(pw.Font regular, String msg) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 16),
      decoration: pw.BoxDecoration(
        color: _bg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: _natural200, width: 0.5),
      ),
      child: pw.Center(
        child: pw.Text(
          sanitizeForPdf(msg),
          style: pw.TextStyle(font: regular, fontSize: 10, color: _natural600),
        ),
      ),
    );
  }

  // ── Translation helpers ───────────────────────────────────────────────────

  static String _translateType(String t) {
    switch (t) {
      case 'field':
        return 'ميداني';
      case 'remote':
        return 'عن بُعد';
      case 'training':
        return 'تدريبي';
      case 'awareness':
        return 'توعوي';
      case 'school_visit':
        return 'زيارة مدرسية';
      default:
        return t.isEmpty ? '-' : t;
    }
  }

  static String _translateStatus(String s) {
    switch (s) {
      case 'completed':
        return 'مكتملة';
      case 'active':
        return 'جارية';
      case 'upcoming':
        return 'قادمة';
      case 'cancelled':
        return 'ملغاة';
      case 'pending':
        return 'معلقة';
      default:
        return s.isEmpty ? '-' : s;
    }
  }

  static String _translateRole(String r) {
    switch (r) {
      case 'volunteer':
        return 'متطوع';
      case 'admin':
        return 'مشرف';
      case 'user':
        return 'قيد المراجعة';
      case 'suspended':
        return 'موقوف';
      default:
        return r;
    }
  }

  static String _levelTitle(int lvl) {
    if (lvl <= 2) return 'مبتدئ';
    if (lvl <= 5) return 'نشيط';
    if (lvl <= 9) return 'متقدم';
    return 'خبير';
  }

  static String _fmtDate(DateTime dt) =>
      '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';

  static String _fmtDateShort(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  static String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  static String _fmtMonthKey(String key) {
    // key = 'YYYY-MM'
    final parts = key.split('-');
    if (parts.length != 2) return key;
    final year = parts[0];
    const months = [
      '',
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
    final m = int.tryParse(parts[1]) ?? 0;
    return '${months[m.clamp(0, 12)]} $year';
  }
}
