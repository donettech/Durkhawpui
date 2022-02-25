import 'dart:developer';

import 'package:durkhawpui/utils/constants.dart';
import 'package:durkhawpui/utils/language/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'controllers/UserController.dart';
import 'controllers/languageController.dart';
import 'controllers/notiController.dart';
import 'controllers/pref_controller.dart';
import 'controllers/themeController.dart';
import 'ui/initial/root.dart';
import 'utils/themes/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel = AndroidNotificationChannel(
  Constants.channelId,
  Constants.channelName,
  description: Constants.channelDesc,
  importance: Importance.high,
  showBadge: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: IOSInitializationSettings(),
    ),
  );

  await Get.put(PrefController(), permanent: true).setUp();
  Get.lazyPut(() => ThemeController());
  Get.lazyPut(() => LanguageController());
  Get.put(UserController(), permanent: true);
  await Get.put(NotiController(), permanent: true).setupMessaging();
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
