import 'package:t3afy/volunteer/tasks/data/models/task_models.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

extension TaskModelMapper on TaskModel {
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