import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/widgets/addNotice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'subPages/NoticeDetail.dart';

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
    var result = _fire
        .collection('posts')
        .limit(fetchLimit)
        .orderBy('createdAt', descending: true)
        .snapshots();
    result.listen((event) {
      setState(() {
        noticeList.clear();
      });
      List<QueryDocumentSnapshot> docs = event.docs;
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
    });
  }

  void onLoading() async {
    if (lastDoc != null) {
      try {
        QuerySnapshot result = await _fire
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
        var result = _fire
            .collection('posts')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .snapshots();
        result.listen((event) {
          noticeList.clear();
          List<QueryDocumentSnapshot> docs = event.docs;
          List<Notice> _temp = [];
          docs.forEach((QueryDocumentSnapshot element) {
            Notice temp = Notice.fromJson(element.data(), element.id);
            _temp.add(temp);
          });
          if (docs.isNotEmpty) {
            if (mounted)
              setState(() {
                lastDoc = docs.last;
                noticeList.addAll(_temp);
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
      itemCount: noticeList.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(
            noticeList[index].title,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, fontSize: 16, height: 2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                noticeList[index].excerpt +
                    noticeList[index].excerpt +
                    noticeList[index].excerpt +
                    noticeList[index].excerpt,
                style: GoogleFonts.roboto(fontSize: 14, height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                _formatDate(noticeList[index].createdAt),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          isThreeLine: true,
          onTap: () {
            Get.to(() => NoticeDetails(notice: noticeList[index]));
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
          title: Text('Thuchhuah te'),
          centerTitle: true,
        ),
        floatingActionButton:
            //TODO change role
            (user.role == "admin")
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Get.to(() => AddNewNotice());
                      // Get.to(() => Test());
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
    var _new = DateFormat("h:mm a dd-MMMM-yy").format(date);
    return _new;
  }
}
