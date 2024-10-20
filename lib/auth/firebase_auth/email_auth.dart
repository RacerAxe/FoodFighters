import 'package:firebase_auth/firebase_auth.dart';

/// Signs in a user with email and password using Firebase Authentication.
///
/// This function attempts to sign in an existing user with the provided email and password.
/// The email is trimmed to remove any leading or trailing whitespace.
///
/// Parameters:
///   - email: The user's email address.
///   - password: The user's password.
///
/// Returns:
///   A Future that resolves to a UserCredential if sign-in is successful, or null if it fails.
Future<UserCredential?> emailSignInFunc(
  String email,
  String password,
) =>
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

/// Creates a new user account with email and password using Firebase Authentication.
///
/// This function attempts to create a new user account with the provided email and password.
/// The email is trimmed to remove any leading or trailing whitespace.
///
/// Parameters:
///   - email: The email address for the new account.
///   - password: The password for the new account.
///
/// Returns:
///   A Future that resolves to a UserCredential if account creation is successful, or null if it fails.
Future<UserCredential?> emailCreateAccountFunc(
  String email,
  String password,
) =>
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
