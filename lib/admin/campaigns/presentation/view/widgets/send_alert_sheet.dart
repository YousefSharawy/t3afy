import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class SendAlertSheet extends StatefulWidget {
  const SendAlertSheet({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  State<SendAlertSheet> createState() => _SendAlertSheetState();
}

class _SendAlertSheetState extends State<SendAlertSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final sent = await context.read<CampaignDetailCubit>().sendAlert(
      taskId: widget.detail.id,
      adminId: LocalAppStorage.getUserId() ?? '',
      title: _titleCtrl.text.trim(),
      body: _bodyCtrl.text.trim(),
      volunteerIds: widget.detail.members.map((m) => m.id).toList(),
    );
    if (!mounted) return;
    // On failure the error is toasted by the detail screen; keep the text.
    if (sent) {
      Navigator.pop(context);
    } else {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          Space.gutter,
          Space.vm,
          Space.gutter,
          Space.vl + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorManager.line,
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                  ),
                ),
                SizedBox(height: Space.vl),
                Text('إرسال تنبيه للفريق', style: AppText.title()),
                SizedBox(height: Space.vxs),
                Text(
                  'سيصل التنبيه لجميع المتطوعين المعيّنين (${widget.detail.members.length})',
                  style: AppText.label(),
                ),
                SizedBox(height: Space.vl),
                PrimaryTextFF(
                  controller: _titleCtrl,
                  hint: 'عنوان التنبيه',
                  validator: _required,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: Space.vm),
                PrimaryTextFF(
                  controller: _bodyCtrl,
                  hint: 'نص التنبيه',
                  maxLines: 4,
                  validator: _required,
                ),
                SizedBox(height: Space.vxl),
                PrimaryElevatedButton(
                  title: 'إرسال التنبيه',
                  isLoading: _sending,
                  onPress: _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
