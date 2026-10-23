import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/notification_tile.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final String? _volunteerId = LocalAppStorage.getUserId();
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    final id = _volunteerId;
    if (id != null) context.read<NotificationsCubit>().loadNotifications(id);
  }

  void _toastIfError(String? error) {
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  Future<void> _refresh() async {
    final id = _volunteerId;
    if (id == null) return;
    _toastIfError(
      await context.read<NotificationsCubit>().loadNotifications(id),
    );
  }

  Future<void> _markAllAsRead() async {
    final id = _volunteerId;
    if (id == null) return;
    _toastIfError(await context.read<NotificationsCubit>().markAllAsRead(id));
  }

  Future<void> _clearAll() async {
    final id = _volunteerId;
    if (id == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'مسح الإشعارات',
      body: 'هل تريد حذف جميع الإشعارات؟ لا يمكن التراجع عن هذا الإجراء.',
      confirmLabel: 'مسح الكل',
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _clearing = true);
    final error = await context
        .read<NotificationsCubit>()
        .clearAllNotifications(id);
    if (!mounted) return;
    setState(() => _clearing = false);
    _toastIfError(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            final notes = state is NotificationsStateLoaded
                ? state.notes
                : null;
            final hasUnread = notes?.any((n) => !n.isRead) ?? false;
            return Column(
              children: [
                AppPageHeader(
                  title: 'التنبيهات والإشعارات',
                  showBack: true,
                  actions: [
                    if (hasUnread)
                      _HeaderAction(
                        label: 'قراءة الكل',
                        color: ColorManager.brand,
                        onPressed: _clearing ? null : _markAllAsRead,
                      ),
                    if (notes != null && notes.isNotEmpty)
                      _clearing
                          ? Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: Space.m,
                              ),
                              child: const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorManager.error,
                                ),
                              ),
                            )
                          : _HeaderAction(
                              label: 'مسح الكل',
                              color: ColorManager.error,
                              onPressed: _clearAll,
                            ),
                  ],
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state is NotificationsStateError) {
      return ErrorState(
        message: state.message,
        onRetry: () {
          final id = _volunteerId;
          if (id != null) {
            context.read<NotificationsCubit>().loadNotifications(id);
          }
        },
      );
    }
    if (state is! NotificationsStateLoaded) {
      return SkeletonList(count: 6, itemHeight: 88);
    }

    final notes = state.notes;
    if (notes.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        color: ColorManager.brand,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 48),
            AppEmptyState(
              title: 'لا توجد إشعارات',
              message: 'ستظهر هنا التنبيهات والملاحظات التي تصلك من المشرفين',
              icon: AppIcons.notification,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.brand,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(
          Space.gutter,
          Space.vs,
          Space.gutter,
          Space.vxl + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: notes.length,
        separatorBuilder: (_, _) => SizedBox(height: Space.vm),
        itemBuilder: (context, index) {
          final n = notes[index];
          return NotificationTile(
            key: ValueKey(n.id),
            title: n.title,
            body: n.message,
            createdAt: n.createdAt,
            isRead: n.isRead,
            onTap: n.isRead
                ? null
                : () async => _toastIfError(
                    await context.read<NotificationsCubit>().markAsRead(n.id),
                  ),
          );
        },
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: Size(AppSizes.touch, AppSizes.touch),
        padding: EdgeInsetsDirectional.symmetric(horizontal: Space.s),
      ),
      child: Text(label, style: AppText.label(color: color)),
    );
  }
}
