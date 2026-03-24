import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/admin/notifications/data/sources/admin_notifications_remote_data_source.dart';

class AdminNotificationsImplRemoteDataSource
    implements AdminNotificationsRemoteDataSource {
  @override
  Future<List<AdminNotification>> getNotifications(String adminId) async {
    try {
      final res = await Supabase.instance.client
          .from('admin_notes')
          .select()
          .eq('admin_id', adminId)
          .eq('volunteer_id', adminId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => AdminNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> markAsRead(String noteId) async {
    try {
      await Supabase.instance.client
          .from('admin_notes')
          .update({'is_read': true}).eq('id', noteId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> markAllAsRead(String adminId) async {
    try {
      await Supabase.instance.client
          .from('admin_notes')
          .update({'is_read': true})
          .eq('admin_id', adminId)
          .eq('volunteer_id', adminId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
