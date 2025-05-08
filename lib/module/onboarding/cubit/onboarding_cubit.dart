import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/module/onboarding/cubit/onboarding_state.dart';

class OnboardingCubit extends SafeCubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  void setState(OnboardingState state) {
    safeEmit(state);
  }
}
