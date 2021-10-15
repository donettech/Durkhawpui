import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:flutter/material.dart';

class CommentCountText extends StatelessWidget {
  final String postId;
  CommentCountText({Key? key, required this.postId}) : super(key: key);

  final _fire = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _fire.doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot snap = snapshot.data as DocumentSnapshot;
          Notice _notice = Notice.fromJson(snap.data()!, snap.id);
          if (_notice.commentCount < 1) return Container();
          return Row(
            children: [
              Spacer(),
              Text(_notice.commentCount.toString() + " Comments"),
            ],
          );
        }
        return Container();
      },
    );
  }
}
