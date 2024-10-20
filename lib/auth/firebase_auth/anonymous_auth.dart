import 'package:firebase_auth/firebase_auth.dart';

/// Signs in anonymously using Firebase Authentication.
///
/// Returns a [UserCredential] if the sign-in is successful, or null if it fails.
Future<UserCredential?> anonymousSignInFunc() =>
    FirebaseAuth.instance.signInAnonymously();
