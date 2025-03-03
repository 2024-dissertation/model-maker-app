import 'package:frontend/exceptions/api_exceptions.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/app/repository/abstract_repository.dart';
import 'package:frontend/module/user/models/my_user.dart';
import 'package:frontend/module/user/repository/my_user_repository.dart';

class MyUserRepositoryImpl extends AbstractRepository
    implements MyUserRepository {
  MyUserRepositoryImpl({super.apiDataSource});

  @override
  Future<MyUser> getMyUser() async {
    try {
      final data = await apiDataSource.getMyUser();
      return MyUserMapper.fromMap(data['user']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }

  @override
  Future<MyUser> saveMyUser(MyUser user) async {
    try {
      final data = await apiDataSource.saveMyUser(user);
      return MyUserMapper.fromMap(data['user']);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      logger.e(e);
      throw ParsingException();
    }
  }
}
