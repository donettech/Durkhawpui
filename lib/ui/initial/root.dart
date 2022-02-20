import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/imageController.dart';
import 'package:durkhawpui/controllers/notiController.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeMain/homeMain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final secure = Get.put(SecureController());
  final noti = Get.put(NotiController());

  bool? signedIn;

  @override
  void initState() {
    super.initState();
    listenAuth();
    noti.handleNoti();
    Get.lazyPut(() => ImageController());
  }

  listenAuth() async {
    User? user = auth.currentUser;
    if (user != null) {
      Get.find<UserController>().getUserData(signedInUser: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeMain();
  }
}
