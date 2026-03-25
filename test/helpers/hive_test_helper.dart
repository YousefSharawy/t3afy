import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

Directory? _hiveDir;

/// Opens a fresh Hive box in a temp dir. Call in setUp.
Future<void> setUpHive() async {
  _hiveDir ??= await Directory.systemTemp.createTemp('hive_test');
  Hive.init(_hiveDir!.path);
  if (!Hive.isBoxOpen('app_settings')) {
    await Hive.openBox<dynamic>('app_settings');
  }
}

/// Closes and clears the Hive box without deleting the dir. Call in tearDown.
Future<void> tearDownHive() async {
  if (Hive.isBoxOpen('app_settings')) {
    await Hive.box<dynamic>('app_settings').clear();
  }
}
