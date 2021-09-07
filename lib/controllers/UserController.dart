import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _fire = FirebaseFirestore.instance.collection('users');
  var user = Member(
    userId: '',
    name: 'Guest',
    email: '',
    phone: '',
    role: 'user',
    avatarUrl: "",
    createdAt: DateTime.now(),
  ).obs;

  Future<void> getUserData({required User signedInUser}) async {
    var data = await _fire.doc(signedInUser.uid).get();
    if (!data.exists) {
      Member tempUser = Member(
        userId: signedInUser.uid,
        name: signedInUser.displayName ?? "Unavailable",
        email: signedInUser.email ?? "Unavailable",
        phone: signedInUser.phoneNumber ?? "Unavailable",
        role: 'user',
        createdAt: DateTime.now(),
        avatarUrl: signedInUser.photoURL ??
            "https://firebasestorage.googleapis.com/v0/b/durkhawpui.appspot.com/o/dp.png?alt=media&token=b3bc695c-2b5e-4e6e-8e01-c62c9c839703",
      );
      _fire.doc(signedInUser.uid).set(tempUser.toJson());
    }
    _fire.doc(signedInUser.uid).snapshots().listen((DocumentSnapshot snap) {
      Member temp = Member.fromJson(snap.data()!, snap.id);
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
}
