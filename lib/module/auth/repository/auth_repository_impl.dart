import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef UserUID = String;

class AuthRepositoryImpl implements AuthRepository {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  @override
  Stream<UserUID?> onAuthStateChanged() =>
      _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<String?> getIdToken() async {
    return _firebaseAuth.currentUser?.getIdToken();
  }

  @override
  firebase_auth.User? currentUser() => _firebaseAuth.currentUser;

  @override
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final creds = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return creds;
  }

  @override
  Future<firebase_auth.UserCredential> signInWithApple() async {
    final appleProvider = firebase_auth.AppleAuthProvider();
    appleProvider.addScope("email");
    appleProvider.addScope("name");
    appleProvider.addScope("fullName");
    final creds = await _firebaseAuth.signInWithProvider(appleProvider);
    return creds;
  }

  @override
  Future<firebase_auth.UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await firebase_auth.FirebaseAuth.instance
        .signInWithCredential(credential);
  }

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
