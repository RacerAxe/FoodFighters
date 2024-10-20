import 'package:firebase_auth/firebase_auth.dart';

/// Signs in a user using a custom JWT token.
///
/// This function takes a JWT token as input and uses it to authenticate
/// the user with Firebase. It's useful for integrating with custom
/// authentication systems that generate JWT tokens.
///
/// Parameters:
///   [jwtToken] - A string representing the JWT token for authentication.
///
/// Returns:
///   A Future that resolves to a [UserCredential] object if the sign-in
///   is successful, or null if it fails.
Future<UserCredential?> jwtTokenSignIn(String jwtToken) async {
  try {
    return await FirebaseAuth.instance.signInWithCustomToken(jwtToken);
  } catch (e) {
    print('Error during JWT token sign-in: $e');
    return null;
  }
}
