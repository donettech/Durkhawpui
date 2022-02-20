import 'package:durkhawpui/utils/language/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/UserController.dart';
import 'controllers/languageController.dart';
import 'controllers/pref_controller.dart';
import 'controllers/themeController.dart';
import 'ui/initial/root.dart';
import 'utils/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.put(PrefController(), permanent: true).setUp();
  Get.lazyPut(() => ThemeController());
  Get.lazyPut(() => LanguageController());
  Get.put(UserController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.to.getThemeModeFromPreferences();
    LanguageController.to.getLocaleFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Durkhawpui',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.native,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      translations: Strings(),
      locale: Get.deviceLocale,
      fallbackLocale: Get.deviceLocale,
      home: Root(),
    );
  }
}
