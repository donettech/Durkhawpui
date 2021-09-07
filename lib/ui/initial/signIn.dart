import 'package:durkhawpui/controllers/notiController.dart';
import 'package:durkhawpui/controllers/secureStorage.dart';
import 'package:durkhawpui/ui/initial/root.dart';
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
      Get.find<SecureController>().skip();
      await Get.put(SecureController()).switchNoti(newValue: true);
      Get.offAll(() => Root());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Error',
        e.message.toString(),
        backgroundColor: Colors.red,
      );
      throw e;
    } catch (error) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Sign-in Error',
        'Sign-in a fuh loa, tih that leh angai',
        backgroundColor: Colors.red,
      );
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                'assets/000.jpg',
              ))),
            ),
            Positioned(
              top: 15,
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
              top: 120,
              child: Text(
                "Durkhawpui",
                style: GoogleFonts.yellowtail(
                  fontSize: 35,
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 15,
              right: 15,
              child: Text(
                "Durtlang information system awlsam zawk a hriat theih na",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      primary: Constants.secondary,
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
                                "Sign in with Google",
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
                    onPressed: () {
                      Get.find<SecureController>().skip().then((value) async {
                        await Get.put(SecureController())
                            .switchNoti(newValue: true);
                        Get.offAll(() => Root());
                      });
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.ptSans(
                        fontSize: 16,
                        color: Colors.white,
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
