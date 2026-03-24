import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/admin/profile/presentation/view/widgets/admin_edit_sheet.dart';
import 'package:t3afy/base/widgets/profile_info_section.dart';
import 'package:t3afy/base/widgets/profile_header_card.dart';
import 'package:t3afy/base/widgets/profile_badge.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/base/primary_widgets.dart';
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
    HapticFeedback.mediumImpact();
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
      backgroundColor: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s16),
        ),
      ),
      builder: (sheetCtx) {
        return BlocProvider.value(
          value: context.read<AdminProfileCubit>(),
          child: AdminEditSheet(
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

  Future<void> _refresh() {
    final userId = LocalAppStorage.getUserId();
    if (userId != null)
      return context.read<AdminProfileCubit>().loadProfile(userId);
    return Future.value();
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

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.primary500,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: AppHeight.s10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorManager.natural900,
                    size: 24.sp,
                  ),
                ),
                Text(
                  'الملف الشخصي',
                  style: getExtraBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural900,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(width: 36.w),
              ],
            ),
            SizedBox(height: AppHeight.s16),

            ProfileHeaderCard(
              name: profile.name,
              subtitle: profile.email,
              avatarUrl: profile.avatarUrl,
            ),
            SizedBox(height: AppHeight.s16),
            Text(
              "معلومات الحساب",
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural700,
                fontSize: FontSize.s14,
              ),
            ),
             SizedBox(height: AppHeight.s8),
            ProfileInfoSection(
              items: [
                ProfileInfoItem(label: 'الاسم', value: profile.name),
                ProfileInfoItem(
                  label: 'البريد الإلكتروني',
                  value: profile.email,
                ),
                ProfileInfoItem(
                  label: 'رقم الهاتف',
                  value: profile.phone?.isNotEmpty == true
                      ? profile.phone!
                      : '—',
                ),
                ProfileInfoItem(
                  hasDivider: false,
                  label: 'تاريخ الانضمام',
                  value: joinedDate.isNotEmpty ? joinedDate : '—',
                ),
              ],
            ),
            SizedBox(height: AppHeight.s24),
            // Edit button
            PrimaryElevatedButton(
              height: AppHeight.s46,
              title: 'تعديل الملف الشخصي',
              onPress: () {
                HapticFeedback.mediumImpact();
                _showEditSheet(profile);
              },
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: ColorManager.white,
              ),
            ),
            SizedBox(height: AppHeight.s8),
            // Logout button
            PrimaryElevatedButton(
              title: 'تسجيل خروج',
              onPress: _logout,
              backGroundColor: ColorManager.error,
               textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: ColorManager.white,
              ),
            ),

            SizedBox(height: AppHeight.s32),
          ],
        ),
      ),
    );
  }
}
