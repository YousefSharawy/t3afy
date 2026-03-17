import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminEditSheet extends StatefulWidget {
  const AdminEditSheet({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.userId,
  });

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final String userId;

  @override
  State<AdminEditSheet> createState() => _AdminEditSheetState();
}

class _AdminEditSheetState extends State<AdminEditSheet> {
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<AdminProfileCubit>().updateProfile(
          userId: widget.userId,
          name: widget.nameCtrl.text.trim(),
          email: widget.emailCtrl.text.trim(),
          phone: widget.phoneCtrl.text.trim().isEmpty
              ? null
              : widget.phoneCtrl.text.trim(),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppWidth.s18,
          right: AppWidth.s18,
          top: AppHeight.s24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تعديل الملف الشخصي',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: ColorManager.white,
              ),
            ),
            SizedBox(height: AppHeight.s20),
            _field(controller: widget.nameCtrl, hint: 'الاسم'),
            SizedBox(height: AppHeight.s12),
            _field(
              controller: widget.emailCtrl,
              hint: 'البريد الإلكتروني',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppHeight.s12),
            _field(
              controller: widget.phoneCtrl,
              hint: 'رقم الهاتف',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppHeight.s20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ABD2),
                  padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                ),
                child: _saving
                    ? SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'حفظ',
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s14,
                          color: ColorManager.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: AppHeight.s24),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: TextDirection.rtl,
      style: getRegularStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s13,
        color: ColorManager.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: ColorManager.white.withValues(alpha: 0.4),
        ),
        filled: true,
        fillColor: ColorManager.blueOne900,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s10),
          borderSide: BorderSide(color: ColorManager.blueOne700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s10),
          borderSide: BorderSide(color: ColorManager.blueOne700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s10),
          borderSide: const BorderSide(color: Color(0xFF00ABD2)),
        ),
      ),
    );
  }
}
