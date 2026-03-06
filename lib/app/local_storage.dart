import 'package:hive_flutter/hive_flutter.dart';
// import 'package:transly/domain/models.dart';

class LocalAppStorage {
//   static const String _cacheMetadataBox = 'cache_metadata';z
  static const String _appSettingsBox = 'app_settings';

//   static const int _maxRecentlyViewed = 2;
//   static const int _maxRecentlySearched = 5;
//   static const Duration _cacheExpiration = Duration(hours: 24);

  static const String _onboardingCompletedKey = 'onboarding_completed';

//   // =========================================================================
//   // INIT
//   // =========================================================================

  static Future<void> init() async {
    await Hive.initFlutter();
    await _openBoxSafely<dynamic>(_appSettingsBox);
  }
  static Future<void> _openBoxSafely<T>(String boxName) async {
    try {
      await Hive.openBox<T>(boxName);
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox<T>(boxName);
    }
  }
  static Future<void> _reopenBoxWithNewType<T>(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) await Hive.box(boxName).close();
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox<T>(boxName);
    } catch (e) {
      await Hive.openBox<T>(boxName);
    }
  }

//   // =========================================================================
//   // BOX ACCESSORS
//   // =========================================================================
  static Box<dynamic> get _appSettingsBoxInstance =>
      Hive.box<dynamic>(_appSettingsBox);
//   // =========================================================================
//   // APP SETTINGS
//   // =========================================================================
  static bool isOnboardingCompleted() {
    try {
      return _appSettingsBoxInstance.get(
        _onboardingCompletedKey,
        defaultValue: false,
      ) as bool;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setOnboardingCompleted() async {
    try {
      await _appSettingsBoxInstance.put(_onboardingCompletedKey, true);
    } catch (_) {}
  }

  static Future<void> resetOnboarding() async {
    try {
      await _appSettingsBoxInstance.delete(_onboardingCompletedKey);
    } catch (_) {}
  }

//   // =========================================================================
//   // CACHE HELPERS — single implementation, used everywhere
//   // =========================================================================

//   static bool _isCacheValid(String key) {
//     try {
//       final timestamp = _cacheMetadataBoxInstance.get('${key}_timestamp');
//       if (timestamp == null) return false;
//       final cachedTime = DateTime.parse(timestamp.toString());
//       return DateTime.now().difference(cachedTime) < _cacheExpiration;
//     } catch (_) {
//       return false;
//     }
//   }
}