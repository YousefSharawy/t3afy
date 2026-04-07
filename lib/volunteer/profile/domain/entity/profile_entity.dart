class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String region;
  final String qualification;
  final int level;
  final String levelTitle;
  final double rating;
  final int totalHours;
  final int totalTasks;
  final int placesVisited;
  final int totalPoints;
  final String joinedAt;
  final String? idFileUrl;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.region,
    required this.qualification,
    required this.level,
    required this.levelTitle,
    required this.rating,
    required this.totalHours,
    required this.totalTasks,
    required this.placesVisited,
    required this.totalPoints,
    required this.joinedAt,
    this.idFileUrl,
  });
}
