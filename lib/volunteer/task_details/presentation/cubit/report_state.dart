abstract class ReportState {}

class ReportStateInitial extends ReportState {}

class ReportStateLoading extends ReportState {}

class ReportStateSuccess extends ReportState {}

class ReportStateError extends ReportState {
  final String message;

  ReportStateError(this.message);
}
