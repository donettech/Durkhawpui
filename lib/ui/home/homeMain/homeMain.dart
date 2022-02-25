import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/ui/home/NoticeDetails/noticeDetailWidgets/commentCount.dart';
import 'package:durkhawpui/ui/home/NoticeDetails/noticeDetailWidgets/reactionButton.dart';
import 'package:durkhawpui/ui/home/homeSettings/settings_page.dart';
import 'package:durkhawpui/utils/dateTimeFormat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../NoticeDetails/NoticeDetail.dart';
import 'package:shimmer/shimmer.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final userCtrl = Get.find<UserController>();
  List<Notice> noticeList = [];
  RefreshController _refreshController = RefreshController();
  final _fire = FirebaseFirestore.instance;
  bool loading = true;

  QueryDocumentSnapshot? lastDoc;

  int fetchLimit = 10;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  void onRefresh() async {
    setState(() {
      noticeList.clear();
      loading = true;
    });
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
        loading = false;
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
    if (loading) {
      return ListView(
        children: List.generate(15, (index) {
          var isDarkMode = Get.isDarkMode;
          if (isDarkMode)
            return Card(
              child: SizedBox(
                  height: 150.0,
                  child: Shimmer.fromColors(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                    ),
                    baseColor: Color(0xff1f1f1f),
                    highlightColor: Color(0xff232323),
                    direction: ShimmerDirection.ttb,
                  )),
            );
          else
            return Card(
              child: SizedBox(
                  height: 150.0,
                  child: Shimmer.fromColors(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                    ),
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[100]!,
                    direction: ShimmerDirection.ttb,
                  )),
            );
        }).toList(),
      );
    }
    //TODO show shimmer when loading
    return ListView.builder(
      itemCount: noticeList.length,
      itemBuilder: (context, index) => Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            noticeList[index].title,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 2,
            ),
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
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Text(
                    formatDate(noticeList[index].createdAt),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  CommentCountText(
                    postId: noticeList[index].docId,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),
              ReactionButtons(staticNotice: noticeList[index]),
              Divider(),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: Center(
            child: GestureDetector(
              onTap: () {
                log('logo clicked');
                onRefresh();
              },
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/ic_launcher_round.png'),
              ),
            ),
          ),
          title: Text(
            'Durkhawpui',
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => SettingsPage());
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) {
            return [];
          },
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
      ),
    );
  }
}
