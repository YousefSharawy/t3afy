class CampaignEntity {
  final String id;
  final String title;
  final String type;
  final String status;
  final String date;
  final String? timeStart;
  final String? timeEnd;
  final String? locationName;
  final String? locationAddress;
  final String? supervisorName;
  final int volunteerCount;

  /// Assigned volunteers who checked in (or whose assignment is completed).
  final int attendedCount;
  final int targetBeneficiaries;
  final int reachedBeneficiaries;
  final int points;

  const CampaignEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    this.timeStart,
    this.timeEnd,
    this.locationName,
    this.locationAddress,
    this.supervisorName,
    required this.volunteerCount,
    this.attendedCount = 0,
    required this.targetBeneficiaries,
    required this.reachedBeneficiaries,
    required this.points,
  });

  /// List filters, keyed by the chip value. Every count and every filtered
  /// list is derived from the same *resolved* status so chips and numbers agree.
  static const filters = ['all', 'active', 'upcoming', 'done', 'missed', 'paused'];

  bool matches(String filter) => switch (filter) {
    'all' => true,
    'active' => status == 'active' || status == 'ongoing' || status == 'in_progress',
    'upcoming' => status == 'upcoming' || status == 'scheduled' || status == 'assigned',
    'done' => status == 'completed' || status == 'done',
    'missed' => status == 'missed',
    'paused' => status == 'paused' || status == 'cancelled',
    _ => status == filter,
  };

  static Map<String, int> countByFilter(Iterable<CampaignEntity> list) => {
    for (final f in filters) f: list.where((c) => c.matches(f)).length,
  };
}
