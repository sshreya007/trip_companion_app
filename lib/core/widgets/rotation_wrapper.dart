import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trip_planner/core/utils/rotation_detector.dart';

/// Wrap screens that should support rotation detection
class RotationWrapper extends StatefulWidget {
  final Widget child;
  final bool enableRotationDetection;

  const RotationWrapper({
    super.key,
    required this.child,
    this.enableRotationDetection = true,
  });

  @override
  State<RotationWrapper> createState() => _RotationWrapperState();
}

class _RotationWrapperState extends State<RotationWrapper> {
  late RotationDetector _rotationDetector;

  @override
  void initState() {
    super.initState();

    if (widget.enableRotationDetection) {
      _rotationDetector = RotationDetector(
        onRotationToLandscape: _switchToLandscape,
        onRotationToPortrait: _switchToPortrait,
        rotationThreshold: 4.0,
      );

      _rotationDetector.startListening();
    }
  }

  void _switchToLandscape() {
    print('🔄 Switching to LANDSCAPE mode');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Show notification
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.screen_rotation, color: Colors.white),
              SizedBox(width: 12),
              Text('Switched to Landscape Mode'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void _switchToPortrait() {
    print('🔄 Switching to PORTRAIT mode');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Show notification
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.screen_rotation, color: Colors.white),
              SizedBox(width: 12),
              Text('Switched to Portrait Mode'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enableRotationDetection) {
      _rotationDetector.dispose();

      // Reset orientation to portrait when leaving
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
