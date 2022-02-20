import 'package:durkhawpui/controllers/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeTile extends StatelessWidget {
  ThemeTile({Key? key}) : super(key: key);

  final ThemeController theme = Get.find();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.light_mode_outlined),
      title: Text("Theme"),
      subtitle: Text(theme.getThemeModeString()),
      trailing: _getThemeIcon(),
      onTap: () {
        theme.toggleTheme();
      },
    );
  }

  Widget _getThemeIcon() {
    if (theme.getThemeModeFromPreferences() == ThemeMode.dark) {
      return Icon(Icons.brightness_3);
    } else {
      return Icon(Icons.brightness_7);
    }
  }
}
