import 'package:shared_preferences/shared_preferences.dart';

/// Remembers if the user already saw the onboarding screens.
class OnboardingPrefs {
  static const _key = 'onboarding_seen';

  static Future<bool> isSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  /// For testing only: forget that the onboarding was seen.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
