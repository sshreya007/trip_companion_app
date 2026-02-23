import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/features/auth/presentation/pages/signup_page.dart';

Widget buildTestWidget() {
  return const ProviderScope(child: MaterialApp(home: SignupPage()));
}

void main() {
  group('SignupPage Widget Tests', () {
    // Test 1: Page renders without crashing
    testWidgets('1. SignupPage renders successfully', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(SignupPage), findsOneWidget);
    });

    // Test 2: "Create Account" heading is visible
    testWidgets('2. Create Account heading is displayed', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.textContaining('Create'), findsOneWidget);
    });

    // Test 3: "Sign Up" card title is visible
    testWidgets('3. Sign Up card title is displayed', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Sign Up'), findsWidgets);
    });

    // Test 4: All 6 input fields are present
    testWidgets('4. All 6 text input fields are rendered', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(TextField), findsNWidgets(6));
    });

    // Test 5: Correct hint texts are shown
    testWidgets('5. All hint texts are present', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    // Test 6: Login redirect text is visible
    testWidgets('6. Login redirect row is displayed', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    // Test 7: Sign Up ElevatedButton is present
    testWidgets('7. Sign Up button is present', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    });

    // Test 8: Sign Up button is rendered
    testWidgets('8.Sign Up button is displayed', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupPage())),
      );
      await tester.pumpAndSettle();

      // Assert
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      expect(signUpButton, findsOneWidget);
    });

    // Test 9: Login redirect link is present
    testWidgets('9.Login redirect link is displayed', (
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
    testWidgets('10.All input fields have appropriate icons', (
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
