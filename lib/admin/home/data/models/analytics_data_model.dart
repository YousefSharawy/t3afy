class AnalyticsDataModel {
  final String adminName;
  final List<Map<String, dynamic>> volunteers;
  final List<Map<String, dynamic>> campaigns;
  final List<Map<String, dynamic>> assignments;
  final List<Map<String, dynamic>> reports;
  final List<Map<String, dynamic>> assessments;
  final DateTime generatedAt;

  const AnalyticsDataModel({
    required this.adminName,
    required this.volunteers,
    required this.campaigns,
    required this.assignments,
    required this.reports,
    required this.assessments,
    required this.generatedAt,
  });

  // ── Volunteer counts ─────────────────────────────────────────────────────

  int get totalVolunteers => volunteers.length;

  int get activeVolunteers =>
      volunteers.where((v) => v['role'] == 'volunteer').length;

  int get pendingVolunteers =>
      volunteers.where((v) => v['role'] == 'user').length;

  int get suspendedVolunteers =>
      volunteers.where((v) => v['role'] == 'suspended').length;

  int get newVolunteersThisMonth {
    final now = generatedAt;
    return volunteers.where((v) {
      final joinedStr = v['joined_at'] as String?;
      if (joinedStr == null) return false;
      final joined = DateTime.tryParse(joinedStr);
      return joined != null &&
          joined.year == now.year &&
          joined.month == now.month;
    }).length;
  }

  int get newVolunteersLastMonth {
    final last = DateTime(generatedAt.year, generatedAt.month - 1);
    return volunteers.where((v) {
      final joinedStr = v['joined_at'] as String?;
      if (joinedStr == null) return false;
      final joined = DateTime.tryParse(joinedStr);
      return joined != null &&
          joined.year == last.year &&
          joined.month == last.month;
    }).length;
  }

  // ── Campaign counts ───────────────────────────────────────────────────────

  int get totalCampaigns => campaigns.length;

  int get completedCampaigns =>
      campaigns.where((c) => c['status'] == 'completed').length;

  int get activeCampaigns =>
      campaigns.where((c) => c['status'] == 'active').length;

  int get upcomingCampaigns =>
      campaigns.where((c) => c['status'] == 'upcoming').length;

  // ── Assignment / hours stats ──────────────────────────────────────────────

  int get totalAssignments => assignments.length;

  int get verifiedAssignments =>
      assignments.where((a) => (a['is_verified'] as bool?) == true).length;

  double get attendanceRate =>
      totalAssignments > 0 ? verifiedAssignments / totalAssignments * 100 : 0;

  double get totalPlannedHours => assignments.fold<double>(0, (sum, a) {
    final task = a['tasks'] as Map<String, dynamic>?;
    return sum + ((task?['duration_hours'] as num?) ?? 0).toDouble();
  });

  double get totalVerifiedHours => assignments.fold<double>(0, (sum, a) {
    final h = a['verified_hours'];
    return sum + (h != null ? (h as num).toDouble() : 0);
  });

  int get totalPoints => volunteers.fold<int>(
    0,
    (sum, v) => sum + ((v['total_points'] as num?) ?? 0).toInt(),
  );

  double get averageRating {
    final rated = volunteers
        .where((v) => v['role'] == 'volunteer' && (v['rating'] as num?) != null)
        .toList();
    if (rated.isEmpty) return 0;
    final total = rated.fold<double>(
      0,
      (s, v) => s + (v['rating'] as num).toDouble(),
    );
    return total / rated.length;
  }

  // ── Report stats ──────────────────────────────────────────────────────────

  int get totalReports => reports.length;

  int get approvedReports =>
      reports.where((r) => r['status'] == 'approved').length;

  int get rejectedReports =>
      reports.where((r) => r['status'] == 'rejected').length;

  int get pendingReports =>
      reports.where((r) => r['status'] == 'pending').length;

  double get reportSubmissionRate =>
      totalAssignments > 0 ? totalReports / totalAssignments * 100 : 0;

  // ── Assessment stats ──────────────────────────────────────────────────────

  int get totalAssessments => assessments.length;

  double get averageAssessmentRating {
    if (assessments.isEmpty) return 0;
    final total = assessments.fold<double>(
      0,
      (s, a) => s + ((a['rating'] as num?) ?? 0).toDouble(),
    );
    return total / assessments.length;
  }

  // ── Derived lists ─────────────────────────────────────────────────────────

  /// Top 10 volunteers by total_hours desc
  List<Map<String, dynamic>> get topByHours {
    final vols = List<Map<String, dynamic>>.from(volunteers)
      ..sort(
        (a, b) => ((b['total_hours'] as num?) ?? 0).compareTo(
          (a['total_hours'] as num?) ?? 0,
        ),
      );
    return vols.take(10).toList();
  }

  /// Top 10 volunteers by total_points desc
  List<Map<String, dynamic>> get topByPoints {
    final vols = List<Map<String, dynamic>>.from(volunteers)
      ..sort(
        (a, b) => ((b['total_points'] as num?) ?? 0).compareTo(
          (a['total_points'] as num?) ?? 0,
        ),
      );
    return vols.take(10).toList();
  }

  /// Top 10 volunteers by rating desc
  List<Map<String, dynamic>> get topByRating {
    final vols =
        List<Map<String, dynamic>>.from(
          volunteers.where((v) => (v['rating'] as num?) != null),
        )..sort(
          (a, b) => ((b['rating'] as num?) ?? 0).compareTo(
            (a['rating'] as num?) ?? 0,
          ),
        );
    return vols.take(10).toList();
  }

  /// Count per level (key = level int)
  Map<int, int> get levelDistribution {
    final map = <int, int>{};
    for (final v in volunteers) {
      final lvl = ((v['level'] as num?) ?? 1).toInt();
      map[lvl] = (map[lvl] ?? 0) + 1;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Count per region
  Map<String, int> get regionDistribution {
    final map = <String, int>{};
    for (final v in volunteers) {
      final region = (v['region'] as String?) ?? 'غير محدد';
      map[region] = (map[region] ?? 0) + 1;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  /// Count per campaign type
  Map<String, int> get campaignTypeDistribution {
    final map = <String, int>{};
    for (final c in campaigns) {
      final type = (c['type'] as String?) ?? 'غير محدد';
      map[type] = (map[type] ?? 0) + 1;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  /// Campaigns per month (last 12 months) — key = 'YYYY-MM'
  Map<String, int> get campaignsPerMonth {
    final map = <String, int>{};
    final now = generatedAt;
    for (int i = 11; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i);
      final key = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      map[key] = 0;
    }
    for (final c in campaigns) {
      final dateStr = c['date'] as String?;
      if (dateStr == null) continue;
      final dt = DateTime.tryParse(dateStr);
      if (dt == null) continue;
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      if (map.containsKey(key)) map[key] = map[key]! + 1;
    }
    return map;
  }

  /// Volunteers with 0 tasks
  int get inactiveVolunteers =>
      volunteers.where((v) => ((v['total_tasks'] as num?) ?? 0) == 0).length;

  /// Campaign with lowest attendance rate (has issues)
  List<Map<String, dynamic>> get lowAttendanceCampaigns {
    // Find campaigns where assigned volunteers exist but less than 50% verified
    final result = <Map<String, dynamic>>[];
    for (final c in campaigns) {
      final cId = c['id'] as String?;
      if (cId == null) continue;
      final assigned = assignments.where((a) {
        final task = a['tasks'] as Map<String, dynamic>?;
        return task?['id'] == cId || a['task_id'] == cId;
      }).toList();
      if (assigned.isEmpty) continue;
      final verified = assigned
          .where((a) => (a['is_verified'] as bool?) == true)
          .length;
      final rate = verified / assigned.length;
      if (rate < 0.5) result.add({...c, '_attendance_rate': rate});
    }
    return result;
  }

  /// Assessment rating distribution (1–5)
  Map<int, int> get ratingDistribution {
    final map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final a in assessments) {
      final r = ((a['rating'] as num?) ?? 0).toInt().clamp(1, 5);
      map[r] = (map[r] ?? 0) + 1;
    }
    return map;
  }

  /// Earliest campaign date or today
  DateTime get firstCampaignDate {
    DateTime earliest = generatedAt;
    for (final c in campaigns) {
      final dateStr = c['date'] as String?;
      if (dateStr == null) continue;
      final dt = DateTime.tryParse(dateStr);
      if (dt != null && dt.isBefore(earliest)) earliest = dt;
    }
    return earliest;
  }

  /// Best volunteer by hours (name + hours)
  (String, double) get topVolunteer {
    if (volunteers.isEmpty) return ('—', 0);
    final top = topByHours.first;
    return (
      top['name'] as String? ?? '—',
      ((top['total_hours'] as num?) ?? 0).toDouble(),
    );
  }

  /// Volunteers sorted by total tasks descending (for task count top 10)
  List<Map<String, dynamic>> get topByTaskCount {
    final vols = List<Map<String, dynamic>>.from(volunteers)
      ..sort(
        (a, b) => ((b['total_tasks'] as num?) ?? 0).compareTo(
          (a['total_tasks'] as num?) ?? 0,
        ),
      );
    return vols.take(10).toList();
  }
}
