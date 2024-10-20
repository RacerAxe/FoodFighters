import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../base_auth_user_provider.dart';

export '../base_auth_user_provider.dart';

/// Custom Firebase user class that extends BaseAuthUser
class BiteWiseFirebaseUser extends BaseAuthUser {
  BiteWiseFirebaseUser(this.user);
  User? user;

  /// Checks if the user is logged in
  @override
  bool get loggedIn => user != null;

  /// Returns user information as AuthUserInfo
  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  /// Deletes the user account
  @override
  Future? delete() => user?.delete();

  /// Updates the user's email address
  @override
  Future? updateEmail(String email) async {
    try {
      await user?.updateEmail(email);
    } catch (_) {
      // If direct update fails, try verifying before update
      await user?.verifyBeforeUpdateEmail(email);
    }
  }

  /// Sends email verification to the user
  @override
  Future? sendEmailVerification() => user?.sendEmailVerification();

  /// Checks if the user's email is verified
  @override
  bool get emailVerified {
    // Reloads the user when checking to get the most up-to-date email verified status
    if (loggedIn && !user!.emailVerified) {
      refreshUser();
    }
    return user?.emailVerified ?? false;
  }

  /// Refreshes the user data
  @override
  Future refreshUser() async {
    await FirebaseAuth.instance.currentUser
        ?.reload()
        .then((_) => user = FirebaseAuth.instance.currentUser);
  }

  /// Creates a BiteWiseFirebaseUser from a UserCredential
  static BaseAuthUser fromUserCredential(UserCredential userCredential) =>
      fromFirebaseUser(userCredential.user);

  /// Creates a BiteWiseFirebaseUser from a Firebase User
  static BaseAuthUser fromFirebaseUser(User? user) =>
      BiteWiseFirebaseUser(user);
}

/// Stream of BaseAuthUser based on Firebase authentication state changes
Stream<BaseAuthUser> biteWiseFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<BaseAuthUser>(
      (user) {
        currentUser = BiteWiseFirebaseUser(user);
        return currentUser!;
      },
    );
