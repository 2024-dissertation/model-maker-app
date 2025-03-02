import 'package:frontend/module/user/models/my_user.dart';

abstract class MyUserRepository {
  Future<MyUser> getMyUser();
  Future<MyUser> updateMyUser(MyUser user);
  Future<void> saveMyUser(MyUser myUser);
  Future<void> createUser(MyUser myUser);
}
