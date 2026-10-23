import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/notifications/presentation/cubit/admin_notifications_cubit.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/notification_tile.dart';

class AdminNotificationsView extends StatefulWidget {
  const AdminNotificationsView({super.key});

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  final String? _adminId = LocalAppStorage.getUserId();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final id = _adminId;
    if (id != null) {
      context.read<AdminNotificationsCubit>().loadNotifications(id);
    }
  }

  Future<void> _refresh() async {
    final id = _adminId;
    if (id == null) return;
    final error = await context.read<AdminNotificationsCubit>().refresh(id);
    _toastIfError(error);
  }

  Future<void> _markAllRead() async {
    final id = _adminId;
    if (id == null) return;
    final error = await context.read<AdminNotificationsCubit>().markAllAsRead(
      id,
    );
    _toastIfError(error);
  }

  Future<void> _markRead(String noteId) async {
    final error = await context.read<AdminNotificationsCubit>().markAsRead(
      noteId,
    );
    _toastIfError(error);
  }

  void _toastIfError(String? error) {
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'الإشعارات',
              showBack: true,
              actions: [
                BlocSelector<
                  AdminNotificationsCubit,
                  AdminNotificationsState,
                  bool
                >(
                  selector: (state) =>
                      state is AdminNotificationsLoaded &&
                      state.notifications.any((n) => !n.isRead),
                  builder: (context, hasUnread) => hasUnread
                      ? TextButton(
                          onPressed: _markAllRead,
                          style: TextButton.styleFrom(
                            foregroundColor: ColorManager.brand,
                            minimumSize: Size(AppSizes.touch, AppSizes.touch),
                          ),
                          child: const Text('قراءة الكل'),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            Expanded(
              child:
                  BlocBuilder<AdminNotificationsCubit, AdminNotificationsState>(
                    builder: (context, state) {
                      final Widget child;
                      if (state is AdminNotificationsLoaded) {
                        child = RefreshIndicator(
                          onRefresh: _refresh,
                          color: ColorManager.brand,
                          child: state.notifications.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    AppEmptyState(
                                      icon: AppIcons.notification,
                                      title: 'لا توجد إشعارات',
                                      message:
                                          'ستظهر هنا الإشعارات الموجهة إليك',
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    Space.gutter,
                                    0,
                                    Space.gutter,
                                    Space.vxl +
                                        MediaQuery.paddingOf(context).bottom,
                                  ),
                                  itemCount: state.notifications.length,
                                  separatorBuilder: (_, _) =>
                                      SizedBox(height: Space.vm),
                                  itemBuilder: (context, index) {
                                    final n = state.notifications[index];
                                    return NotificationTile(
                                      key: ValueKey(n.id),
                                      title: n.title,
                                      body: n.body,
                                      createdAt: n.createdAt,
                                      isRead: n.isRead,
                                      onTap: n.isRead
                                          ? null
                                          : () => _markRead(n.id),
                                    );
                                  },
                                ),
                        );
                      } else if (state is AdminNotificationsError) {
                        child = ErrorState(
                          message: state.message,
                          onRetry: _load,
                        );
                      } else {
                        child = SkeletonList(
                          count: 6,
                          itemHeight: 88,
                          padding: EdgeInsets.symmetric(
                            horizontal: Space.gutter,
                          ),
                        );
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
}
