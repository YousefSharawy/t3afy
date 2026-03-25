import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/data/sources/notifications_remote_data_source.dart';

class NotificationsImplRemoteDataSource implements NotificationsRemoteDataSource {
  @override
  Future<List<AdminNote>> getNotifications(String volunteerId) async {
    try {
      final res = await Supabase.instance.client
          .from('admin_notes')
          .select()
          .eq('volunteer_id', volunteerId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((note) => AdminNote.fromJson(note as Map<String, dynamic>))
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
  Future<void> markAllAsRead(String volunteerId) async {
    try {
      await Supabase.instance.client
          .from('admin_notes')
          .update({'is_read': true})
          .eq('volunteer_id', volunteerId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> clearAllNotifications(String volunteerId) async {
    try {
      await Supabase.instance.client
          .from('admin_notes')
          .delete()
          .eq('volunteer_id', volunteerId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
