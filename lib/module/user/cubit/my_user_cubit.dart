import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/safe_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

class MyUserCubit extends SafeHydratedCubit<MyUserState> {
  final MyUserRepository _myUserRepository;

  MyUserCubit({MyUserRepository? myUserRepository})
      : _myUserRepository = myUserRepository ?? getIt(),
        super(MyUserInitial());

  Future<void> getMyUser() async {
    safeEmit(MyUserLoading());
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

  void clearMyUser() {
    safeEmit(MyUserInitial());
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

  @override
  MyUserState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      return MyUserLoadedMapper.fromMap(json);
    }

    return MyUserInitial();
  }

  @override
  Map<String, dynamic>? toJson(MyUserState state) {
    return state.toMap();
  }
}
