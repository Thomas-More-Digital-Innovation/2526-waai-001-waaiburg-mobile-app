import 'package:shared_preferences/shared_preferences.dart';

class AvatarTooltipController {
  static const String _prefsKey = 'hasSeenAvatarScreen';

  Future<bool> shouldShowTooltip() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOpened = prefs.getBool(_prefsKey) ?? false;
    return !hasOpened;
  }

  Future<void> markTooltipAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);
  }
}
