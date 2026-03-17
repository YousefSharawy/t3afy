class VolunteerTaskAssignmentEntity {
  final String id;
  final String title;
  final DateTime? assignedAt;
  final String status;

  const VolunteerTaskAssignmentEntity({
    required this.id,
    required this.title,
    this.assignedAt,
    required this.status,
  });

  factory VolunteerTaskAssignmentEntity.fromJson(Map<String, dynamic> json) {
    final task = json['tasks'] as Map<String, dynamic>?;
    final assignedStr = json['assigned_at'] as String?;
    return VolunteerTaskAssignmentEntity(
      id: json['id'] as String? ?? '',
      title: task?['title'] as String? ?? '',
      assignedAt: assignedStr != null ? DateTime.tryParse(assignedStr) : null,
      status: json['status'] as String? ?? 'active',
    );
  }
}

class VolunteerDetailsEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final int level;
  final String levelTitle;
  final int totalTasks;
  final int totalHours;
  final int totalPoints;
  final int placesVisited;
  final String? region;
  final String? email;
  final String? phone;
  final String? qualification;
  final DateTime? joinedAt;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final String role;
  final List<VolunteerTaskAssignmentEntity> tasks;
  final List<String> volunteerAreas;

  const VolunteerDetailsEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    required this.level,
    required this.levelTitle,
    required this.totalTasks,
    required this.totalHours,
    required this.totalPoints,
    required this.placesVisited,
    this.region,
    this.email,
    this.phone,
    this.qualification,
    this.joinedAt,
    required this.isOnline,
    this.lastSeenAt,
    required this.role,
    required this.tasks,
    this.volunteerAreas = const [],
  });

  bool get isActiveNow =>
      isOnline &&
      lastSeenAt != null &&
      DateTime.now().toUtc().difference(lastSeenAt!.toUtc()).inSeconds < 90;

  String get status {
    if (role != 'volunteer') return 'قيد المراجعة';
    if (isActiveNow) return 'نشط';
    return 'غير نشط';
  }

  int get completedTasksCount =>
      tasks.where((t) => t.status == 'completed').length;

  factory VolunteerDetailsEntity.fromJson(
    Map<String, dynamic> json,
    List<VolunteerTaskAssignmentEntity> tasks,
    List<String> volunteerAreas,
  ) {
    final lastSeenStr = json['last_seen_at'] as String?;
    final joinedStr = json['joined_at'] as String?;
    final lvl = (json['level'] as num?)?.toInt() ?? 1;
    return VolunteerDetailsEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      level: lvl,
      levelTitle: _levelTitle(lvl),
      totalTasks: (json['total_tasks'] as num?)?.toInt() ?? 0,
      totalHours: (json['total_hours'] as num?)?.toInt() ?? 0,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      placesVisited: (json['places_visited'] as num?)?.toInt() ?? 0,
      region: json['region'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      qualification: json['qualification'] as String?,
      joinedAt: joinedStr != null ? DateTime.tryParse(joinedStr) : null,
      isOnline: (json['is_online'] as bool?) ?? false,
      lastSeenAt:
          lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null,
      role: json['role'] as String? ?? 'user',
      tasks: tasks,
      volunteerAreas: volunteerAreas,
    );
  }

  static String _levelTitle(int level) {
    if (level <= 2) return 'متطوع مبتدئ';
    if (level <= 5) return 'متطوع نشيط';
    if (level <= 9) return 'متطوع متقدم';
    return 'متطوع خبير';
  }
}
