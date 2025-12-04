import 'package:flutter/material.dart';
import 'package:trip_planner/screens/signup.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignupScreen());
  }
}
