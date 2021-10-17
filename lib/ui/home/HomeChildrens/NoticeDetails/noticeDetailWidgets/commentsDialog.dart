import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/comment.dart';
import 'package:durkhawpui/utils/dateTimeFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'addComment.dart';

class CommentsDialog extends StatefulWidget {
  final String postId;
  const CommentsDialog({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsDialogState createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  final userCtrl = Get.find<UserController>();
  List<Comment> commentList = [];
  RefreshController _refreshController = RefreshController();
  final _fire = FirebaseFirestore.instance;

  QueryDocumentSnapshot? lastDoc;

  int fetchLimit = 8;

  @override
  void initState() {
    super.initState();
    onLoading();
  }

  void onRefresh() async {
    var result = _fire
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .limit(fetchLimit)
        .orderBy('createdAt', descending: true)
        .snapshots();
    result.listen((event) {
      commentList.clear();
      List<QueryDocumentSnapshot> docs = event.docs;
      List<Comment> _temp = [];
      docs.forEach((QueryDocumentSnapshot element) {
        Comment temp = Comment.fromJson(element.data(), element.id);
        _temp.add(temp);
      });
      if (docs.isNotEmpty) {
        lastDoc = docs.last;
      }
      setState(() {
        commentList.addAll(_temp);
      });
      _refreshController.refreshCompleted();
    });
  }

  void onLoading() async {
    if (lastDoc != null) {
      try {
        QuerySnapshot result = await _fire
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(lastDoc!)
            .get();
        List<QueryDocumentSnapshot> docs = result.docs;
        List<Comment> _temp = [];
        docs.forEach((QueryDocumentSnapshot element) {
          Comment temp = Comment.fromJson(element.data(), element.id);
          _temp.add(temp);
        });
        if (docs.isNotEmpty) {
          setState(() {
            lastDoc = docs.last;
            commentList.addAll(_temp);
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
            .doc(widget.postId)
            .collection('comments')
            .limit(fetchLimit)
            .orderBy('createdAt', descending: true)
            .snapshots();
        result.listen((event) {
          commentList.clear();
          List<QueryDocumentSnapshot> docs = event.docs;
          List<Comment> _temp = [];
          docs.forEach((QueryDocumentSnapshot element) {
            Comment temp = Comment.fromJson(element.data(), element.id);
            _temp.add(temp);
          });
          if (docs.isNotEmpty) {
            setState(() {
              lastDoc = docs.last;
              commentList.addAll(_temp);
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
      itemCount: commentList.length,
      itemBuilder: (context, index) => Card(
        color: Colors.black12.withOpacity(0.0001),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            child: Center(
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(commentList[index].userAvatar),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              commentList[index].userName,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commentList[index].text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                timeAgo(commentList[index].createdAt),
                style: GoogleFonts.roboto(
                  fontSize: 11,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              height: 40,
              child: Center(
                child: Text(
                  "Comments",
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: SmartRefresher(
                header: WaterDropHeader(),
                footer: ClassicFooter(),
                controller: _refreshController,
                enablePullUp: true,
                enablePullDown: true,
                child: _body(),
                onRefresh: onRefresh,
                onLoading: onLoading,
              ),
            ),
            AddCommentUI(
              postId: widget.postId,
              onSend: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
