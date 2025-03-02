// Enum with all possible authentication states.
import 'dart:async';

import 'package:frontend/module/auth/cubit/auth_state.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/helpers/helpers.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository_impl.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Extends Cubit and will emit states of type AuthState
class AuthCubit extends HydratedCubit<AuthState> {
  // Get the injected AuthRepository
  final AuthRepositoryImpl _authRepository = getIt();
  final MyUserCubit _myUserCubit;
  StreamSubscription? _authSubscription;

  AuthCubit({
    required MyUserCubit myUserCubit,
  })  : _myUserCubit = myUserCubit,
        super(AuthState.initial);

  Future<void> init() async {
    // Subscribe to listen for changes in the authentication state
    _authSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  // Helper function that will emit the current authentication state
  void _authStateChanged(String? userUID) async {
    if (userUID == null) {
      safeEmit(AuthState.signedOut);
    } else {
      try {
        safeEmit(AuthState.loading);

        _myUserCubit.getMyUser().onError((e, stack) {
          safeEmit(AuthState.signedOut);
          _authRepository.signOut();
        }).then((_) {
          safeEmit(AuthState.signedIn);
        });
      } catch (e) {
        logger.e(e.toString());
        _authRepository.signOut();
        safeEmit(AuthState.signedOut);
      }
    }
  }

  // Sign-out and immediately safeEmits signedOut state
  Future<void> signOut() async {
    safeEmit(AuthState.signedOut);
    _myUserCubit.clearMyUser();
    await _authRepository.signOut();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<String?> getIdToken() async {
    return _authRepository.getIdToken();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthStateMapper.fromValue(json['state']);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {'state': state.toValue()};
  }
}
