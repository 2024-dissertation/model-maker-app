import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:frontend/module/user/models/my_user.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

class MyUserRepositoryImpl extends AbstractRepository
    implements MyUserRepository {
  MyUserRepositoryImpl({super.apiDataSource});

  @override
  Future<MyUser> getMyUser() async {
    final data = await apiDataSource.getMyUser();
    return MyUserMapper.fromMap(data['user']);
  }

  @override
  Future<MyUser> updateMyUser(MyUser user) async {
    final data = await apiDataSource.saveMyUser(user);
    return MyUserMapper.fromMap(data['user']);
  }

  @override
  Future<void> saveMyUser(MyUser myUser) {
    return apiDataSource.saveMyUser(myUser);
  }

  @override
  Future<void> createUser(MyUser myUser) {
    return apiDataSource.createUser(myUser);
  }
}
