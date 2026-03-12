import 'package:hive_flutter/hive_flutter.dart';
// import 'package:transly/domain/models.dart';

class LocalAppStorage {
  static const String _appSettingsBox = 'app_settings';

  static const _userTokenKey = 'user_token';

  static const _userRoleKey = 'user_role';

  static const _isLoggedInKey = 'is_logged_in';

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

  static Future<void> saveUserSession(String role) async {
    await _appSettingsBoxInstance.put(_isLoggedInKey, true);
    await _appSettingsBoxInstance.put(_userRoleKey, role);
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
  }

  static bool isLoggedIn() {
    try {
      return _appSettingsBoxInstance.get(_isLoggedInKey, defaultValue: false)
          as bool;
    } catch (_) {
      return false;
    }
  }
}
