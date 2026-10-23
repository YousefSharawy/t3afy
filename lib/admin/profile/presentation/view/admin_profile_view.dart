import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/home/data/services/analytics_pdf_service.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/admin/profile/presentation/view/widgets/admin_edit_sheet.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/profile_header_card.dart';
import 'package:t3afy/base/widgets/profile_info_section.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final userId = LocalAppStorage.getUserId();
    if (userId != null) {
      context.read<AdminProfileCubit>().loadProfile(userId);
    }
  }

  Future<void> _refresh() async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    final error = await context.read<AdminProfileCubit>().refresh(userId);
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تسجيل الخروج',
      body: 'هل تريد تسجيل الخروج من حسابك؟',
      confirmLabel: 'تسجيل الخروج',
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;
    HapticFeedback.mediumImpact();
    await context.read<AuthCubit>().logout();
    if (mounted) context.go(Routes.login);
  }

  Future<void> _replayTour() async {
    HapticFeedback.lightImpact();
    await LocalAppStorage.setAdminTutorialCompleted(false);
    if (mounted) context.go(Routes.splash);
  }

  Future<void> _export() async {
    if (_exporting) return;
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'تصدير تقرير شامل',
      body: 'سيتم إنشاء تقرير شامل بجميع بيانات المنصة. قد يستغرق بضع ثوانٍ.',
      confirmLabel: 'تصدير',
    );
    if (!confirmed || !mounted) return;
    setState(() => _exporting = true);
    String? error;
    try {
      await AnalyticsPdfService.exportAndShare();
    } on AnalyticsExportException catch (e) {
      error = e.message;
    } catch (_) {
      error = 'فشل تصدير التقرير';
    }
    if (!mounted) return;
    setState(() => _exporting = false);
    if (error == null) {
      Toast.success.show(context, title: 'تم تصدير التقرير بنجاح');
    } else {
      Toast.error.show(context, title: error);
    }
  }

  void _showEditSheet(AdminProfileEntity profile) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminProfileCubit>(),
        child: AdminEditSheet(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'الملف الشخصي', showBack: true),
            Expanded(
              child: BlocBuilder<AdminProfileCubit, AdminProfileState>(
                builder: (context, state) {
                  final Widget child;
                  if (state is AdminProfileLoaded) {
                    child = _buildContent(state.profile);
                  } else if (state is AdminProfileError) {
                    child = ErrorState(message: state.message, onRetry: _load);
                  } else {
                    child = const _ProfileSkeleton();
                  }
                  return AnimatedSwitcher(
                    duration: AppMotion.of(context),
                    child: KeyedSubtree(
                      key: ValueKey(state.runtimeType),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AdminProfileEntity profile) {
    final joined = profile.joinedAt;
    final joinedDate = joined == null
        ? '—'
        : '${DateAr.month(joined.month)} ${joined.year}';

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.brand,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          Space.gutter,
          0,
          Space.gutter,
          Space.vxl + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeaderCard(
              name: profile.name,
              subtitle: profile.email,
              avatarUrl: profile.avatarUrl,
            ),
            SizedBox(height: Space.vxl),
            Text('معلومات الحساب', style: AppText.title()),
            SizedBox(height: Space.vs),
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
                  value: joinedDate,
                ),
              ],
            ),
            SizedBox(height: Space.vxl),
            PrimaryElevatedButton(
              title: 'تعديل الملف الشخصي',
              icon: AppIcons.edit,
              onPress: () => _showEditSheet(profile),
            ),
            SizedBox(height: Space.vm),
            OutlinedButton.icon(
              onPressed: _exporting ? null : _export,
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(AppSizes.touch),
              ),
              icon: _exporting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorManager.brand,
                      ),
                    )
                  : const Icon(AppIcons.pdf, size: 20),
              label: Text(
                _exporting ? 'جارٍ إنشاء التقرير…' : 'تصدير تقرير تحليلي شامل',
              ),
            ),
            SizedBox(height: Space.vs),
            TextButton.icon(
              onPressed: _replayTour,
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.brand,
                minimumSize: Size.fromHeight(AppSizes.touch),
              ),
              icon: const Icon(AppIcons.refresh, size: 20),
              label: const Text('إعادة الجولة التعريفية'),
            ),
            SizedBox(height: Space.vxl),
            const Divider(color: ColorManager.line, height: 1),
            SizedBox(height: Space.vl),
            TextButton.icon(
              onPressed: _logout,
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.error,
                minimumSize: Size.fromHeight(AppSizes.touch),
              ),
              icon: const Icon(AppIcons.logout, size: 20),
              label: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Space.gutter),
        children: [
          SkeletonBox(height: 150, radius: Radii.card),
          SizedBox(height: Space.vxl),
          SkeletonBox(width: 120, height: 16),
          SizedBox(height: Space.vs),
          SkeletonBox(height: 170, radius: Radii.card),
          SizedBox(height: Space.vxl),
          SkeletonBox(height: AppSizes.touch, radius: Radii.input),
          SizedBox(height: Space.vm),
          SkeletonBox(height: AppSizes.touch, radius: Radii.input),
        ],
      ),
    );
  }
}
