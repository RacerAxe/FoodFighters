// This is a basic Flutter widget test file for the BiteWise app.
// It demonstrates how to set up and run widget tests to ensure the app's UI behaves correctly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bite_wise/main.dart';
import 'package:bite_wise/pages/start_page/start_page_widget.dart';
import 'package:bite_wise/pages/login/login_widget.dart';

void main() {
  group('BiteWise Widget Tests', () {
    testWidgets('App initialization test', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify that the app starts with the StartPageWidget
      expect(find.byType(StartPageWidget), findsOneWidget);
    });

    testWidgets('Navigation to Login page test', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Find and tap the login button
      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that the LoginWidget is displayed
      expect(find.byType(LoginWidget), findsOneWidget);
    });

    testWidgets('Login form validation test', (WidgetTester tester) async {
      // Build the LoginWidget directly for this test
      await tester.pumpWidget(const MaterialApp(home: LoginWidget()));

      // Find the email and password text fields
      final emailField = find.byKey(const Key('emailField'));
      final passwordField = find.byKey(const Key('passwordField'));

      // Enter invalid email and password
      await tester.enterText(emailField, 'invalid_email');
      await tester.enterText(passwordField, 'short');

      // Tap the login button
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify that error messages are displayed
      expect(find.text('Please enter a valid email address.'), findsOneWidget);
      expect(find.text('Password must be at least 6 characters long.'), findsOneWidget);
    });
  });
}
