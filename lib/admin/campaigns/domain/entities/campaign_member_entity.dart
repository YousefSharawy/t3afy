class CampaignMemberEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final String? region;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final String role;

  const CampaignMemberEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    this.region,
    required this.isOnline,
    this.lastSeenAt,
    required this.role,
  });

  bool get isActiveNow {
    if (!isOnline) return false;
    if (lastSeenAt == null) return false;
    return DateTime.now().toUtc().difference(lastSeenAt!).inMinutes < 5;
  }

  /// 'نشط' | 'قيد المراجعة' | 'غير نشط'
  String get status {
    if (role != 'volunteer') return 'قيد المراجعة';
    if (isActiveNow) return 'نشط';
    return 'غير نشط';
  }
}
