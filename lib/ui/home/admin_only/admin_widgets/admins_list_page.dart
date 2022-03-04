import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'add_admin.dart';
import 'change_admin_role.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({Key? key}) : super(key: key);

  @override
  _AdminListPageState createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  final userCtrl = Get.find<UserController>();
  List<Member> adminList = [];
  RefreshController _refreshController = RefreshController();
  final _fire = FirebaseFirestore.instance;

  QueryDocumentSnapshot? lastDoc;
  bool loading = false;

  int fetchLimit = 8;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  void onRefresh() async {
    setState(() {
      adminList.clear();
      loading = true;
      lastDoc = null;
    });
    var result = await _fire
        .collection('users')
        .limit(fetchLimit)
        .where('role', isNotEqualTo: "user")
        .withConverter<Member>(
          fromFirestore: (snapshots, _) =>
              Member.fromJson(snapshots.data()!, snapshots.id),
          toFirestore: (movie, _) => movie.toJson(),
        )
        .get();
    List<QueryDocumentSnapshot> docs = result.docs;
    List<Member> _temp = [];
    docs.forEach((QueryDocumentSnapshot element) {
      Member temp = element.data() as Member;
      _temp.add(temp);
    });
    if (docs.isNotEmpty) {
      lastDoc = docs.last;
    }
    setState(() {
      adminList.clear();
      loading = false;
      adminList.addAll(_temp);
    });
    _refreshController.refreshCompleted();
  }

  void onLoading() async {
    if (lastDoc != null) {
      try {
        QuerySnapshot result = await _fire
            .collection('users')
            .limit(fetchLimit)
            .where('role', isNotEqualTo: "user")
            .startAfterDocument(lastDoc!)
            .withConverter<Member>(
              fromFirestore: (snapshots, _) =>
                  Member.fromJson(snapshots.data()!, snapshots.id),
              toFirestore: (movie, _) => movie.toJson(),
            )
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Member> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Member temp = element as Member;
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            loading = false;
            adminList.addAll(_temp);
          });
        }
        _refreshController.loadComplete();
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        var result = await _fire
            .collection('users')
            .limit(fetchLimit)
            .where('role', isNotEqualTo: "user")
            .withConverter<Member>(
              fromFirestore: (snapshots, _) =>
                  Member.fromJson(snapshots.data()!, snapshots.id),
              toFirestore: (movie, _) => movie.toJson(),
            )
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Member> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Member temp = element as Member;
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            adminList.addAll(_temp);
          });
        }
        _refreshController.loadComplete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget _body() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: adminList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          elevation: 4,
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(adminList[index].avatarUrl),
                    fit: BoxFit.cover),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                adminList[index].name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adminList[index].email,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Role: ",
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      adminList[index].role,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            trailing: userCtrl.user.value.role == "super"
                ? IconButton(
                    onPressed: () {
                      Get.dialog(
                        ChangeAdminRoleDialog(
                          member: adminList[index],
                        ),
                        barrierColor: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.5),
                      ).then((value) => value == null ? null : onRefresh());
                    },
                    icon: Icon(
                      Icons.change_circle_outlined,
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Admin List',
          style: Theme.of(context).textTheme.headline6!,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: userCtrl.user.value.role == "super"
          ? ElevatedButton(
              onPressed: () {
                Get.dialog(AddAdmin(
                  onConfirm: (newUser) {
                    if (newUser.role == "admin" || newUser.role == "super") {
                      Get.snackbar("Error", "User is already an admin");
                    } else {
                      _fire
                          .collection('users')
                          .doc(newUser.userId)
                          .update({'role': 'admin'}).then((value) {
                        Get.snackbar("Success", "User is now an admin");
                      });
                    }
                  },
                ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('add_admin'.tr),
                ],
              ),
            )
          : const SizedBox(),
      body: SmartRefresher(
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        child: _body(),
        onRefresh: onRefresh,
        onLoading: onLoading,
      ),
    );
  }
}
