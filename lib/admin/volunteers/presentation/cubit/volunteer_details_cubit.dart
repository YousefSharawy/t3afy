import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/delete_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteer_details_usecase.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';

class VolunteerDetailsCubit extends Cubit<VolunteerDetailsState> {
  final GetVolunteerDetailsUsecase _getDetails;
  final DeleteVolunteerUsecase _deleteVolunteer;

  VolunteerDetailsCubit(this._getDetails, this._deleteVolunteer)
      : super(VolunteerDetailsInitial());

  Future<void> load(String volunteerId) async {
    emit(VolunteerDetailsLoading());
    final result = await _getDetails(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsError(f.message)),
      (details) => emit(VolunteerDetailsLoaded(details)),
    );
  }

  Future<void> deleteVolunteer(String volunteerId) async {
    final current = state;
    if (current is! VolunteerDetailsLoaded) return;
    emit(VolunteerDetailsDeleting(current.details));
    final result = await _deleteVolunteer(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(current.details, f.message)),
      (_) => emit(VolunteerDetailsDeleted()),
    );
  }
}
