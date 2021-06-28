import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  double helloWidth = 50;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      setState(() {
        loading = true;
      });
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar('Error', e.message.toString(), backgroundColor: Colors.red);
      throw e;
    } catch (error) {
      setState(() {
        loading = false;
      });
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    animate();
  }

  void animate() {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {
        helloWidth = 220;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: SizedBox(
                  width: Get.width * 0.55,
                  height: Get.width * 0.55,
                  child: Image.asset(
                    'assets/114.png',
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 15,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
                width: helloWidth,
                height: 100,
                child: Image.asset(
                  'assets/hello.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 200,
              child: Text(
                "Durkhawpui",
                style: GoogleFonts.yellowtail(
                  fontSize: 35,
                ),
              ),
            ),
            // Positioned(
            //   bottom: 10,
            //   right: 5,
            //   child: SizedBox(
            //     width: 100,
            //     height: 50,
            //     child: Image.asset('assets/cat1.png'),
            //   ),
            // ),
            // Positioned(
            //   bottom: 10,
            //   left: 5,
            //   child: SizedBox(
            //     width: 100,
            //     height: 50,
            //     child: Image.asset('assets/cat2.png'),
            //   ),
            // ),
            Positioned(
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      primary: Constants.primary,
                    ),
                    child: Container(
                      width: Get.width * 0.5,
                      child: Center(
                        child: loading
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : Text(
                                "Sign in",
                                style: GoogleFonts.ptSans(
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "OR",
                    style: GoogleFonts.ptSans(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: GoogleFonts.ptSans(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
