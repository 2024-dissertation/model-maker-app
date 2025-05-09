import 'package:frontend/module/analytics/models/analytics.dart';
import 'package:frontend/module/user/models/my_user.dart';

abstract class MyUserRepository {
  Future<MyUser> getMyUser();
  Future<MyUser> saveMyUser(MyUser myUser);
  Future<Analytics> getAnalytics();
  Future<Map<String, dynamic>> deleteAccount();
}
