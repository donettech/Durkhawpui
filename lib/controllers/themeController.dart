import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'pref_controller.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final PrefController pref = Get.find();

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    update();
    await pref.to.setString('theme', themeMode.toString().split('.')[1]);
  }

  void toggleTheme() async {
    var _theme = ThemeController.to.themeMode;
    if (_theme == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  ThemeMode getThemeModeFromPreferences() {
    ThemeMode themeMode;
    String themeText = pref.to.getString('theme') ?? 'system';
    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
    return themeMode;
  }

  String getThemeModeString() {
    String themeText = pref.to.getString('theme') ?? 'system';
    return themeText;
  }
}
