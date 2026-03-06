import 'package:shared_preferences/shared_preferences.dart';

import 'app_const.dart';

enum LoginType { google, email }

class AppPrefs {
  final SharedPreferences _sharedPreferences;

  AppPrefs(this._sharedPreferences);
  Future<bool> saveUserToken(String token) async {
    return await _sharedPreferences.setString(AppConst.tokenKey, token);
  }

  Future<bool> saveLoginType(LoginType type) async {
    return await _sharedPreferences.setString(
      AppConst.loginType,
      type.toString(),
    );
  }

  Future<bool> saveUserEmail(String email) async {
    return await _sharedPreferences.setString(AppConst.emailKey, email);
  }

  Future<bool> saveUserName(String name) async {
    return await _sharedPreferences.setString(AppConst.userNameKey, name);
  }

  Future<bool> saveUserScore(num score) async {
    return await _sharedPreferences.setDouble(
      AppConst.userScoreKey,
      double.parse(score.toString()),
    );
  }

  Future<bool> saveUserId(String id) async {
    return await _sharedPreferences.setString(AppConst.userIdKey, id);
  }

  Future<bool> saveUserAvatar(String photo) async {
    return await _sharedPreferences.setString(AppConst.userAvatarKey, photo);
  }

  Future<bool> saveLocale(String languageCode) async {
    return await _sharedPreferences.setString(AppConst.localeKey, languageCode);
  }

  Future<bool> saveMusicState(bool state) async {
    return await _sharedPreferences.setBool(AppConst.musicStateKey, state);
  }

  Future<bool> saveGameSoundsState(bool state) async {
    return await _sharedPreferences.setBool(AppConst.gameSoundsKey, state);
  }

  bool getMusicState() {
    return _sharedPreferences.getBool(AppConst.musicStateKey) ?? true;
  }

  bool getGameSoundsState() {
    return _sharedPreferences.getBool(AppConst.gameSoundsKey) ?? true;
  }

  String getUserToken() {
    return _sharedPreferences.getString(AppConst.tokenKey) ?? '';
  }

  LoginType getLoginType() {
    final type = _sharedPreferences.getString(AppConst.loginType) ?? '';
    return LoginType.values.firstWhere((element) => element.toString() == type);
  }

  String getUserEmail() {
    return _sharedPreferences.getString(AppConst.emailKey) ?? '';
  }

  String getUserId() {
    return _sharedPreferences.getString(AppConst.userIdKey) ?? '';
  }

  String getUserAvatar() {
    return _sharedPreferences.getString(AppConst.userAvatarKey) ?? '';
  }

  String getUserName() {
    return _sharedPreferences.getString(AppConst.userNameKey) ?? '';
  }

  num getUserScore() {
    return _sharedPreferences.getDouble(AppConst.userScoreKey) ?? 0;
  }
}
