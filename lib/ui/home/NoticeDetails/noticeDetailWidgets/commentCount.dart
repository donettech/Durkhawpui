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
      stream: _fire
          .doc(postId)
          .withConverter<Notice>(
            fromFirestore: (snapshots, _) =>
                Notice.fromJson(snapshots.data()!, snapshots.id),
            toFirestore: (movie, _) => movie.toJson(),
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot snap = snapshot.data as DocumentSnapshot;
          Notice _notice = snap.data() as Notice;
          if (_notice.commentCount < 1) return Container();
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _notice.commentCount.toString() + " Comments",
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
