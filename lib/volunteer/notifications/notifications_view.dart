import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
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

  Future<void> _onClearAll(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'مسح الإشعارات',
      body: 'هل تريد حذف جميع الإشعارات؟',
      confirmLabel: 'مسح الكل',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      final volunteerId = LocalAppStorage.getUserId();
      if (volunteerId != null) {
        context.read<NotificationsCubit>().clearAllNotifications(volunteerId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final hasNotes =
            state is NotificationsStateLoaded && state.notes.isNotEmpty;
        return PrimaryScaffold(
          appBar: NotificationsAppBar.build(
            context,
            onClearAll: hasNotes ? () => _onClearAll(context) : null,
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // ── Body ──
                Expanded(
                  child: Builder(
                    builder: (context) {
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
                        final volunteerId = LocalAppStorage.getUserId();
                        Future<void> onRefresh() {
                          if (volunteerId != null) {
                            return context
                                .read<NotificationsCubit>()
                                .loadNotifications(volunteerId);
                          }
                          return Future.value();
                        }

                        if (state.notes.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: onRefresh,
                            color: const Color(0xFF00ABD2),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [NotificationsEmptyState()],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: onRefresh,
                          color: const Color(0xFF00ABD2),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
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
                          ),
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
      },
    );
  }
}
