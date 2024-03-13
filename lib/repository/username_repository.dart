import 'package:shared_preferences/shared_preferences.dart';

class UsernameRepository {
  late Future<SharedPreferences> _preferences;

  static const _usernameKey = "username";

  UsernameRepository({required Future<SharedPreferences> preferences}) {
    _preferences = preferences;
  }

  Future<String?> getUsername() async {
    return (await _preferences).getString(_usernameKey);
  }

  void setUsername(String username) async {
    (await _preferences).setString(_usernameKey, username);
  }
}
