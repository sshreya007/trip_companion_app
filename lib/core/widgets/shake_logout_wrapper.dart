import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/utils/shake_detector.dart';
import 'package:trip_planner/features/auth/presentation/pages/login_page.dart';
import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';

/// Wrap your app with this to enable shake-to-logout
class ShakeLogoutWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ShakeLogoutWrapper({super.key, required this.child});

  @override
  ConsumerState<ShakeLogoutWrapper> createState() => _ShakeLogoutWrapperState();
}

class _ShakeLogoutWrapperState extends ConsumerState<ShakeLogoutWrapper> {
  late ShakeDetector _shakeDetector;
  bool _showingDialog = false;

  @override
  void initState() {
    super.initState();

    _shakeDetector = ShakeDetector(
      onShake: _onShakeDetected,
      shakeThreshold: 2.5, // Adjust sensitivity (lower = more sensitive)
    );

    _shakeDetector.startListening();
  }

  void _onShakeDetected() {
    print('📳 SHAKE DETECTED!');

    // Prevent multiple dialogs
    if (_showingDialog) return;

    // Show vibration feedback (optional)
    _showLogoutDialog();
  }

  void _showLogoutDialog() {
    if (!mounted) return;

    setState(() {
      _showingDialog = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.vibration, color: Colors.orange),
            SizedBox(width: 12),
            Text('Shake Detected!'),
          ],
        ),
        content: const Text(
          'Do you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showingDialog = false;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _showingDialog = false;
        });
      }
    });
  }

  void _performLogout() async {
    print('👋 Logging out...');

    // Call your logout method
    await ref.read(authViewModelProvider.notifier).logout();

    if (mounted) {
      // Navigate to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
