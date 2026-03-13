import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:t3afy/volunteer/notifications/presentation/view/widgets/notification_bubble.dart';
import 'package:t3afy/volunteer/notifications/presentation/view/widgets/notifications_app_bar.dart';
import 'package:t3afy/volunteer/notifications/presentation/view/widgets/notifications_empty_state.dart';

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
      appBar: NotificationsAppBar.build(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // ── Body ──
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsStateLoading) {
                    return const LoadingIndicator();
                  }

                  if (state is NotificationsStateError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () {
                        final volunteerId = LocalAppStorage.getUserId();
                        if (volunteerId != null) {
                          context
                              .read<NotificationsCubit>()
                              .loadNotifications(volunteerId);
                        }
                      },
                    );
                  }

                  if (state is NotificationsStateLoaded) {
                    if (state.notes.isEmpty) {
                      return const NotificationsEmptyState();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      itemCount: state.notes.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final n = state.notes[index];
                        return NotificationBubble(
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
