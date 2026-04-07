import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
// import 'package:transly/domain/models.dart';

class LocalAppStorage {
  static const String _appSettingsBox = 'app_settings';

  static const _userTokenKey = 'user_token';

  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';

  static const _isLoggedInKey = 'is_logged_in';

  static const _tutorialCompletedVolunteerKey = 'tutorial_completed_volunteer';
  static const _tutorialCompletedAdminKey = 'tutorial_completed_admin';
  static const _tutorialCompletedTaskDetailsKey =
      'tutorial_completed_task_details';
  static const _tutorialCompletedCreateCampaignKey =
      'tutorial_completed_create_campaign';

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

  static Future<void> saveUserSession(String role, String userId) async {
    await _appSettingsBoxInstance.put(_isLoggedInKey, true);
    await _appSettingsBoxInstance.put(_userRoleKey, role);
    await _appSettingsBoxInstance.put(_userIdKey, userId);
  }

  //   // =========================================================================
  //   // BOX ACCESSORS
  //   // =========================================================================
  static Box<dynamic> get _appSettingsBoxInstance =>
      Hive.box<dynamic>(_appSettingsBox);
  //   // =========================================================================
  //   // APP SETTINGS
  //   // =========================================================================

  static String? getUserToken() {
    try {
      final token = _appSettingsBoxInstance.get(_userTokenKey);
      return token as String?;
    } catch (_) {
      return null;
    }
  }

  static String? getUserRole() {
    try {
      final role = _appSettingsBoxInstance.get(_userRoleKey);
      return role as String?;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUserSession() async {
    await _appSettingsBoxInstance.delete(_isLoggedInKey);
    await _appSettingsBoxInstance.delete(_userRoleKey);
    await _appSettingsBoxInstance.delete(_userIdKey);
  }

  static String? getUserId() {
    try {
      return _appSettingsBoxInstance.get(_userIdKey) as String?;
    } catch (_) {
      return null;
    }
  }

  static bool isLoggedIn() {
    try {
      return _appSettingsBoxInstance.get(_isLoggedInKey, defaultValue: false)
          as bool;
    } catch (_) {
      return false;
    }
  }

  // =========================================================================
  // TUTORIAL FLAGS
  // =========================================================================

  static bool isVolunteerTutorialCompleted() =>
      _appSettingsBoxInstance.get(
            _tutorialCompletedVolunteerKey,
            defaultValue: false,
          )
          as bool;

  static Future<void> setVolunteerTutorialCompleted(bool value) async {
    await _appSettingsBoxInstance.put(_tutorialCompletedVolunteerKey, value);
  }

  static bool isAdminTutorialCompleted() =>
      _appSettingsBoxInstance.get(
            _tutorialCompletedAdminKey,
            defaultValue: false,
          )
          as bool;

  static Future<void> setAdminTutorialCompleted(bool value) async {
    await _appSettingsBoxInstance.put(_tutorialCompletedAdminKey, value);
  }

  static bool isTaskDetailsTutorialCompleted() =>
      _appSettingsBoxInstance.get(
            _tutorialCompletedTaskDetailsKey,
            defaultValue: false,
          )
          as bool;

  static Future<void> setTaskDetailsTutorialCompleted(bool value) async {
    await _appSettingsBoxInstance.put(_tutorialCompletedTaskDetailsKey, value);
  }

  static bool isCreateCampaignTutorialCompleted() =>
      _appSettingsBoxInstance.get(
            _tutorialCompletedCreateCampaignKey,
            defaultValue: false,
          )
          as bool;

  static Future<void> setCreateCampaignTutorialCompleted(bool value) async {
    await _appSettingsBoxInstance.put(
      _tutorialCompletedCreateCampaignKey,
      value,
    );
  }

  // =========================================================================
  // CACHE
  // =========================================================================

  static const String _cachePrefix = 'cache_';

  static Future<void> setCache(
    String key,
    dynamic data, {
    Duration ttl = const Duration(minutes: 10),
  }) async {
    try {
      final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
      final encoded = json.encode({'d': data, 'e': expiry});
      await _appSettingsBoxInstance.put('$_cachePrefix$key', encoded);
    } catch (_) {}
  }

  static dynamic getCache(String key) {
    try {
      final raw = _appSettingsBoxInstance.get('$_cachePrefix$key') as String?;
      if (raw == null) return null;
      final map = json.decode(raw) as Map<String, dynamic>;
      final expiry = map['e'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiry) {
        _appSettingsBoxInstance.delete('$_cachePrefix$key');
        return null;
      }
      return map['d'];
    } catch (_) {
      return null;
    }
  }

  static Future<void> invalidateCache(String key) async {
    try {
      await _appSettingsBoxInstance.delete('$_cachePrefix$key');
    } catch (_) {}
  }

  static Future<void> invalidateCacheByPrefix(String prefix) async {
    try {
      final keys = _appSettingsBoxInstance.keys
          .where((k) => k is String && k.startsWith('$_cachePrefix$prefix'))
          .toList();
      for (final k in keys) {
        await _appSettingsBoxInstance.delete(k);
      }
    } catch (_) {}
  }
}
