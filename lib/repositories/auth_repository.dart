import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frontend/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef UserUID = String;

class AuthRepository {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  Stream<UserUID?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<String?> getIdToken() async {
    return _firebaseAuth.currentUser?.getIdToken();
  }

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

  Future<firebase_auth.UserCredential> signInWithApple() async {
    final appleProvider = firebase_auth.AppleAuthProvider();
    appleProvider.addScope("email");
    appleProvider.addScope("name");
    appleProvider.addScope("fullName");
    final creds = await _firebaseAuth.signInWithProvider(appleProvider);
    return creds;
  }

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

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

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
