// Enum with all possible authentication states.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/my_user_cubit.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repositories/auth_repository.dart';

enum AuthState {
  initial,
  signedOut,
  signedIn,
  loading,
}

// Extends Cubit and will emit states of type AuthState
class AuthCubit extends Cubit<AuthState> {
  // Get the injected AuthRepository
  final AuthRepository _authRepository = getIt();
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
      emit(AuthState.signedOut);
    } else {
      try {
        emit(AuthState.loading);

        _myUserCubit.getMyUser().onError((e, stack) {
          emit(AuthState.signedOut);
          _authRepository.signOut();
        }).then((_) {
          emit(AuthState.signedIn);
        });
      } catch (e) {
        logger.e(e.toString());
        _authRepository.signOut();
        emit(AuthState.signedOut);
      }
    }
  }

  // Sign-out and immediately emits signedOut state
  Future<void> signOut() async {
    emit(AuthState.signedOut);
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
}
