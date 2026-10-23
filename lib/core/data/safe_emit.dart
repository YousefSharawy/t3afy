import 'package:bloc/bloc.dart';

/// Guards every emit after an `await`: if the user popped the screen or logged
/// out while a request was in flight, the state is dropped instead of throwing
/// a StateError (Bloc 9).
mixin SafeEmit<S> on BlocBase<S> {
  void safeEmit(S state) {
    if (!isClosed) emit(state);
  }
}
