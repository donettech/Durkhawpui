import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/quarantine.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/addQuarantine.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/singleQuarantine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeQuarantines extends StatefulWidget {
  const HomeQuarantines({Key? key}) : super(key: key);

  @override
  _HomeQuarantinesState createState() => _HomeQuarantinesState();
}

class _HomeQuarantinesState extends State<HomeQuarantines> {
  final userCtrl = Get.find<UserController>();
  List<Quarantine> quarantines = [];
  RefreshController _refreshController = RefreshController();
  final _fire = FirebaseFirestore.instance;

  QueryDocumentSnapshot? lastDoc;

  int fetchLimit = 10;

  @override
  void initState() {
    super.initState();
    onLoading();
  }

  void onRefresh() async {
    var result = _fire
        .collection('quarantines')
        .limit(fetchLimit)
        .orderBy('createdAt', descending: true)
        .snapshots();
    result.listen((event) {
      quarantines.clear();
      List<QueryDocumentSnapshot> docs = event.docs;
      List<Quarantine> _temp = [];
      docs.forEach((QueryDocumentSnapshot element) {
        Quarantine temp = Quarantine.fromJson(element.data(), element.id);
        _temp.add(temp);
      });
      if (docs.isNotEmpty) {
        lastDoc = docs.last;
      }
      setState(() {
        quarantines.addAll(_temp);
      });
      _refreshController.refreshCompleted();
    });
  }

  void onLoading() async {
    if (lastDoc != null) {
      try {
        QuerySnapshot result = await _fire
            .collection('quarantines')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(lastDoc!)
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Quarantine> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Quarantine temp = Quarantine.fromJson(element.data(), element.id);
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            quarantines.addAll(_temp);
          });
        }
        _refreshController.loadComplete();
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        var result = _fire
            .collection('quarantines')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .snapshots();
        result.listen((event) {
          quarantines.clear();
          List<QueryDocumentSnapshot> docs = event.docs;
          List<Quarantine> _temp = [];
          docs.forEach((QueryDocumentSnapshot element) {
            Quarantine temp = Quarantine.fromJson(element.data(), element.id);
            _temp.add(temp);
          });
          if (docs.isNotEmpty) {
            setState(() {
              lastDoc = docs.last;
              quarantines.addAll(_temp);
            });
          }
          _refreshController.loadComplete();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget _body() {
    return ListView.builder(
      itemCount: quarantines.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(
            quarantines[index].name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 2,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                _formatDate(quarantines[index].quarantineFrom),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              Get.dialog(QuarantineDetailDialog(
                model: quarantines[index],
              ));
              // Get.to(() => QuarantineDetailDialog(
              //       model: quarantines[index],
              //     ));
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ),
          onTap: () {
            Get.dialog(QuarantineDetailDialog(
              model: quarantines[index],
            ));
            // Get.to(() => QuarantineDetailDialog(
            //       model: quarantines[index],
            //     ));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Member user = userCtrl.user.value;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quarantine te'),
          centerTitle: true,
        ),
        floatingActionButton: //change role
            (user.role == "admin")
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

  String _formatDate(DateTime date) {
    var _new = DateFormat("dd-MMMM-yy").format(date);
    return _new;
  }
}
