class AdminNotification {
  final String id;
  final String adminId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  AdminNotification({
    required this.id,
    required this.adminId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    return AdminNotification(
      id: json['id'] as String,
      adminId: json['admin_id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  AdminNotification copyWith({bool? isRead}) {
    return AdminNotification(
      id: id,
      adminId: adminId,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
