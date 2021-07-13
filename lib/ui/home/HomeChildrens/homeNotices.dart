import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/addNotice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeNotices extends StatefulWidget {
  const HomeNotices({Key? key}) : super(key: key);

  @override
  _HomeNoticesState createState() => _HomeNoticesState();
}

class _HomeNoticesState extends State<HomeNotices> {
  final userCtrl = Get.find<UserController>();
  List<Notice> noticeList = [];
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
    setState(() {
      noticeList.clear();
    });
    QuerySnapshot result = await _fire
        .collection('posts')
        .limit(fetchLimit)
        .orderBy('createdAt', descending: true)
        .get();
    List<QueryDocumentSnapshot> docs = result.docs;
    List<Notice> _temp = [];
    docs.forEach((QueryDocumentSnapshot element) {
      Notice temp = Notice.fromJson(element.data(), element.id);
      _temp.add(temp);
    });
    if (docs.isNotEmpty) {
      lastDoc = docs.last;
    }
    setState(() {
      noticeList.addAll(_temp);
    });
    _refreshController.refreshCompleted();
  }

  void onLoading() async {
    late QuerySnapshot result;
//TODO notice model diklo adjust ngai
    if (lastDoc != null) {
      try {
        result = await _fire
            .collection('posts')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(lastDoc!)
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Notice> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Notice temp = Notice.fromJson(element.data(), element.id);
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            noticeList.addAll(_temp);
          });
        }
        _refreshController.loadComplete();
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _fire
            .collection('posts')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Notice> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Notice temp = Notice.fromJson(element.data(), element.id);
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            noticeList.addAll(_temp);
          });
        }
        _refreshController.loadComplete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget _body() {
    return ListView.builder(
      itemCount: noticeList.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(
            noticeList[index].title,
          ),
          subtitle: Text(noticeList[index].excerpt),
          trailing: IconButton(
            onPressed: () {
              // Get.to(() => QuarantineDetails(
              //       model: quarantines[index],
              //     ));
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ),
          onTap: () {
            // Get.to(() => QuarantineDetails(
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
        floatingActionButton:
            //TODO change role
            (user.role == "user")
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Get.to(AddNewNotice());
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
