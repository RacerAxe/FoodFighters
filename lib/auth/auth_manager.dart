import 'package:flutter/material.dart';

import 'base_auth_user_provider.dart';

/// Abstract class defining the core authentication operations.
abstract class AuthManager {
  /// Signs out the current user.
  Future signOut();

  /// Deletes the current user's account.
  Future deleteUser(BuildContext context);

  /// Updates the email address of the current user.
  Future updateEmail({required String email, required BuildContext context});

  /// Initiates the password reset process for the given email.
  Future resetPassword({required String email, required BuildContext context});

  /// Sends an email verification to the current user.
  Future sendEmailVerification() async => currentUser?.sendEmailVerification();

  /// Refreshes the current user's data.
  Future refreshUser() async => currentUser?.refreshUser();
}

/// Mixin for email and password authentication.
mixin EmailSignInManager on AuthManager {
  /// Signs in a user with email and password.
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  );

  /// Creates a new account with email and password.
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  );
}

/// Mixin for anonymous authentication.
mixin AnonymousSignInManager on AuthManager {
  /// Signs in a user anonymously.
  Future<BaseAuthUser?> signInAnonymously(BuildContext context);
}

/// Mixin for Apple Sign-In authentication.
mixin AppleSignInManager on AuthManager {
  /// Signs in a user with Apple.
  Future<BaseAuthUser?> signInWithApple(BuildContext context);
}

/// Mixin for Google Sign-In authentication.
mixin GoogleSignInManager on AuthManager {
  /// Signs in a user with Google.
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context);
}

/// Mixin for JWT token authentication.
mixin JwtSignInManager on AuthManager {
  /// Signs in a user with a JWT token.
  Future<BaseAuthUser?> signInWithJwtToken(
    BuildContext context,
    String jwtToken,
  );
}

/// Mixin for phone number authentication.
mixin PhoneSignInManager on AuthManager {
  /// Initiates phone number authentication.
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required void Function(BuildContext) onCodeSent,
  });

  /// Verifies the SMS code sent during phone authentication.
  Future verifySmsCode({
    required BuildContext context,
    required String smsCode,
  });
}

/// Mixin for Facebook authentication.
mixin FacebookSignInManager on AuthManager {
  /// Signs in a user with Facebook.
  Future<BaseAuthUser?> signInWithFacebook(BuildContext context);
}

/// Mixin for Microsoft authentication.
mixin MicrosoftSignInManager on AuthManager {
  /// Signs in a user with Microsoft.
  Future<BaseAuthUser?> signInWithMicrosoft(
    BuildContext context,
    List<String> scopes,
    String tenantId,
  );
}

/// Mixin for GitHub authentication.
mixin GithubSignInManager on AuthManager {
  /// Signs in a user with GitHub.
  Future<BaseAuthUser?> signInWithGithub(BuildContext context);
}
