import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';
import 'package:t3afy/volunteer/profile/presentation/view/widgets/profile_header_card.dart';
import 'package:t3afy/volunteer/profile/presentation/view/widgets/profile_info_section.dart';
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

  void _logout() async {
    await context.read<AuthCubit>().logout();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: ColorManager.blueOne600),
            ),
            error: (message) => Center(
              child: Text(
                message,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.error,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
            loaded: (profile) => _buildContent(profile),
          );
        },
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

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: AppWidth.s18, right: AppWidth.s18),
      child: Column(
        children: [
          SizedBox(height: AppHeight.s10),
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
          ProfileHeaderCard(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            levelTitle: profile.levelTitle,
            level: profile.level,
            avatarUrl: profile.avatarUrl,
          ),
          SizedBox(height: AppHeight.s4),
          ProfileInfoSection(
            title: 'بيانات التطوع',
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
          SizedBox(height: AppHeight.s4),
          ProfileInfoSection(
            title: 'الإنجازات',
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
                hasDivider: false,
              ),
            ],
          ),
          SizedBox(height: AppHeight.s16),
          PrimaryElevatedButton(
            backGroundColor: const Color(0xff970909),
            title: "تسجيل خروج",
            onPress: _logout,
            textStyle: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}