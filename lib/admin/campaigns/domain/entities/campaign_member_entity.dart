class CampaignMemberEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final String? region;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final String role;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final double? verifiedHours;
  final bool isVerified;

  const CampaignMemberEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    this.region,
    required this.isOnline,
    this.lastSeenAt,
    required this.role,
    this.checkedInAt,
    this.checkedOutAt,
    this.verifiedHours,
    this.isVerified = false,
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
