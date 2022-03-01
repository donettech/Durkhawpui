import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  double helloWidth = 50;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  final _fire = FirebaseFirestore.instance.collection('users');
  var user = Member(
    userId: 'aa',
    name: 'Guest',
    email: '',
    phone: '',
    role: 'guest',
    avatarUrl: "",
    createdAt: DateTime.now(),
  ).obs;

  Future<void> getUserData({required User signedInUser}) async {
    var data = await _fire.doc(signedInUser.uid).get();
    Member temp = Member.fromJson(data.data()!, data.id);
    user.value = temp;
    _fire
        .doc(signedInUser.uid)
        .withConverter<Member>(
          fromFirestore: (snapshots, _) =>
              Member.fromJson(snapshots.data()!, snapshots.id),
          toFirestore: (movie, _) => movie.toJson(),
        )
        .snapshots()
        .listen((var snap) {
      Member temp = snap.data() as Member;
      user.value = temp;
    }).onError((err) {
      print(err.toString());
    });
  }

  Future<void> updateName(String name) async {
    await _fire.doc(user.value.userId).update({"name": name});
  }

  Future<void> updatePhone(String phone) async {
    await _fire.doc(user.value.userId).update({"phone": phone});
  }

  void promptLogin() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).cardColor,
        title: Text("Login Required"),
        content: Text("Please login to continue"),
        actions: [
          ElevatedButton(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            onPressed: handleSignIn,
          ),
        ],
      ),
    );
  }

  Future<void> handleSignIn() async {
    try {
      Get.back();
      Get.dialog(Center(
        child: CupertinoActivityIndicator(),
      ));
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var userCred = await _auth.signInWithCredential(credential);
      await getUserData(signedInUser: userCred.user!);
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        backgroundColor: Colors.red,
      );
      throw e;
    } catch (error) {
      Get.snackbar(
        'Sign-in Error',
        'Sign-in a fuh loa, tih that leh angai',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user.value = Member(
      userId: 'aa',
      name: 'Guest',
      email: '',
      phone: '',
      role: 'user',
      avatarUrl: "",
      createdAt: DateTime.now(),
    );
  }
}
