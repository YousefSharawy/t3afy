import 'package:t3afy/volunteer/models/volunteer_stats_model.dart';
import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

extension VolunteerStatsMapper on VolunteerStatsModel {
  VolunteerStatsEntity toEntity() {
    return VolunteerStatsEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      level: level,
      levelTitle: levelTitle,
      rating: rating,
      totalHours: totalHours,
      totalTasks: totalTasks,
      placesVisited: placesVisited,
      totalPoints: totalPoints,
    );
  }
}

extension TaskMapper on TaskModel {
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      type: type,
      description: description,
      status: status,
      date: date,
      timeStart: timeStart,
      timeEnd: timeEnd,
      durationHours: durationHours,
      points: points,
      locationName: locationName,
      locationAddress: locationAddress,
      locationLat: locationLat,
      locationLng: locationLng,
      supervisorName: supervisorName,
      supervisorPhone: supervisorPhone,
      notes: notes,
      assignmentStatus: assignmentStatus,
    );
  }
}

extension TasksStatsModelMapper on TasksStatsModel {
  TasksStatsEntity toEntity() {
    return TasksStatsEntity(
      todayCount: todayCount,
      completedCount: completedCount,
      earnedPoints: earnedPoints,
    );
  }
}