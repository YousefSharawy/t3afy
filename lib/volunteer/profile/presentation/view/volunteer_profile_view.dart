import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/profile_badge.dart';
import 'package:t3afy/base/widgets/profile_header_card.dart';
import 'package:t3afy/base/widgets/profile_info_section.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/core/utils/photo_viewer.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';
import 'package:t3afy/volunteer/profile/presentation/view/widgets/profile_logout_button.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

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

  Future<void> _refresh() async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    final error = await context.read<ProfileCubit>().refresh(userId);
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  Future<void> _logout() async {
    HapticFeedback.mediumImpact();
    await context.read<AuthCubit>().logout();
    if (mounted) context.go(Routes.login);
  }

  Future<void> _replayTutorial() async {
    HapticFeedback.lightImpact();
    await LocalAppStorage.setVolunteerTutorialCompleted(false);
    if (mounted) context.go(Routes.splash);
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
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const _ProfileSkeleton(),
                    loading: () => const _ProfileSkeleton(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ProfileEntity profile) {
    final joined = DateAr.tryParse(profile.joinedAt);
    final joinedDate = joined == null
        ? profile.joinedAt
        : '${DateAr.month(joined.month)} ${joined.year}';
    final contact = [
      profile.email,
      profile.phone,
    ].where((s) => s.trim().isNotEmpty).join(' | ');

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.brand,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(
          Space.gutter,
          Space.vs,
          Space.gutter,
          Space.vxl + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          ProfileHeaderCard(
            name: profile.name,
            subtitle: contact,
            avatarUrl: profile.avatarUrl,
            badges: [
              ProfileBadge(
                color: ColorManager.sprout,
                borderColor: ColorManager.sproutSoft,
                label: profile.levelTitle,
              ),
              ProfileBadge(
                color: ColorManager.brand,
                borderColor: ColorManager.brandSoft,
                label: 'المستوى ${profile.level}',
              ),
            ],
          ),
          SizedBox(height: Space.vxl),
          const SectionHeader(title: 'بيانات التطوع'),
          ProfileInfoSection(
            items: [
              ProfileInfoItem(label: 'المنطقة', value: profile.region),
              ProfileInfoItem(label: 'تاريخ الانضمام', value: joinedDate),
              ProfileInfoItem(
                label: 'المؤهل',
                value: profile.qualification,
                hasDivider: false,
              ),
            ],
          ),
          SizedBox(height: Space.vxl),
          const SectionHeader(title: 'الإنجازات'),
          _AchievementsGrid(profile: profile),
          SizedBox(height: Space.vxl),
          const SectionHeader(title: 'صورة الهوية'),
          _IdCard(url: profile.idFileUrl),
          SizedBox(height: Space.vxl),
          OutlinedButton.icon(
            onPressed: _replayTutorial,
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorManager.brand,
              side: const BorderSide(color: ColorManager.brand),
              minimumSize: Size.fromHeight(AppSizes.touch),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.input),
              ),
            ),
            icon: const Icon(AppIcons.refresh),
            label: Text(
              'إعادة الجولة التعريفية',
              style: AppText.bodyStrong(color: ColorManager.brand),
            ),
          ),
          SizedBox(height: Space.vxl),
          const Divider(color: ColorManager.line, height: 1),
          SizedBox(height: Space.vm),
          ProfileLogoutButton(onConfirmed: _logout),
        ],
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  const _AchievementsGrid({required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      StatTile(
        icon: AppIcons.done2,
        tint: ColorManager.sproutText,
        value: '${profile.totalTasks}',
        label: 'مهام مكتملة',
      ),
      StatTile(
        icon: AppIcons.location,
        value: '${profile.placesVisited}',
        label: 'أماكن مزارة',
      ),
      StatTile(
        icon: AppIcons.hours,
        tint: ColorManager.info,
        value: '${profile.totalHours}',
        label: 'إجمالي الساعات',
      ),
      StatTile(
        icon: AppIcons.trophy,
        tint: ColorManager.starText,
        value: '${profile.totalPoints}',
        label: 'النقاط المكتسبة',
      ),
    ];
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) SizedBox(height: Space.vm),
          Row(
            children: [
              Expanded(child: tiles[row * 2]),
              SizedBox(width: Space.m),
              Expanded(child: tiles[row * 2 + 1]),
            ],
          ),
        ],
      ],
    );
  }
}

class _IdCard extends StatelessWidget {
  const _IdCard({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(Space.l),
        decoration: BoxDecoration(
          color: ColorManager.surfaceSunken,
          borderRadius: BorderRadius.circular(Radii.input),
          border: Border.all(color: ColorManager.line),
        ),
        child: Text(
          'لم يتم رفع صورة الهوية',
          textAlign: TextAlign.center,
          style: AppText.label(),
        ),
      );
    }
    final height = 180.h;
    final cacheWidth = (MediaQuery.sizeOf(context).width * 2).round();
    return Semantics(
      button: true,
      label: 'عرض صورة الهوية',
      child: GestureDetector(
        onTap: () => openPhotoViewer(context, url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.card),
          child: AfterTransition(
            placeholder: Skeleton(
              child: SkeletonBox(height: height, radius: Radii.card),
            ),
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              memCacheWidth: cacheWidth,
              placeholder: (_, _) => Skeleton(
                child: SkeletonBox(height: height, radius: Radii.card),
              ),
              errorWidget: (_, _, _) => Container(
                height: height,
                color: ColorManager.surfaceSunken,
                child: const Icon(
                  Icons.broken_image_rounded,
                  size: 40,
                  color: ColorManager.inkFaint,
                ),
              ),
            ),
          ),
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
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: Space.gutter,
          vertical: Space.vs,
        ),
        children: [
          SkeletonBox(height: 150.h, radius: Radii.card),
          SizedBox(height: Space.vxl),
          SkeletonBox(height: 120.h, radius: Radii.card),
          SizedBox(height: Space.vxl),
          SkeletonBox(height: 200.h, radius: Radii.card),
        ],
      ),
    );
  }
}
