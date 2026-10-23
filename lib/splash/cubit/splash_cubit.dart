import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/fcm_service.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

/// Resolves the start route right away; [SplashView] navigates once both this
/// and the intro animation are done (no fixed timer).
class SplashCubit extends Cubit<SplashState> with SafeEmit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  Future<void> start() async {
    if (!LocalAppStorage.isLoggedIn()) {
      safeEmit(SplashState.success(route: Routes.onboarding1));
      return;
    }

    final role = LocalAppStorage.getUserRole();
    final userId = LocalAppStorage.getUserId();
    if (role == 'user' || userId == null) {
      await LocalAppStorage.clearUserSession();
      safeEmit(SplashState.success(route: Routes.login));
      return;
    }

    // Token rotations were only tracked after an explicit login before; keep
    // tracking them for restored sessions too.
    FcmService.listenForTokenRefresh(userId);
    safeEmit(
      SplashState.success(
        route: role == 'admin' ? Routes.adminHome : Routes.volunteerHome,
      ),
    );
  }
}
