import 'package:firebase_auth/firebase_auth.dart';

/// Initiates the GitHub sign-in process using Firebase Authentication.
///
/// This function creates a GitHub authentication provider and uses it to sign in
/// the user via a popup. It's based on the Firebase documentation for social auth:
/// https://firebase.flutter.dev/docs/auth/social/#github
///
/// Returns:
///   A Future<UserCredential?> representing the signed-in user's credentials.
///   Returns null if the sign-in process fails or is cancelled.
Future<UserCredential?> githubSignInFunc() async {
  // Create a new GitHub authentication provider
  GithubAuthProvider githubProvider = GithubAuthProvider();

  try {
    // Attempt to sign in the user with the GitHub provider using a popup
    return await FirebaseAuth.instance.signInWithPopup(githubProvider);
  } catch (e) {
    // Handle any errors that occur during the sign-in process
    print('Error during GitHub sign-in: $e');
    return null;
  }
}
