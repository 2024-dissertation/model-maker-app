import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthRepository {
  Future<void> signOut();

  Future<String?> getIdToken();
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<firebase_auth.UserCredential> signInWithApple();
  Future<firebase_auth.UserCredential> signInWithGoogle();
  Future<firebase_auth.User?> singUpWithEmailAndPassword(
    String email,
    String password,
  );
}
