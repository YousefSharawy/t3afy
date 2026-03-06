import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/constants_manager.dart';
import 'package:t3afy/app/resources/routes.dart';


part 'splash_state.dart';
part 'splash_cubit.freezed.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  void start() async {
    await Future.delayed(Duration(seconds: ConstantsManager.splashTimer));
    final hasCompletedOnboarding = LocalAppStorage.isOnboardingCompleted();
    if (hasCompletedOnboarding) {
      emit(SplashState.success(route: Routes.onboarding1));
    } else {
      emit(SplashState.success(route: Routes.onboarding1));
    }
    // Future use case for authentication:
    // final authStream = FirebaseAuth.instance.authStateChanges();
    // authStream.listen((User? user) {
    //   if (user == null) {
    //     emit(SplashState.success(route: Routes.login));
    //     getIt<AppPrefs>().saveUserId('');
    //   } else {
    //     emit(SplashState.success(route: Routes.home));
    //     getIt<AppPrefs>().saveUserId(user.uid);
    //   }
    // });
  }
}