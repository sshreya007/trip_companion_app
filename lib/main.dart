import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';
import 'package:trip_planner/features/auth/presentation/pages/login_page.dart';
import 'package:trip_planner/screens/onboarding_screen.dart';
import 'package:trip_planner/features/auth/presentation/pages/signup_page.dart';
import 'package:trip_planner/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthHiveModelAdapter());

  // ✅ Open the auth box for storing users
  await Hive.openBox<AuthHiveModel>('authBox');

  // ✅ Open a separate box for storing preferences (like current user email)
  await Hive.openBox('prefsBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/signup': (_) => const SignupPage(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}
