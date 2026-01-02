import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/service/hive/hive_service.dart';

// Riverpod Provider wrapping your HiveService singleton
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService.instance;
});
