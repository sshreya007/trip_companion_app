import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/pages/signup_page.dart';

/// Widget Tests for SignupPage (Simplified - No Hive Dependencies)
/// These tests verify UI elements and user interactions

void main() {
  // No setup needed - avoiding Hive initialization

  group('SignupPage Widget Tests', () {
    /// Test 1: All input fields are rendered
    testWidgets('All 6 input fields are rendered on screen', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsNWidgets(6));
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    /// Test 2: Sign Up button is rendered
    testWidgets('Sign Up button is displayed', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Assert
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      expect(signUpButton, findsOneWidget);
    });

    /// Test 3: User can type in text fields
    testWidgets('User can enter text in all fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Act - Find text fields and enter text
      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'johndoe');
      await tester.enterText(textFields.at(3), 'john@example.com');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.enterText(textFields.at(5), 'password123');

      await tester.pump();

      // Assert
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('johndoe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(
        find.text('password123'),
        findsNWidgets(2),
      ); // Password and Confirm Password
    });

    /// Test 4: Login redirect link is present
    testWidgets('Login redirect link is displayed', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    /// Test 5: All input fields have correct icons
    testWidgets('All input fields have appropriate icons', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Assert - Check for icons
      expect(find.byIcon(Icons.person), findsOneWidget); // First Name
      expect(find.byIcon(Icons.person_outline), findsOneWidget); // Last Name
      expect(find.byIcon(Icons.account_circle), findsOneWidget); // Username
      expect(find.byIcon(Icons.email), findsOneWidget); // Email
      expect(find.byIcon(Icons.lock), findsOneWidget); // Password
      expect(
        find.byIcon(Icons.lock_outline),
        findsOneWidget,
      ); // Confirm Password
    });
  });
}
