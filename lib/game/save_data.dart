import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static int coins = 0;

  static int highScore = 0;

  static Future<void> load() async {
    final prefs =
        await SharedPreferences.getInstance();

    coins = prefs.getInt('coins') ?? 0;

    highScore =
        prefs.getInt('highScore') ?? 0;
  }

  static Future<void> save() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      'coins',
      coins,
    );

    await prefs.setInt(
      'highScore',
      highScore,
    );
  }
}