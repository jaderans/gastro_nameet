import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  static const _keyUserId = 'gastro_current_user_id';
  static const _keyUserName = 'gastro_current_user_name';
  static const _keyUserEmail = 'gastro_current_user_email';

  int? _cachedUserId;
  String? _cachedUserName;
  String? _cachedUserEmail;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getInt(_keyUserId);
    _cachedUserName = prefs.getString(_keyUserName);
    _cachedUserEmail = prefs.getString(_keyUserEmail);
  }

  Future<void> setCurrentUser({required int userId, String? name, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    if (name != null) await prefs.setString(_keyUserName, name);
    if (email != null) await prefs.setString(_keyUserEmail, email);
    _cachedUserId = userId;
    _cachedUserName = name ?? _cachedUserName;
    _cachedUserEmail = email ?? _cachedUserEmail;
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    _cachedUserId = null;
    _cachedUserName = null;
    _cachedUserEmail = null;
  }

  Future<int?> getCurrentUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getInt(_keyUserId);
    return _cachedUserId;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final id = await getCurrentUserId();
    if (id == null) return null;
    final prefs = await SharedPreferences.getInstance();
    return {
      'USER_ID': id,
      'USER_NAME': prefs.getString(_keyUserName),
      'USER_EMAIL': prefs.getString(_keyUserEmail),
    };
  }
}
