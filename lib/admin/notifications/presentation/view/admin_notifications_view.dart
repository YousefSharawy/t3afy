import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/notifications/presentation/cubit/admin_notifications_cubit.dart';
import 'package:t3afy/admin/notifications/presentation/view/widgets/admin_notification_card.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

class AdminNotificationsView extends StatefulWidget {
  const AdminNotificationsView({super.key});

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  @override
  void initState() {
    super.initState();
    final adminId = LocalAppStorage.getUserId();
    if (adminId != null) {
      context.read<AdminNotificationsCubit>().loadNotifications(adminId);
    }
  }

  String _timeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
    return 'منذ فترة';
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        centerTitle: true,
        title: Text(
          'الإشعارات',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: ColorManager.blueOne900,
          ),
        ),
        actions: [
          BlocBuilder<AdminNotificationsCubit, AdminNotificationsState>(
            builder: (context, state) {
              if (state is AdminNotificationsLoaded &&
                  state.notifications.any((n) => !n.isRead)) {
                return TextButton(
                  onPressed: () {
                    final adminId = LocalAppStorage.getUserId();
                    if (adminId != null) {
                      context
                          .read<AdminNotificationsCubit>()
                          .markAllAsRead(adminId);
                    }
                  },
                  child: Text(
                    'قراءة الكل',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: ColorManager.primary500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<AdminNotificationsCubit, AdminNotificationsState>(
          builder: (context, state) {
            if (state is AdminNotificationsLoading) {
              return const LoadingIndicator();
            }

            if (state is AdminNotificationsError) {
              return ErrorState(
                message: state.message,
                onRetry: () {
                  final adminId = LocalAppStorage.getUserId();
                  if (adminId != null) {
                    context
                        .read<AdminNotificationsCubit>()
                        .loadNotifications(adminId);
                  }
                },
              );
            }

            if (state is AdminNotificationsLoaded) {
              final adminId = LocalAppStorage.getUserId();

              Future<void> onRefresh() {
                if (adminId != null) {
                  return context
                      .read<AdminNotificationsCubit>()
                      .loadNotifications(adminId);
                }
                return Future.value();
              }

              if (state.notifications.isEmpty) {
                return RefreshIndicator(
                  onRefresh: onRefresh,
                  color: ColorManager.primary500,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 120.h),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              color: ColorManager.natural300,
                              size: 64.sp,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'لا توجد إشعارات',
                              style: getMediumStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontSize: FontSize.s16,
                                color: ColorManager.natural400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: onRefresh,
                color: ColorManager.primary500,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final n = state.notifications[index];
                    return AdminNotificationCard(
                      notification: n,
                      timeAgo: _timeAgo(n.createdAt),
                      onTap: () {
                        if (!n.isRead) {
                          context
                              .read<AdminNotificationsCubit>()
                              .markAsRead(n.id);
                        }
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
