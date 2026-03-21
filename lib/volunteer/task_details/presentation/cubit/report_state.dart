abstract class ReportState {}

class ReportStateInitial extends ReportState {}

class ReportStateCheckingExisting extends ReportState {}

class ReportStateExistingFound extends ReportState {
  final Map<String, dynamic> report;
  ReportStateExistingFound(this.report);
}

class ReportStateNoExisting extends ReportState {}

class ReportStateLoading extends ReportState {}

class ReportStateSuccess extends ReportState {}

class ReportStateError extends ReportState {
  final String message;
  ReportStateError(this.message);
}
