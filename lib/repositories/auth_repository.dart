import 'dart:async';

import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:frontend/logger.dart';

/// Repository which manages user authentication.
class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    CacheClient? cache,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _cache = cache ?? CacheClient();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final CacheClient _cache;

  firebase_auth.FirebaseAuth get auth => _firebaseAuth;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';
  static const userTokenKey = '__user_token_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<firebase_auth.User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      logger.i("Firebase user: $firebaseUser");
      if (firebaseUser != null) {
        _cache.write<firebase_auth.User>(
            key: userCacheKey, value: firebaseUser);
      }
      return firebaseUser;
    });
  }

  /// Get current firebase user id token
  Future<String?> getIdToken() async {
    if (_cache.read<String>(key: userTokenKey) != null) {
      return _cache.read<String>(key: userTokenKey);
    }
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("Not authenticated, try again.");
    }
    return await user.getIdToken();
  }

  /// Returns the current cached user.
  /// Defaults to [null] if there is no cached user.
  firebase_auth.User? get currentUser {
    return _cache.read<firebase_auth.User>(key: userCacheKey);
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<firebase_auth.UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      final data = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return data;
    } catch (e) {
      logger.e("Firebase exception: $e");
      throw Exception("An error occurred");
    }
  }

  /// Signs in anonymously
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signInAnon() async {
    try {
      final creds = await _firebaseAuth.signInAnonymously();
      if (creds.user != null) {
        _cache.write<firebase_auth.User>(key: userCacheKey, value: creds.user!);
      }
    } catch (e) {
      logger.e("Firebase exception: $e");
      throw Exception("An error occurred");
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  // Future<void> logInWithGoogle() async {
  //   try {
  //     final googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       throw const LogInWithGoogleFailure(message: 'Sign in aborted');
  //     }
  //     final googleAuth = await googleUser.authentication;
  //     final credential = firebase_auth.GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final creds = await _firebaseAuth.signInWithCredential(credential);
  //     _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     logger.d(e);
  //     throw LogInWithGoogleFailure.fromCode(e.code);
  //   } on PlatformException catch (e) {
  //     logger.d(e);
  //     throw LogInWithGoogleFailure.fromCode(e.code);
  //   } catch (e) {
  //     logger.d(e);
  //     throw LogInWithGoogleFailure(message: e.toString());
  //   }
  // }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  // String generateNonce([int length = 32]) {
  //   final charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Future<void> logInWithApple() async {
  //   try {
  //     final appleProvider = firebase_auth.AppleAuthProvider();
  //     appleProvider.addScope("email");
  //     appleProvider.addScope("name");
  //     appleProvider.addScope("fullName");
  //     if (kIsWeb) {
  //       final creds = await _firebaseAuth.signInWithPopup(appleProvider);
  //       _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);
  //     } else {
  //       final creds = await _firebaseAuth.signInWithProvider(appleProvider);
  //       _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);
  //     }
  //   } catch (e) {
  //     logger.d(e);
  //     rethrow;
  //   }
  // }

  // Future<void> logInWithApple2() async {
  //   try {
  //     // To prevent replay attacks with the credential returned from Apple, we
  //     // include a nonce in the credential request. When signing in with
  //     // Firebase, the nonce in the id token returned by Apple, is expected to
  //     // match the sha256 hash of `rawNonce`.
  //     final rawNonce = generateNonce();
  //     final nonce = sha256ofString(rawNonce);

  //     // Request credential for the currently signed in Apple account.
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );

  //     // Create an `OAuthCredential` from the credential returned by Apple.
  //     final oauthCredential =
  //         firebase_auth.OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );

  //     // Sign in the user with Firebase. If the nonce we generated earlier does
  //     // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //     final creds = await _firebaseAuth.signInWithCredential(oauthCredential);
  //     logger.d(creds.user);
  //     // final appleProvider = firebase_auth.AppleAuthProvider();
  //     // final creds = await _firebaseAuth.signInWithProvider(appleProvider);
  //     _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Signs in to firebase with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<firebase_auth.UserCredential> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_firebaseAuth.currentUser != null) {
      await logOut();
    }
    if (email == "" || password == "") {
      throw Exception("Missing email or password");
    }
    try {
      final creds = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        _cache.write<firebase_auth.User>(key: userCacheKey, value: creds.user!);
      }
      return creds;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.e("Firebase exception ${e.code}");
      throw Exception("An error occurred");
    } catch (e) {
      logger.e("Firebase exception $e");
      throw Exception("An error occurred");
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        // _googleSignIn.signOut(),
      ]);
      _cache.remove(key: userCacheKey);
      currentUser;
    } catch (e) {
      logger.e(e);
      throw Exception("An error occurred");
    }
  }

  /// Returns a verificationId
  // Future<String> sendVerificationCode(String phoneNumber) async {
  //   try {
  //     String verificationId = '';
  //     final Completer<String> completer = Completer<String>();

  //     await firebase_auth.FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted:
  //           (firebase_auth.PhoneAuthCredential credential) async {
  //         // Android only, i think this breaks
  //         final creds = await firebase_auth.FirebaseAuth.instance
  //             .signInWithCredential(credential);
  //         _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);
  //         if (!completer.isCompleted) {
  //           completer.complete(verificationId);
  //         }
  //       },
  //       verificationFailed: (firebase_auth.FirebaseAuthException e) {
  //         logger.e("$e");
  //         logger.e(e.message);
  //         if (!completer.isCompleted) {
  //           completer.completeError(e);
  //         }
  //       },
  //       codeSent: (String id, int? resendToken) {
  //         verificationId = id;
  //         if (!completer.isCompleted) {
  //           completer.complete(id);
  //         }
  //       },
  //       codeAutoRetrievalTimeout: (String id) {
  //         logger.d("Auto retrieval found $id");
  //         verificationId = id;
  //         if (!completer.isCompleted) {
  //           completer.complete(id);
  //         }
  //       },
  //     );

  //     return completer.future;
  //   } catch (e, stack) {
  //     logger.e("$e\n$stack");
  //     rethrow;
  //   }
  // }

  // Future<firebase_auth.UserCredential> loginWithPhoneNo(
  //     String code, String verificationid) async {
  //   try {
  //     if (currentUser != User.empty) {
  //       await logOut();
  //     }

  //     final firebase_auth.PhoneAuthCredential credential =
  //         firebase_auth.PhoneAuthProvider.credential(
  //       verificationId: verificationid,
  //       smsCode: code,
  //     );

  //     final creds = await _firebaseAuth.signInWithCredential(credential);
  //     if (creds.user == null) throw Exception("User is null");
  //     _cache.write<User>(key: userCacheKey, value: creds.user!.toUser);

  //     return creds;
  //   } catch (e) {
  //     // Handle errors during sign-in
  //     logger.e(e);
  //     rethrow;
  //   }
  // }

  // Future<void> loginWithPhone({
  //   String? smsCode,
  //   String? phoneNoVerification,
  // }) async {
  //   try {
  //     if (phoneNoVerification == null || smsCode == null) {
  //       throw Exception("Phone number or code is empty");
  //     }
  //     await loginWithPhoneNo(
  //       smsCode,
  //       phoneNoVerification,
  //     );
  //   } on firebase_auth.FirebaseException catch (e) {
  //     if (e.code == "session-expired") {
  //       throw UserRepositoryException(message: "Session expired");
  //     } else {
  //       rethrow;
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //     rethrow;
  //   }
  // }

  // Future<String> onResendCodeRequested(String phoneNo) async {
  //   String phoneNoFormatted = phoneNo.startsWith("+") ? phoneNo : '+44$phoneNo';
  //   logger.i("Resending code $phoneNoFormatted");
  //   try {
  //     if (phoneNoFormatted == "") {
  //       throw firebase_auth.FirebaseException(
  //           message: "Phone number is empty", plugin: 'wellmatch');
  //     }

  //     EasyLoading.show(status: 'Requesting code');
  //     final verificationId = await sendVerificationCode(phoneNoFormatted);
  //     logger.i("Verification id: $verificationId");
  //     EasyLoading.showSuccess('Code sent');

  //     // Emit the verification code through the stream instead of saving it in the state
  //     EasyLoading.dismiss();

  //     return verificationId;
  //   } on firebase_auth.FirebaseException catch (e, stack) {
  //     logger.e("$e\n$stack");
  //     EasyLoading.dismiss();
  //     rethrow;
  //   } catch (e, stack) {
  //     logger.e("$e\n$stack");
  //     EasyLoading.dismiss();
  //     rethrow;
  //   }
  // }
}

// extension on firebase_auth.User {
//   bool get isEmpty => uid == '';
// }
