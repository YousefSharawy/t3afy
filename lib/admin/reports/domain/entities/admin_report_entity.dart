class AdminReportEntity {
  final String id;
  final String taskId;
  final String userId;
  final String summary;
  final String? challenges;
  final int? attendeesCount;
  final bool materialsDistributed;
  final String? additionalNotes;
  final int rating;
  final String status;
  final String? adminFeedback;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final String taskTitle;
  final String volunteerName;

  const AdminReportEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.summary,
    this.challenges,
    this.attendeesCount,
    required this.materialsDistributed,
    this.additionalNotes,
    required this.rating,
    required this.status,
    this.adminFeedback,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
    required this.taskTitle,
    required this.volunteerName,
  });

  factory AdminReportEntity.fromJson(Map<String, dynamic> json) {
    final tasks = json['tasks'] as Map<String, dynamic>?;
    final users = json['users'] as Map<String, dynamic>?;
    return AdminReportEntity(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      userId: json['user_id'] as String,
      summary: json['summary'] as String? ?? '',
      challenges: json['challenges'] as String?,
      attendeesCount: json['attendees_count'] as int?,
      materialsDistributed: json['materials_distributed'] as bool? ?? false,
      additionalNotes: json['additional_notes'] as String?,
      rating: json['rating'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      adminFeedback: json['admin_feedback'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.tryParse(json['reviewed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      taskTitle: (tasks?['title'] as String?) ?? 'مهمة',
      volunteerName: (users?['name'] as String?) ?? 'متطوع',
    );
  }
}
