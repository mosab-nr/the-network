import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static final SharedPrefManager _instance = SharedPrefManager._internal();
  late SharedPreferences _prefs;

  factory SharedPrefManager() => _instance;

  SharedPrefManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setFirstTimeLogin(bool isFirstTime) async {
    await _prefs.setBool('firstTimeLogin', isFirstTime);
  }

  bool isFirstTimeLogin() {
    return _prefs.getBool('firstTimeLogin') ?? true;
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString('userName', name);
  }

  String? getUserName() {
    return _prefs.getString('userName');
  }

  Future<void> saveSelectedVotes(Map<String, String?> selectedVotes) async {
    selectedVotes.forEach((key, value) {
      _prefs.setString(key, value ?? '');
    });
  }

  Future<Map<String, String?>> loadSelectedVotes() async {
    final keys = _prefs.getKeys();
    final selectedVotes = <String, String?>{};
    for (var key in keys) {
      if (key.startsWith('vote_')) {
        selectedVotes[key] = _prefs.getString(key);
      }
    }
    return selectedVotes;
  }


}