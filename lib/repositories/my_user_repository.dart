import 'package:frontend/model/user.dart';

abstract class MyUserRepository {
  Future<MyUser> getMyUser();

  Future<void> saveMyUser(MyUser myUser);

  Future<void> createUser(MyUser myUser);
}
