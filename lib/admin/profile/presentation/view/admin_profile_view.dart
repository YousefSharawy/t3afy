import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/admin/profile/presentation/view/widgets/admin_info_section.dart';
import 'package:t3afy/admin/profile/presentation/view/widgets/admin_profile_header.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  @override
  void initState() {
    super.initState();
    final userId = LocalAppStorage.getUserId();
    if (userId != null) {
      context.read<AdminProfileCubit>().loadProfile(userId);
    }
  }

  void _logout() async {
    await context.read<AuthCubit>().logout();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  void _showEditSheet(AdminProfileEntity profile) {
    final nameCtrl = TextEditingController(text: profile.name);
    final emailCtrl = TextEditingController(text: profile.email);
    final phoneCtrl = TextEditingController(text: profile.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.blueOne800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
      ),
      builder: (sheetCtx) {
        return BlocProvider.value(
          value: context.read<AdminProfileCubit>(),
          child: _EditSheet(
            nameCtrl: nameCtrl,
            emailCtrl: emailCtrl,
            phoneCtrl: phoneCtrl,
            userId: profile.id,
          ),
        );
      },
    ).then((_) {
      final userId = LocalAppStorage.getUserId();
      if (userId != null && mounted) {
        context.read<AdminProfileCubit>().loadProfile(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: SafeArea(
        child: BlocBuilder<AdminProfileCubit, AdminProfileState>(
          builder: (context, state) {
            if (state is AdminProfileLoading) {
              return const LoadingIndicator();
            } else if (state is AdminProfileLoaded) {
              return _buildContent(state.profile);
            } else if (state is AdminProfileUpdateSuccess) {
              return const LoadingIndicator();
            } else if (state is AdminProfileError) {
              return ErrorState(
                message: state.message,
                onRetry: () {
                  final userId = LocalAppStorage.getUserId();
                  if (userId != null) {
                    context.read<AdminProfileCubit>().loadProfile(userId);
                  }
                },
              );
            } else if (state is AdminProfileUpdateError) {
              return ErrorState(
                message: state.message,
                onRetry: () {
                  final userId = LocalAppStorage.getUserId();
                  if (userId != null) {
                    context.read<AdminProfileCubit>().loadProfile(userId);
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(AdminProfileEntity profile) {
    String joinedDate = '';
    if (profile.joinedAt != null) {
      final date = profile.joinedAt!;
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
      joinedDate = '${months[date.month]} ${date.year}';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Column(
        children: [
          SizedBox(height: AppHeight.s10),
          // App bar row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: ColorManager.blueOne900,
                  size: 24.sp,
                ),
              ),
              Text(
                'الملف الشخصي',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueOne900,
                  fontSize: FontSize.s16,
                ),
              ),
              SizedBox(width: 36.w),
            ],
          ),
          SizedBox(height: AppHeight.s24),
          AdminProfileHeader(
            name: profile.name,
            email: profile.email,
            avatarUrl: profile.avatarUrl,
          ),
          SizedBox(height: AppHeight.s4),
          AdminInfoSection(
            title: 'معلومات الحساب',
            items: [
              AdminInfoItem(label: 'الاسم', value: profile.name),
              AdminInfoItem(label: 'البريد الإلكتروني', value: profile.email),
              AdminInfoItem(
                label: 'رقم الهاتف',
                value: profile.phone?.isNotEmpty == true ? profile.phone! : '—',
              ),
              AdminInfoItem(
                label: 'تاريخ الانضمام',
                value: joinedDate.isNotEmpty ? joinedDate : '—',
              ),
            ],
          ),
          SizedBox(height: AppHeight.s16),
          // Edit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showEditSheet(profile),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ABD2),
                padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
              ),
              child: Text(
                'تعديل الملف الشخصي',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          SizedBox(height: AppHeight.s8),
          // Logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff970909),
                padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
              ),
              child: Text(
                'تسجيل خروج',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          SizedBox(height: AppHeight.s16),
          Text(
            'T3afy • v1.0.0',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.blueOne400,
            ),
          ),
          SizedBox(height: AppHeight.s32),
        ],
      ),
    );
  }
}

class _EditSheet extends StatefulWidget {
  const _EditSheet({
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
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
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
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
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
