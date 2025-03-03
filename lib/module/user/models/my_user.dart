import 'package:dart_mappable/dart_mappable.dart';

part 'my_user.mapper.dart';

@MappableClass(caseStyle: CaseStyle.pascalCase)
class MyUser with MyUserMappable {
  final int id;
  final String email;
  final String firebaseUid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DateTime get dtCreatedAt => DateTime.parse(createdAt);
  DateTime get dtUpdatedAt => DateTime.parse(updatedAt);
  DateTime? get dtDeletedAt =>
      deletedAt != null ? DateTime.parse(deletedAt!) : null;

  static const empty = MyUser(
    id: 0,
    email: '',
    firebaseUid: '',
    createdAt: '',
    updatedAt: '',
  );

  const MyUser({
    required this.id,
    required this.email,
    required this.firebaseUid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
