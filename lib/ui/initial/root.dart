import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:durkhawpui/ui/home/homeRoot.dart';
import 'package:durkhawpui/ui/initial/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _fire = FirebaseFirestore.instance.collection('users');
  final secure = Get.put(SecureController());
  bool? signedIn;

  @override
  void initState() {
    super.initState();
    listenAuth();
  }

  listenAuth() async {
    var isFirstTime = await secure.isFirstTime();
    if (isFirstTime is bool && isFirstTime) {
      Get.offAll(SignIn());
      return true;
    } else {
      User? user = auth.currentUser;
      if (user != null) {
        //TODO get user data
      }
      Get.offAll(HomeRoot());
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Checking authentication, please wait...",
              style: GoogleFonts.roboto(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
