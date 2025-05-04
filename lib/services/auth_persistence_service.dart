import 'package:shared_preferences/shared_preferences.dart';

class AuthPersistenceService {
  static const String _rememberMeKey = 'remember_me';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';

  static Future<void> saveRememberMe(bool rememberMe, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userPasswordKey, password);
    } else {
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userPasswordKey);
    }
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (!rememberMe) return null;

    final email = prefs.getString(_userEmailKey);
    final password = prefs.getString(_userPasswordKey);
    if (email == null || password == null) return null;

    return {
      'email': email,
      'password': password,
    };
  }

  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPasswordKey);
  }
} 