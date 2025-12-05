import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  List<String> titles = [
    "Welcome to Trip Planner",
    "Plan Your Trips Easily",
    "Enjoy Your Holidays",
  ];

  List<String> descriptions = [
    "This app helps you plan and manage trips with comfort.",
    "Book hotels, transport and activities instantly.",
    "Start your journey and explore the world!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/splash_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark overlay
          Container(color: Colors.black.withOpacity(0.45)),

          /// PageView content
          PageView.builder(
            controller: _controller,
            itemCount: titles.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titles[index],
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      descriptions[index],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    /// Dots indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        titles.length,
                        (dotIndex) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == dotIndex ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex
                                ? Colors.white
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    /// Next / Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        if (currentIndex == titles.length - 1) {
                          // Navigate to Signup page
                          Navigator.pushReplacementNamed(context, "/signup");
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        currentIndex == titles.length - 1
                            ? "Get Started"
                            : "Next",
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Skip Button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/signup");
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
