import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

import 'package:trip_planner/screens/onboarding_screen.dart';
import 'package:trip_planner/screens/signup.dart';
import 'package:trip_planner/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthHiveModelAdapter());

  runApp(const MyApp());
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
        '/signup': (_) => const SignupScreen(),
      },
    );
  }
}
