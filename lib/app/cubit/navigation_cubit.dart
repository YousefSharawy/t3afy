import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'navigation_state.dart';
part 'navigation_cubit.freezed.dart';
class NavigationCubit extends Cubit<NavigationState> {
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 200);

  NavigationCubit() : super(const NavigationState.initial());

  void updateIndex(int newIndex) {
    // Cancel any pending navigation
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(_debounceDuration, () {
       if (isClosed) return;
      state.maybeWhen(
        loaded: (currentIndex, previousIndex) {
          if (currentIndex != newIndex) {
            emit(NavigationState.loaded(
              currentIndex: newIndex,
              previousIndex: currentIndex,
            ));
          }
        },
        orElse: () {
          emit(NavigationState.loaded(
            currentIndex: newIndex,
            previousIndex: 0,
          ));
        },
      );
    });
  }

  void updateIndexImmediate(int newIndex) {
    _debounceTimer?.cancel();
    state.maybeWhen(
      loaded: (currentIndex, previousIndex) {
        if (currentIndex != newIndex) {
          emit(NavigationState.loaded(
            currentIndex: newIndex,
            previousIndex: currentIndex,
          ));
        }
      },
      orElse: () {
        emit(NavigationState.loaded(
          currentIndex: newIndex,
          previousIndex: 0,
        ));
      },
    );
  }

  void reset() {
    _debounceTimer?.cancel();
    emit(const NavigationState.initial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}