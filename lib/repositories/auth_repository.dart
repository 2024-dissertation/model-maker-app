import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

typedef UserUID = String;

abstract class AuthRepository {
  Stream<UserUID?> get onAuthStateChanged;

  Future<void> signOut();

  Future<String?> getIdToken();

  firebase_auth.User? get currentUser;

  Future<firebase_auth.User?> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<firebase_auth.User?> singUpWithEmailAndPassword(
    String email,
    String password,
  );
}
