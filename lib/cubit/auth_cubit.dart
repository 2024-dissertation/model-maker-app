import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthUnknown());

  final AuthenticationRepository _authenticationRepository;

  Future<void> loginEmailPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final creds = await _authenticationRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        emit(AuthSuccess(creds.user!));
      }
    } catch (e) {
      logger.e(e);
      emit(AuthUnauth());
    }
  }

  Future<void> logOut() async {
    emit(AuthLoading());
    await _authenticationRepository.logOut();
    emit(AuthUnauth());
  }
}
