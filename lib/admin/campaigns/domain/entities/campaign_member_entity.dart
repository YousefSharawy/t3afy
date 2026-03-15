class CampaignMemberEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final String? region;
  final bool isOnline;
  final DateTime? lastSeenAt;

  const CampaignMemberEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    this.region,
    required this.isOnline,
    this.lastSeenAt,
  });

  bool get isActive {
    if (!isOnline) return false;
    if (lastSeenAt == null) return false;
    return DateTime.now().toUtc().difference(lastSeenAt!).inMinutes < 5;
  }
}
