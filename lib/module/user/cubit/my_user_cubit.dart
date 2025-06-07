import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

class MyUserCubit extends SafeHydratedCubit<MyUserState> {
  final MyUserRepository _myUserRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  MyUserCubit({
    MyUserRepository? myUserRepository,
    AuthRepository? authRepository,
  })  : _myUserRepository = myUserRepository ?? getIt(),
        _authRepository = authRepository ?? getIt(),
        super(const MyUserInitial());

  Future<void> init() async {
    // Subscribe to listen for changes in the authentication state
    _authSubscription =
        _authRepository.onAuthStateChanged().listen(_authStateChanged);
  }

  // Helper function that will emit the current authentication state
  void _authStateChanged(String? userUID) async {
    if (userUID == null) {
      safeEmit(const MyUserSignedOut());
    } else {
      try {
        safeEmit(const MyUserLoading());
        await getMyUser();
      } catch (e) {
        logger.e(e.toString());
        await signOut();
      }
    }
  }

  Future<void> getMyUser() async {
    safeEmit(const MyUserLoading());
    try {
      final myUser = await _myUserRepository.getMyUser();
      FirebaseCrashlytics.instance.setUserIdentifier("${myUser.id}");
      FirebaseCrashlytics.instance.log("User loaded: ${myUser.id}");
      FirebaseMessaging.instance.subscribeToTopic("${myUser.id}");

      logger.d("User loaded: ${myUser.id}");

      safeEmit(MyUserLoaded(myUser));
    } catch (e) {
      logger.e(e.toString());
      safeEmit(MyUserError(e.toString()));
    }
  }

  Future<void> signOut() async {
    safeEmit(const MyUserSignedOut());
    clearMyUser();
    await _authRepository.signOut();
  }

  void clearMyUser() {
    safeEmit(const MyUserInitial());
  }

  Future<String?> getIdToken() async {
    return _authRepository.getIdToken();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      logger.e(e.toString());
      safeEmit(MyUserError(e.toString()));
    }
  }

  Future<void> signInWithApple() async {
    try {
      await _authRepository.signInWithApple();
    } catch (e) {
      logger.e(e.toString());
      safeEmit(MyUserError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      logger.e(e.toString());
      safeEmit(MyUserError(e.toString()));
    }
  }

  Future<void> saveUser() async {
    if (state is! MyUserLoaded) return;

    try {
      await _myUserRepository.saveMyUser((state as MyUserLoaded).myUser);
    } catch (e) {
      logger.e(e);
      safeEmit(MyUserError(e.toString()));
    }
  }

  void updateEmail(String email) {
    if (state is! MyUserLoaded) return;

    safeEmit(
      MyUserLoaded(
        (state as MyUserLoaded).myUser.copyWith(email: email),
      ),
    );
  }

  void deleteUser() {
    if (state is! MyUserLoaded) return;

    try {
      _myUserRepository.deleteAccount().then((_) {
        FirebaseMessaging.instance
            .unsubscribeFromTopic((state as MyUserLoaded).myUser.firebaseUid);
        FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
          msg: "Account deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } catch (e) {
      logger.e(e);
      safeEmit(MyUserError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  @override
  MyUserState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      return MyUserLoadedMapper.fromMap(json);
    }

    return const MyUserInitial();
  }

  @override
  Map<String, dynamic>? toJson(MyUserState state) {
    return state.toMap();
  }
}
