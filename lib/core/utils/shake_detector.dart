import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart';

class ShakeDetector {
  ShakeDetector({
    required this.onShake,
    this.shakeThreshold = 12.0, // ✅ Must be > 9.8 (gravity)
    this.shakeSlopTime = 500,
    this.shakeCountResetTime = 3000,
    this.requiredShakeCount = 3,
  });

  final VoidCallback onShake;
  final double shakeThreshold;
  final int shakeSlopTime;
  final int shakeCountResetTime;
  final int requiredShakeCount;

  StreamSubscription<UserAccelerometerEvent>? _streamSubscription;
  int _mShakeCount = 0;
  int _mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;

  // ✅ Use userAccelerometerEventStream - gravity already removed!
  void startListening() {
    debugPrint('🔔 Shake detector started listening...');

    _streamSubscription = userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        var gX = event.x;
        var gY = event.y;
        var gZ = event.z;

        // ✅ With userAccelerometer, gravity is removed.
        // At rest this will be ~0, during shake it spikes.
        double acceleration = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (acceleration > shakeThreshold) {
          var now = DateTime.now().millisecondsSinceEpoch;

          if (_mShakeTimestamp + shakeSlopTime > now) {
            return;
          }

          if (_mShakeTimestamp + shakeCountResetTime < now) {
            _mShakeCount = 0;
          }

          _mShakeTimestamp = now;
          _mShakeCount++;

          debugPrint(
            '🔔 Shake detected! Count: $_mShakeCount, Force: ${acceleration.toStringAsFixed(2)}',
          );

          if (_mShakeCount >= requiredShakeCount) {
            debugPrint('🎉 SHAKE THRESHOLD REACHED - TRIGGERING CALLBACK!');
            _mShakeCount = 0;
            onShake();
          }
        }
      },
      onError: (error) {
        debugPrint('❌ Shake detector error: $error');
      },
    );
  }

  void stopListening() {
    debugPrint('🔔 Shake detector stopped listening');
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void dispose() {
    stopListening();
  }
}
