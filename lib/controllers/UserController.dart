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
          createdAt: DateTime.now())
      .obs;

  void getUserData({required User signedInUser}) async {
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
