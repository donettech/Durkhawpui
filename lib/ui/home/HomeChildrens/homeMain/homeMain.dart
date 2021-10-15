import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../NoticeDetails/NoticeDetail.dart';
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
        if (mounted) {
          setState(() {
            _noticeList.addAll(_temp);
          });
        }
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      title: Text(
                        _noticeList[index].title,
                        style: GoogleFonts.poppins(fontSize: 16, height: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _noticeList[index].excerpt,
                        style: GoogleFonts.poppins(fontSize: 13, height: 1.9),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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
