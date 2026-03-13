import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    final volunteerId = LocalAppStorage.getUserId();
    if (volunteerId != null) {
      context.read<NotificationsCubit>().loadNotifications(volunteerId);
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
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 20.sp),
        ),
        centerTitle: true,
        title: Text('الإشعارات',
            style: getBoldStyle(
                color: Colors.white, fontSize: 20.sp)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // ── Body ──
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsStateLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF00ABD2)),
                    );
                  }

                  if (state is NotificationsStateError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              color: Colors.white38, size: 48.sp),
                          SizedBox(height: 12.h),
                          Text(state.message,
                              style: getMediumStyle(
                                  color: Colors.white54, fontSize: 14.sp),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }

                  if (state is NotificationsStateLoaded) {
                    if (state.notes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_off_outlined,
                                color: Colors.white38, size: 64.sp),
                            SizedBox(height: 12.h),
                            Text('لا توجد إشعارات',
                                style: getMediumStyle(
                                    color: Colors.white54, fontSize: 16.sp)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      itemCount: state.notes.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final n = state.notes[index];
                        return _NotificationBubble(
                          notification: n,
                          timeAgo: _timeAgo(n.createdAt),
                          onTap: () {
                            if (!n.isRead) {
                              context
                                  .read<NotificationsCubit>()
                                  .markAsRead(n.id);
                            }
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private bubble widget ──────────────────────────────────────────────────

class _NotificationBubble extends StatelessWidget {
  final AdminNote notification;
  final String timeAgo;
  final VoidCallback onTap;

  const _NotificationBubble({
    required this.notification,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          // Admin avatar
          CircleAvatar(
            radius: 18.sp,
            backgroundColor: const Color(0xFF00ABD2).withValues(alpha: 0.15),
            child: Icon(Icons.support_agent_rounded,
                color: const Color(0xFF00ABD2), size: 18.sp),
          ),
          SizedBox(width: 10.w),

          // Bubble + metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Bubble
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00ABD2),
                            const Color(0xFF02389E)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.sp),
                          topRight: Radius.circular(4.sp),
                          bottomLeft: Radius.circular(16.sp),
                          bottomRight: Radius.circular(16.sp),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (notification.title.isNotEmpty) ...[
                            Text(
                              notification.title,
                              style: getBoldStyle(
                                  color: Colors.white, fontSize: 14.sp),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Text(
                            notification.message,
                            style: getMediumStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.sp),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),

                    // Unread dot
                    if (!isRead)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          width: 8.sp,
                          height: 8.sp,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2DD4BF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Bottom row: time
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(timeAgo,
                        style: getRegularStyle(
                            color: Colors.white38, fontSize: 11.sp)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
