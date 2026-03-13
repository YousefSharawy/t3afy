class VolunteerStatsEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int level;
  final String levelTitle;
  final double rating;
  final int totalHours;
  final int totalTasks;
  final int placesVisited;

  VolunteerStatsEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.level,
    required this.levelTitle,
    required this.rating,
    required this.totalHours,
    required this.totalTasks,
    required this.placesVisited,
  });
}

class TaskEntity {
  final String id;
  final String title;
  final String type;
  final String description;
  final String status;
  final String date;              // keep as String like home uses
  final String timeStart;
  final String timeEnd;
  final double durationHours;
  final int points;
  final String locationName;
  final String locationAddress;
  final double? locationLat;      // NEW
  final double? locationLng;      // NEW
  final String supervisorName;
  final String supervisorPhone;
  final String? notes;
  final String assignmentStatus;  // NEW — default 'assigned'

  const TaskEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.status,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.durationHours,
    required this.points,
    required this.locationName,
    required this.locationAddress,
    this.locationLat,
    this.locationLng,
    required this.supervisorName,
    required this.supervisorPhone,
    this.notes,
    this.assignmentStatus = 'assigned',
  });
}

class TasksStatsEntity {
  final int todayCount;
  final int completedCount;
  final int earnedPoints;

  const TasksStatsEntity({
    required this.todayCount,
    required this.completedCount,
    required this.earnedPoints,
  });
}
