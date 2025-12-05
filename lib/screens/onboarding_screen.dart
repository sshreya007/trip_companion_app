import 'package:flutter/material.dart';
import 'login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  List<String> titles = ["Welcome to Trip Companion App", "Plan Trip Easily"];

  List<String> descriptions = [
    "This app helps users to plan and manage trips",
    "Book holidays and explore new destinations",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: titles.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 150),
                const SizedBox(height: 40),
                Text(
                  titles[index],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  descriptions[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    currentIndex == titles.length - 1 ? "Get Started" : "Skip",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
