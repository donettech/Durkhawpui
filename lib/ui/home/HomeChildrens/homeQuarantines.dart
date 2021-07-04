import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/quarantine.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/addQuarantine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeQuarantines extends StatefulWidget {
  const HomeQuarantines({Key? key}) : super(key: key);

  @override
  _HomeQuarantinesState createState() => _HomeQuarantinesState();
}

class _HomeQuarantinesState extends State<HomeQuarantines> {
  final userCtrl = Get.find<UserController>();
  List<Quaratine> quarantines = [];
  RefreshController _refreshController = RefreshController();
  final _fire = FirebaseFirestore.instance;

  int fetchLimit = 15;

  @override
  void initState() {
    super.initState();
    // onLoading();
  }

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000));
    _refreshController.refreshCompleted();
  }

  void onLoading() async {
    QuerySnapshot result = await _fire
        .collection('quarantines')
        .limit(fetchLimit)
        .orderBy('createdAt', descending: true)
        .where(
          'quarantineFrom',
          isLessThan: DateTime.now(),
        )
        .where('quarantineTo', isGreaterThan: DateTime.now())
        .get();
    List<QueryDocumentSnapshot> docs = result.docs;
    docs.forEach((QueryDocumentSnapshot element) {
      Quaratine temp = Quaratine.fromJson(element.data(), element.id);
      print(temp.toString());
    });
    setState(() {});
    _refreshController.loadComplete();
  }

  Widget _body() {
    return ListView.builder(
      itemCount: quarantines.length,
      itemExtent: 100.0,
      itemBuilder: (c, i) => Card(
        child: Text(quarantines[i].toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Member user = userCtrl.user.value;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: //change role
            (user.role == "user")
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      // Get.dialog(widget);
                      Get.to(AddQuarantineDialog());
                    },
                  )
                : Container(),
        body: SmartRefresher(
          header: WaterDropHeader(),
          footer: ClassicFooter(),
          controller: _refreshController,
          enablePullUp: true,
          child: _body(),
          onRefresh: onRefresh,
          onLoading: onLoading,
        ),
      ),
    );
  }
}
