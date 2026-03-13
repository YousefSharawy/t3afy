class TaskReportModel {
  final String taskId;
  final String userId;
  final String summary;
  final String? challenges;
  final int? attendeesCount;
  final bool materialsDistributed;
  final bool objectivesMet;
  final String? additionalNotes;
  final int? rating;

  TaskReportModel({
    required this.taskId,
    required this.userId,
    required this.summary,
    this.challenges,
    this.attendeesCount,
    this.materialsDistributed = false,
    this.objectivesMet = false,
    this.additionalNotes,
    this.rating,
  });

  Map<String, dynamic> toJson() => {
    'task_id': taskId,
    'user_id': userId,
    'summary': summary,
    if (challenges != null && challenges!.isNotEmpty) 'challenges': challenges,
    if (attendeesCount != null) 'attendees_count': attendeesCount,
    'materials_distributed': materialsDistributed,
    'objectives_met': objectivesMet,
    if (additionalNotes != null && additionalNotes!.isNotEmpty)
      'additional_notes': additionalNotes,
    if (rating != null) 'rating': rating,
  };
}
