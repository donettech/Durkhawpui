import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'subPages/NoticeDetail.dart';
import 'subPages/calendarEdit.dart';
import 'widgets/dinhmun.dart';
import 'widgets/todayData.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final _fire = FirebaseFirestore.instance;
  List<Notice> _noticeList = [];

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  void _getPosts() {
    var result = _fire
        .collection('posts')
        .limit(10)
        .orderBy('createdAt', descending: true)
        .snapshots();
    result.listen((event) {
      _noticeList.clear();
      List<QueryDocumentSnapshot> docs = event.docs;
      List<Notice> _temp = [];
      docs.forEach((QueryDocumentSnapshot element) {
        Notice temp = Notice.fromJson(element.data(), element.id);
        _temp.add(temp);
      });
      if (docs.isNotEmpty) {
        setState(() {
          _noticeList.addAll(_temp);
          _noticeList.addAll(_temp);
          _noticeList.addAll(_temp);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TodayData(),
              DinhmunCard(),
              ListView.builder(
                itemCount: _noticeList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_noticeList[index].title),
                      subtitle: Text(_noticeList[index].excerpt),
                      onTap: () {
                        Get.to(() => NoticeDetails(notice: _noticeList[index]));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
