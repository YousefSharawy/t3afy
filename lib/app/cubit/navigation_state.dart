part of 'navigation_cubit.dart';
@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState.initial() = _Initial;
  
  const factory NavigationState.loaded({
    required int currentIndex,
    required int previousIndex,
  }) = _Loaded;
}