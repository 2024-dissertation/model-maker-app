import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

typedef UserUID = String;

abstract class AuthRepository {
  Future<void> signOut();
  Stream<UserUID?> onAuthStateChanged();
  Future<String?> getIdToken();
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  firebase_auth.User? currentUser();
  Future<firebase_auth.UserCredential> signInWithApple();
  Future<firebase_auth.UserCredential> signInWithGoogle();
  Future<firebase_auth.User?> singUpWithEmailAndPassword(
    String email,
    String password,
  );
}
