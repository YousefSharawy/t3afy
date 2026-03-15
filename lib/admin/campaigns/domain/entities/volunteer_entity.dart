class VolunteerEntity {
  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final String? region;

  const VolunteerEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    this.region,
  });
}
