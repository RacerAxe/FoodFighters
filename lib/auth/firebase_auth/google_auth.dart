import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// GoogleSignIn instance with scopes for profile and email
final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

/// Performs Google Sign In and returns a UserCredential
///
/// This function handles both web and mobile platforms:
/// - For web, it uses Firebase's signInWithPopup
/// - For mobile, it uses GoogleSignIn package
///
/// Returns a Future<UserCredential?> representing the signed-in user's credentials,
/// or null if the sign-in process fails or is cancelled.
Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Web-specific sign-in process
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  // Mobile-specific sign-in process
  // First, ensure any existing session is signed out
  await signOutWithGoogle().catchError((_) => null);
  
  // Attempt to sign in and get authentication details
  final auth = await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) {
    // Return null if authentication fails
    return null;
  }
  
  // Create Google credentials
  final credential = GoogleAuthProvider.credential(
    idToken: auth.idToken,
    accessToken: auth.accessToken,
  );
  
  // Sign in to Firebase with the Google credentials
  return FirebaseAuth.instance.signInWithCredential(credential);
}

/// Signs out the current Google user
///
/// Returns a Future that completes when the sign-out process is finished
Future<void> signOutWithGoogle() => _googleSignIn.signOut();
