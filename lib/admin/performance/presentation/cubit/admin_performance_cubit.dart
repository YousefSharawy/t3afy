import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/performance/domain/usecases/get_admin_performance_usecase.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';

class AdminPerformanceCubit extends Cubit<AdminPerformanceState> {
  final GetAdminPerformanceUsecase _usecase;

  AdminPerformanceCubit(this._usecase) : super(AdminPerformanceInitial()) {
    loadPerformance();
  }

  Future<void> loadPerformance() async {
    emit(AdminPerformanceLoading());
    final result = await _usecase();
    result.fold(
      (f) => emit(AdminPerformanceError(f.message)),
      (data) => emit(AdminPerformanceLoaded(data)),
    );
  }
}
