import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase for the application.
///
/// This function sets up Firebase differently for web and mobile platforms:
/// - For web, it uses specific Firebase options.
/// - For mobile, it uses the default configuration.
Future<void> initFirebase() async {
  if (kIsWeb) {
    // Web-specific initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCjWkAKNAmSf5BODvd-HNhh2R9GYKRaqZw",
        authDomain: "food-planner-0jqlzf.firebaseapp.com",
        projectId: "food-planner-0jqlzf",
        storageBucket: "food-planner-0jqlzf.appspot.com",
        messagingSenderId: "499350555106",
        appId: "1:499350555106:web:396afbeb53cd9f929711bb",
      ),
    );
  } else {
    // Mobile-specific initialization
    await Firebase.initializeApp();
  }
}
