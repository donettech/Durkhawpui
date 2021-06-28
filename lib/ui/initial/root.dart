import 'package:durkhawpui/ui/home/homeRoot.dart';
import 'package:durkhawpui/ui/initial/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool? signedIn;

  @override
  void initState() {
    super.initState();
    listenAuth();
    // Get.lazyPut(() => NotiController());
  }

  listenAuth() {
    var signedUser = auth.currentUser;
    if (signedUser != null) {
      setState(() {
        signedIn = true;
      });
    }
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          signedIn = false;
        });
      } else {
        setState(() {
          signedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn == null) {
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
    } else
      return signedIn! ? HomeRoot() : SignIn();
  }
}
