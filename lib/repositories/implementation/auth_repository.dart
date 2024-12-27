import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/logger.dart';
import 'package:frontend/repositories/auth_repository.dart';

class AuthRepositoryImp extends AuthRepository {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  @override
  Stream<UserUID?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<String?> getIdToken() async {
    return _firebaseAuth.currentUser?.getIdToken();
  }

  @override
  Future<firebase_auth.User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final creds = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return creds.user;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  @override
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<firebase_auth.User?> singUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final creds = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return creds.user;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
