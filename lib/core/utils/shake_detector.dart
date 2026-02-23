import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  ShakeDetector({
    required this.onShake,
    this.shakeThreshold = 2.7,
    this.shakeDuration = const Duration(milliseconds: 500),
  });

  /// Callback when shake is detected
  final VoidCallback onShake;

  /// Threshold for shake detection (higher = harder shake needed)
  final double shakeThreshold;

  /// Duration within which shake must occur
  final Duration shakeDuration;

  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  DateTime? _lastShakeTime;
  int _shakeCount = 0;

  /// Start listening for shake
  void startListening() {
    _streamSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      final gX = event.x;
      final gY = event.y;
      final gZ = event.z;

      // Calculate total acceleration
      final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      // Check if shake threshold exceeded
      if (gForce > shakeThreshold) {
        final now = DateTime.now();

        // First shake or shake within duration window
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > shakeDuration) {
          _lastShakeTime = now;
          _shakeCount = 1;
        } else {
          _shakeCount++;
        }

        // Require 3 shakes to trigger
        if (_shakeCount >= 3) {
          _shakeCount = 0;
          _lastShakeTime = null;
          onShake();
        }
      }
    });
  }

  /// Stop listening
  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  /// Dispose
  void dispose() {
    stopListening();
  }
}
