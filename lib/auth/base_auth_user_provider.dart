/// Represents basic information about an authenticated user.
class AuthUserInfo {
  const AuthUserInfo({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  /// Unique identifier for the user.
  final String? uid;

  /// User's email address.
  final String? email;

  /// User's display name.
  final String? displayName;

  /// URL of the user's profile photo.
  final String? photoUrl;

  /// User's phone number.
  final String? phoneNumber;
}

/// Abstract base class for authenticated users.
abstract class BaseAuthUser {
  /// Whether the user is currently logged in.
  bool get loggedIn;

  /// Whether the user's email has been verified.
  bool get emailVerified;

  /// Basic information about the authenticated user.
  AuthUserInfo get authUserInfo;

  /// Deletes the user's account.
  Future<void>? delete();

  /// Updates the user's email address.
  Future<void>? updateEmail(String email);

  /// Sends an email verification to the user.
  Future<void>? sendEmailVerification();

  /// Refreshes the user's data.
  Future<void> refreshUser() async {}

  // Convenience getters for user information
  String? get uid => authUserInfo.uid;
  String? get email => authUserInfo.email;
  String? get displayName => authUserInfo.displayName;
  String? get photoUrl => authUserInfo.photoUrl;
  String? get phoneNumber => authUserInfo.phoneNumber;
}

/// The currently authenticated user, if any.
BaseAuthUser? currentUser;

/// Whether a user is currently logged in.
bool get loggedIn => currentUser?.loggedIn ?? false;
