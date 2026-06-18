import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _key = 'saved_bets';

  Future<void> saveBets(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonString);
  }

  Future<String?> getBets() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}