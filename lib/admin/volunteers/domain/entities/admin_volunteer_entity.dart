class AdminVolunteerEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final String? region;
  final int totalHours;
  final int totalTasks;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final String role;

  /// Null for rows cached before `level` was selected.
  final int? level;

  const AdminVolunteerEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    this.region,
    required this.totalHours,
    required this.totalTasks,
    required this.isOnline,
    this.lastSeenAt,
    required this.role,
    this.level,
  });

  /// Heartbeat runs every 60 s; two missed beats = offline. Evaluated at read
  /// time so badges age out when the view re-renders (see the panel ticker).
  bool get isActiveNow =>
      isOnline &&
      lastSeenAt != null &&
      DateTime.now().toUtc().difference(lastSeenAt!.toUtc()).inSeconds < 120;

  /// True when [other] differs from this only in presence fields
  /// (`is_online`, `last_seen_at`) — i.e. a heartbeat.
  bool sameExceptPresence(AdminVolunteerEntity other) =>
      id == other.id &&
      name == other.name &&
      avatarUrl == other.avatarUrl &&
      rating == other.rating &&
      region == other.region &&
      totalHours == other.totalHours &&
      totalTasks == other.totalTasks &&
      role == other.role &&
      (level == null || other.level == null || level == other.level);

  /// 'نشط' | 'قيد المراجعة' | 'غير نشط'
  String get status {
    if (role != 'volunteer') return 'قيد المراجعة';
    if (isActiveNow) return 'نشط';
    return 'غير نشط';
  }

  factory AdminVolunteerEntity.fromJson(Map<String, dynamic> json) {
    final lastSeenStr = json['last_seen_at'] as String?;
    return AdminVolunteerEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      region: json['region'] as String?,
      totalHours: (json['total_hours'] as num?)?.toInt() ?? 0,
      totalTasks: (json['total_tasks'] as num?)?.toInt() ?? 0,
      isOnline: (json['is_online'] as bool?) ?? false,
      lastSeenAt: lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null,
      role: json['role'] as String? ?? 'user',
      level: (json['level'] as num?)?.toInt(),
    );
  }
}
