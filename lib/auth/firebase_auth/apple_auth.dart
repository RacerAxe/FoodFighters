import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce.
///
/// A nonce is a random string used to prevent replay attacks.
/// [length] specifies the length of the generated nonce (default is 32).
///
/// Returns a String containing the generated nonce.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Computes the SHA-256 hash of the input string.
///
/// [input] is the string to be hashed.
///
/// Returns a String representing the hexadecimal notation of the hash.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// Initiates the Apple Sign-In process and returns a UserCredential.
///
/// This function handles both web and mobile platforms differently:
/// - For web, it uses Firebase's OAuthProvider directly.
/// - For mobile, it uses the sign_in_with_apple package with additional security measures.
///
/// Returns a Future<UserCredential> representing the signed-in user's credentials.
Future<UserCredential> appleSignIn() async {
  if (kIsWeb) {
    // Web-specific sign-in process
    final provider = OAuthProvider("apple.com")
      ..addScope('email')
      ..addScope('name');

    return await FirebaseAuth.instance.signInWithPopup(provider);
  }

  // Mobile-specific sign-in process
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an OAuthCredential from the credential returned by Apple
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // Sign in the user with Firebase
  final user =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

  // Construct display name from given name and family name
  final displayName = [appleCredential.givenName, appleCredential.familyName]
      .where((name) => name != null)
      .join(' ');

  // Update user's display name if available
  if (displayName.isNotEmpty) {
    await user.user?.updateDisplayName(displayName);
  }

  return user;
}
