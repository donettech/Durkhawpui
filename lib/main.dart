import 'package:durkhawpui/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/UserController.dart';
import 'ui/initial/root.dart';

void main() async {
  Get.lazyPut(() => UserController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Durkhawpui',
      theme: ThemeData.dark().copyWith(
        primaryColor: Constants.primary,
      ),
      darkTheme: ThemeData.dark(),
      home: Root(),
    );
  }
}
