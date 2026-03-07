import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  @override
  void initState() {
    super.initState();

    // ✅ Allow all orientations by default
    if (widget.enableRotationDetection) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // ✅ Reset to portrait only when leaving
    if (widget.enableRotationDetection) {
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
