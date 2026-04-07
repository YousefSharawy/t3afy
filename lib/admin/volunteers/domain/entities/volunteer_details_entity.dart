class VolunteerTaskAssignmentEntity {
  final String id;
  final String title;
  final DateTime? assignedAt;
  final String status;
  final double durationHours;
  final bool isVerified;
  final double? verifiedHours;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;

  const VolunteerTaskAssignmentEntity({
    required this.id,
    required this.title,
    this.assignedAt,
    required this.status,
    this.durationHours = 0,
    this.isVerified = false,
    this.verifiedHours,
    this.checkedInAt,
    this.checkedOutAt,
  });

  factory VolunteerTaskAssignmentEntity.fromJson(Map<String, dynamic> json) {
    final task = json['tasks'] as Map<String, dynamic>?;
    final assignedStr = json['assigned_at'] as String?;
    final checkedInStr = json['checked_in_at'] as String?;
    final checkedOutStr = json['checked_out_at'] as String?;
    return VolunteerTaskAssignmentEntity(
      id: json['id'] as String? ?? '',
      title: task?['title'] as String? ?? '',
      assignedAt: assignedStr != null ? DateTime.tryParse(assignedStr) : null,
      status: json['status'] as String? ?? 'active',
      durationHours: ((task?['duration_hours'] as num?) ?? 0).toDouble(),
      isVerified: (json['is_verified'] as bool?) ?? false,
      verifiedHours: (json['verified_hours'] as num?)?.toDouble(),
      checkedInAt: checkedInStr != null
          ? DateTime.tryParse(checkedInStr)
          : null,
      checkedOutAt: checkedOutStr != null
          ? DateTime.tryParse(checkedOutStr)
          : null,
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
  final String? idFileUrl;

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
    this.idFileUrl,
  });

  VolunteerDetailsEntity copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? rating,
    int? level,
    String? levelTitle,
    int? totalTasks,
    int? totalHours,
    int? totalPoints,
    int? placesVisited,
    String? region,
    String? email,
    String? phone,
    String? qualification,
    DateTime? joinedAt,
    bool? isOnline,
    DateTime? lastSeenAt,
    String? role,
    List<VolunteerTaskAssignmentEntity>? tasks,
    List<String>? volunteerAreas,
    String? idFileUrl,
  }) {
    return VolunteerDetailsEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      totalTasks: totalTasks ?? this.totalTasks,
      totalHours: totalHours ?? this.totalHours,
      totalPoints: totalPoints ?? this.totalPoints,
      placesVisited: placesVisited ?? this.placesVisited,
      region: region ?? this.region,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      qualification: qualification ?? this.qualification,
      joinedAt: joinedAt ?? this.joinedAt,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      role: role ?? this.role,
      tasks: tasks ?? this.tasks,
      volunteerAreas: volunteerAreas ?? this.volunteerAreas,
      idFileUrl: idFileUrl ?? this.idFileUrl,
    );
  }

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
    final completedHours = tasks
        .where((t) => t.status == 'completed')
        .fold<double>(0, (sum, t) => sum + t.durationHours);
    return VolunteerDetailsEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      level: lvl,
      levelTitle: _levelTitle(lvl),
      totalTasks: (json['total_tasks'] as num?)?.toInt() ?? 0,
      totalHours: completedHours.round(),
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      placesVisited: (json['places_visited'] as num?)?.toInt() ?? 0,
      region: json['region'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      qualification: json['qualification'] as String?,
      joinedAt: joinedStr != null ? DateTime.tryParse(joinedStr) : null,
      isOnline: (json['is_online'] as bool?) ?? false,
      lastSeenAt: lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null,
      role: json['role'] as String? ?? 'user',
      tasks: tasks,
      volunteerAreas: volunteerAreas,
      idFileUrl: json['id_file_url'] as String?,
    );
  }

  static String _levelTitle(int level) {
    if (level <= 2) return 'متطوع مبتدئ';
    if (level <= 5) return 'متطوع نشيط';
    if (level <= 9) return 'متطوع متقدم';
    return 'متطوع خبير';
  }
}
