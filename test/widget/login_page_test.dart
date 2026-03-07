import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/pages/login_page.dart';

void main() {
  group('Login Page Widget Tests', () {
    testWidgets('1. Should display all UI elements', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Assert
      expect(find.text('Welcome\nBack.....'), findsOneWidget);
      expect(find.text('Login'), findsNWidgets(2)); // Title and button
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Enter your Email'), findsOneWidget);
      expect(find.text('Enter your Password'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('2. Should have email input field', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Assert
      final emailField = find.widgetWithText(TextField, 'Enter your Email');
      expect(emailField, findsOneWidget);
    });

    testWidgets('3. Should have password input field', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Assert
      final passwordField = find.widgetWithText(
        TextField,
        'Enter your Password',
      );
      expect(passwordField, findsOneWidget);
    });

    testWidgets('4. Should have login button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Assert
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('5. Should allow text input in email field', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Act
      final emailField = find.widgetWithText(TextField, 'Enter your Email');
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('6. Should allow text input in password field', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Act
      final passwordField = find.widgetWithText(
        TextField,
        'Enter your Password',
      );
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Assert
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('7. Should show error when login with empty fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Act
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.text('Email and password are required'), findsOneWidget);
    });

    testWidgets('8. Should have Sign Up navigation link', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Assert
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
    });

    testWidgets('9. Password field should be obscured', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Act
      final passwordField = find.widgetWithText(
        TextField,
        'Enter your Password',
      );
      final textFieldWidget = tester.widget<TextField>(passwordField);

      // Assert
      expect(textFieldWidget.obscureText, true);
    });

    testWidgets('10. Should show error when only email is entered', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // Act - enter email but leave password empty
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter your Email'),
        'test@example.com',
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Assert
      expect(find.text('Email and password are required'), findsOneWidget);
    });
  });
}
