import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminReviewSheet extends StatefulWidget {
  const AdminReviewSheet({
    super.key,
    required this.report,
    required this.onUpdated,
  });

  final Map<String, dynamic> report;
  final VoidCallback onUpdated;

  @override
  State<AdminReviewSheet> createState() => _AdminReviewSheetState();
}

class _AdminReviewSheetState extends State<AdminReviewSheet> {
  final _client = Supabase.instance.client;
  final _feedbackCtrl = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _review(String action) async {
    setState(() => _isProcessing = true);
    final adminId = LocalAppStorage.getUserId();
    try {
      await _client.from('task_reports').update({
        'status': action,
        'admin_feedback': _feedbackCtrl.text.trim().isEmpty
            ? null
            : _feedbackCtrl.text.trim(),
        'reviewed_by': adminId,
        'reviewed_at': DateTime.now().toIso8601String(),
      }).eq('id', widget.report['id'] as String);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onUpdated();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.report['status'] as String? ?? 'pending';
    final taskTitle =
        (widget.report['tasks'] as Map<String, dynamic>?)?['title']
            as String? ??
        'مهمة';
    final volunteerName =
        (widget.report['volunteers'] as Map<String, dynamic>?)?['full_name']
            as String? ??
        'متطوع';
    final rating = widget.report['rating'] as int? ?? 0;
    final isPending = status == 'pending';

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0C203B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppHeight.s12),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.s2),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s20,
                vertical: AppHeight.s14,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'مراجعة التقرير',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s16,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 22.r,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF1E3A5F), height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: EdgeInsets.all(AppSize.s20),
                children: [
                  _InfoRow(label: 'المهمة', value: taskTitle),
                  SizedBox(height: AppHeight.s10),
                  _InfoRow(label: 'المتطوع', value: volunteerName),
                  SizedBox(height: AppHeight.s10),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        'التقييم',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(width: AppWidth.s8),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: i < rating
                                ? const Color(0xFFFBBF24)
                                : Colors.white.withValues(alpha: 0.2),
                            size: 16.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s16),
                  const Divider(color: Color(0xFF1E3A5F)),
                  SizedBox(height: AppHeight.s16),
                  _DetailCard(
                    title: 'ملخص المهمة',
                    content: widget.report['summary'] as String? ?? '',
                  ),
                  if (widget.report['challenges'] != null) ...[
                    SizedBox(height: AppHeight.s12),
                    _DetailCard(
                      title: 'التحديات',
                      content: widget.report['challenges'] as String,
                    ),
                  ],
                  if (widget.report['attendees_count'] != null) ...[
                    SizedBox(height: AppHeight.s12),
                    _InfoRow(
                      label: 'عدد الحضور',
                      value: '${widget.report['attendees_count']}',
                    ),
                  ],
                  if (widget.report['materials_distributed'] != null) ...[
                    SizedBox(height: AppHeight.s12),
                    _DetailCard(
                      title: 'المواد الموزعة',
                      content: widget.report['materials_distributed'] as String,
                    ),
                  ],
                  SizedBox(height: AppHeight.s12),
                  _InfoRow(
                    label: 'تحقيق الأهداف',
                    value: (widget.report['objectives_met'] as bool? ?? false)
                        ? 'نعم'
                        : 'لا',
                    valueColor:
                        (widget.report['objectives_met'] as bool? ?? false)
                            ? const Color(0xFF4CAF50)
                            : Colors.red,
                  ),
                  if (widget.report['additional_notes'] != null) ...[
                    SizedBox(height: AppHeight.s12),
                    _DetailCard(
                      title: 'ملاحظات إضافية',
                      content: widget.report['additional_notes'] as String,
                    ),
                  ],
                  if (widget.report['admin_feedback'] != null) ...[
                    SizedBox(height: AppHeight.s12),
                    _DetailCard(
                      title: 'ملاحظات المشرف',
                      content: widget.report['admin_feedback'] as String,
                      titleColor: const Color(0xFF00ABD2),
                    ),
                  ],
                  if (isPending) ...[
                    SizedBox(height: AppHeight.s24),
                    const Divider(color: Color(0xFF1E3A5F)),
                    SizedBox(height: AppHeight.s16),
                    Text(
                      'ملاحظات المراجعة (اختياري)',
                      textAlign: TextAlign.right,
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppHeight.s8),
                    TextFormField(
                      controller: _feedbackCtrl,
                      maxLines: 3,
                      textAlign: TextAlign.right,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب ملاحظاتك للمتطوع...',
                        hintStyle: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s13,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF143764),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                          borderSide:
                              const BorderSide(color: Color(0xFF1E3A5F)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                          borderSide:
                              const BorderSide(color: Color(0xFF00ABD2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s16,
                          vertical: AppHeight.s12,
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.s20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: AppHeight.s48,
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () => _review('rejected'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.s12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'رفض',
                                style: getBoldStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppWidth.s12),
                        Expanded(
                          child: SizedBox(
                            height: AppHeight.s48,
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () => _review('approved'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.s12),
                                ),
                                elevation: 0,
                              ),
                              child: _isProcessing
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      'موافقة',
                                      style: getBoldStyle(
                                        fontFamily: FontConstants.fontFamily,
                                        fontSize: FontSize.s14,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: AppHeight.s24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: valueColor ?? Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.content,
    this.titleColor,
  });

  final String title;
  final String content;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s14),
      decoration: BoxDecoration(
        color: const Color(0xFF143764),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: titleColor ?? const Color(0xFF00ABD2),
            ),
          ),
          SizedBox(height: AppHeight.s6),
          Text(
            content,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
