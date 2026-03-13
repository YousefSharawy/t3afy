class AdminNote {
  final String id;
  final String volunteerId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  AdminNote({
    required this.id,
    required this.volunteerId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory AdminNote.fromJson(Map<String, dynamic> json) {
    return AdminNote(
      id: json['id'] as String,
      volunteerId: json['volunteer_id'] as String,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
