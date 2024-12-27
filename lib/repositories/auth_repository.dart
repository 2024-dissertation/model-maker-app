import 'package:firebase_auth/firebase_auth.dart';

typedef UserUID = String;

abstract class AuthRepository {
  Stream<UserUID?> get onAuthStateChanged;

  Future<void> signOut();

  Future<String?> getIdToken();

  User? get currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password);
}
