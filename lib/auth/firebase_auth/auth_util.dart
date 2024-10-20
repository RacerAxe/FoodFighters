import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_auth_manager.dart';

export 'firebase_auth_manager.dart';

/// The singleton instance of FirebaseAuthManager.
final _authManager = FirebaseAuthManager();

/// Getter for the FirebaseAuthManager instance.
FirebaseAuthManager get authManager => _authManager;

/// Returns the current user's email address, or an empty string if not available.
String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? '';

/// Returns the current user's UID, or an empty string if not available.
String get currentUserUid => currentUser?.uid ?? '';

/// Returns the current user's display name, or an empty string if not available.
String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? '';

/// Returns the current user's photo URL, or an empty string if not available.
String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.photoUrl ?? '';

/// Returns the current user's phone number, or an empty string if not available.
String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? '';

/// Returns the current JWT token, or an empty string if not available.
String get currentJwtToken => _currentJwtToken ?? '';

/// Returns whether the current user's email is verified.
bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Stores the current JWT token.
String? _currentJwtToken;

/// Stream that listens to changes in the user's JWT token.
/// Firebase generates a new token every hour.
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

/// Returns the DocumentReference for the current user, or null if not logged in.
DocumentReference? get currentUserReference =>
    loggedIn ? UserRecord.collection.doc(currentUser!.uid) : null;

/// Stores the current user's document data.
UserRecord? currentUserDocument;

/// Stream that provides real-time updates of the authenticated user's data.
///
/// This stream performs the following steps:
/// 1. Listens to Firebase auth state changes
/// 2. Maps the user to their UID (or empty string if null)
/// 3. Switches to a new stream based on the UID:
///    - If UID is empty, returns a stream with null value
///    - If UID exists, fetches the user document from Firestore
/// 4. Updates the currentUserDocument variable
///
/// The stream is broadcast, allowing multiple listeners.
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : UserRecord.getDocument(UserRecord.collection.doc(uid))
              .handleError((_) {}),
    )
    .map((user) {
  currentUserDocument = user;
  return currentUserDocument;
}).asBroadcastStream();

/// A widget that rebuilds when the authenticated user stream updates.
///
/// This widget listens to the authenticatedUserStream and rebuilds its child
/// whenever the stream emits a new value. This is useful for updating UI
/// components that depend on the current user's data.
class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({super.key, required this.builder});

  /// The builder function that creates the widget tree.
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}
