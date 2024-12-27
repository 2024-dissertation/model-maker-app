import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final int id;
  final String email;
  final String firebaseUid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const MyUser({
    required this.id,
    required this.email,
    required this.firebaseUid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  List<Object?> get props =>
      [id, email, firebaseUid, createdAt, updatedAt, deletedAt];

  // Helper function to convert this User to a Map
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'email': email,
      'firebaseUid': firebaseUid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  // Helper function to convert a Map to an instance of User
  MyUser.fromMap(Map<String, Object?> data)
      : id = data['ID'] as int,
        email = data['Email'] as String,
        firebaseUid = data['FirebaseUid'] as String,
        createdAt = data['CreatedAt'] as String,
        updatedAt = data['UpdatedAt'] as String,
        deletedAt = data['DeletedAt'] as String?;

  // Helper function that updates some properties of this instance,
  // and returns a new updated instance of User
  MyUser copyWith({
    int? id,
    String? email,
    String? firebaseUid,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
