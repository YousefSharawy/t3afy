import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'alert_field.dart';

class SendAlertSheet extends StatefulWidget {
  const SendAlertSheet({
    super.key,
    required this.detail,
  });

  final CampaignDetailEntity detail;

  @override
  State<SendAlertSheet> createState() => _SendAlertSheetState();
}

class _SendAlertSheetState extends State<SendAlertSheet> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    final adminId = LocalAppStorage.getUserId() ?? '';
    final volunteerIds = widget.detail.members.map((m) => m.id).toList();

    setState(() => _sending = true);
    await context.read<CampaignDetailCubit>().sendAlert(
          taskId: widget.detail.id,
          adminId: adminId,
          title: title,
          body: body,
          volunteerIds: volunteerIds,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppSize.s20),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.blueOne700,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: AppHeight.s16),
            Text(
              'إرسال تنبيه للفريق',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppHeight.s6),
            Text(
              'سيُرسل التنبيه لجميع المتطوعين المعيّنين (${widget.detail.members.length})',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: AppHeight.s20),
            AlertField(
              controller: _titleCtrl,
              hint: 'عنوان التنبيه',
              maxLines: 1,
            ),
            SizedBox(height: AppHeight.s12),
            AlertField(
              controller: _bodyCtrl,
              hint: 'نص التنبيه',
              maxLines: 4,
            ),
            SizedBox(height: AppHeight.s20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.cyanPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                ),
                child: _sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'إرسال التنبيه',
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s14,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
