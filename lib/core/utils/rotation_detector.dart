import 'dart:async';
import 'dart:ui';
import 'package:sensors_plus/sensors_plus.dart';

class RotationDetector {
  RotationDetector({
    required this.onRotationToLandscape,
    required this.onRotationToPortrait,
    this.rotationThreshold = 5.0,
  });

  final VoidCallback onRotationToLandscape;
  final VoidCallback onRotationToPortrait;
  final double rotationThreshold;

  StreamSubscription<GyroscopeEvent>? _streamSubscription;
  bool _isLandscape = false;

  void startListening() {
    _streamSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      // event.y detects rotation around Y axis (landscape/portrait rotation)
      final rotationY = event.y.abs();

      if (rotationY > rotationThreshold) {
        if (!_isLandscape) {
          _isLandscape = true;
          print('🔄 ROTATION TO LANDSCAPE DETECTED!');
          onRotationToLandscape();
        }
      } else {
        if (_isLandscape) {
          _isLandscape = false;
          print('🔄 ROTATION TO PORTRAIT DETECTED!');
          onRotationToPortrait();
        }
      }
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void dispose() {
    stopListening();
  }
}
