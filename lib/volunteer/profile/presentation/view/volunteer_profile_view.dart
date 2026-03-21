import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';
import 'package:t3afy/volunteer/profile/presentation/view/widgets/profile_app_bar.dart';
import 'package:t3afy/base/widgets/profile_header_card.dart';
import 'package:t3afy/base/widgets/profile_info_section.dart';
import 'package:t3afy/base/widgets/profile_badge.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

class VolunteerProfileView extends StatefulWidget {
  const VolunteerProfileView({super.key});

  @override
  State<VolunteerProfileView> createState() => _VolunteerProfileViewState();
}

class _VolunteerProfileViewState extends State<VolunteerProfileView> {
  @override
  void initState() {
    super.initState();
    final userId = LocalAppStorage.getUserId();
    if (userId != null) {
      context.read<ProfileCubit>().loadProfile(userId);
    }
  }

  Future<void> _refresh() {
    final userId = LocalAppStorage.getUserId();
    if (userId != null) return context.read<ProfileCubit>().loadProfile(userId);
    return Future.value();
  }

  void _logout() async {
    await context.read<AuthCubit>().logout();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingIndicator(),
              error: (message) => ErrorState(
                message: message,
                onRetry: () {
                  final userId = LocalAppStorage.getUserId();
                  if (userId != null) {
                    context.read<ProfileCubit>().loadProfile(userId);
                  }
                },
              ),
              loaded: (profile) => _buildContent(profile),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(ProfileEntity profile) {
    String joinedDate = '';
    if (profile.joinedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(profile.joinedAt);
        final months = [
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
      } catch (_) {
        joinedDate = profile.joinedAt;
      }
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: const Color(0xFF00ABD2),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: AppWidth.s18, right: AppWidth.s18),
        child: Column(
          children: [
            SizedBox(height: AppHeight.s20),
            const ProfileAppBar(),
            SizedBox(height: AppHeight.s16),
            ProfileHeaderCard(
              name: profile.name,
              subtitle: '${profile.email} | ${profile.phone}',
              avatarUrl: profile.avatarUrl,
              badges: [
                ProfileBadge(
                  color: ColorManager.success,
                  borderColor: ColorManager.successLight,
                  label: profile.levelTitle,
                ),
                ProfileBadge(
                  color: ColorManager.warning,
                  borderColor: ColorManager.warningLight,
                  label: 'المستوى ${profile.level}',
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            Align(
              alignment: .centerRight,
              child: Text(
                "بيانات التطوع",
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural700,
                ),
              ),
            ),
            SizedBox(height: AppHeight.s8),
            ProfileInfoSection(
              items: [
                ProfileInfoItem(label: 'المنطقة', value: profile.region),
                ProfileInfoItem(label: 'تاريخ الإنضمام', value: joinedDate),
                ProfileInfoItem(
                  label: 'المؤهل',
                  value: profile.qualification,
                  hasDivider: false,
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            Align(
              alignment: .centerRight,
              child: Text(
                "الإنجازات",
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural700,
                ),
              ),
            ),
            SizedBox(height: AppHeight.s4),
            ProfileInfoSection(
              items: [
                ProfileInfoItem(
                  label: 'مهام مكتملة',
                  value: '${profile.totalTasks} مهمة',
                ),
                ProfileInfoItem(
                  label: 'أماكن مزارة',
                  value: '${profile.placesVisited} مكان',
                ),
                ProfileInfoItem(
                  label: 'إجمالي عدد الساعات',
                  value: '${profile.totalHours} ساعة',
                ),
                ProfileInfoItem(
                  label: 'النقاط المكتسبة',
                  value: '${profile.totalPoints} نقطة',
                  hasDivider: false,
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            PrimaryElevatedButton(
              height: AppHeight.s46,
              title: 'تسجيل الخروج',
              onPress: _logout,
              backGroundColor: ColorManager.error,
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: ColorManager.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
