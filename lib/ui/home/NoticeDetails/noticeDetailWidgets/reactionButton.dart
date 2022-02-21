import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:durkhawpui/utils/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';

import 'commentsDialog.dart';

class ReactionButtons extends StatefulWidget {
  final Notice staticNotice;
  ReactionButtons({Key? key, required this.staticNotice}) : super(key: key);

  @override
  _ReactionButtonsState createState() => _ReactionButtonsState();
}

class _ReactionButtonsState extends State<ReactionButtons> {
  final _userCtrl = Get.find<UserController>();
  final double buttonSize = 18;
  final _fire = FirebaseFirestore.instance;
  late DocumentReference _likeRef;
  late DocumentReference _postRef;
  int likeCount = 0;
  bool liked = false;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.staticNotice.likes;
    commentCount = widget.staticNotice.commentCount;
    _postRef = _fire.collection('posts').doc(widget.staticNotice.docId);
    _likeRef = _postRef.collection('likes').doc(_userCtrl.user.value.userId);
    _likeRef.get().then((DocumentSnapshot event) {
      if (event.exists) {
        if (mounted)
          setState(() {
            liked = true;
          });
      } else {
        if (mounted)
          setState(() {
            liked = false;
          });
      }
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    log('likeTapped to ' + isLiked.toString());
    if (_userCtrl.user.value.name.toLowerCase() == "guest") {
      _userCtrl.promptLogin();
      return false;
    }
    if (isLiked) {
      _likeRef.delete();
      changeLikeCount(
        increment: false,
        reference: _postRef,
      );
      return false;
    } else {
      _likeRef.set({
        'createdAt': DateTime.now(),
      });
      changeLikeCount(
        increment: true,
        reference: _postRef,
      );
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onLikeButtonTapped(!liked);
              },
              child: LikeButton(
                size: buttonSize,
                circleColor:
                    CircleColor(start: Colors.black, end: Colors.white),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Constants.likeColor,
                  dotSecondaryColor: Constants.likeColor,
                ),
                likeBuilder: (bool isLiked) {
                  if (isLiked)
                    return Icon(
                      MdiIcons.thumbUp,
                      color: Theme.of(context).colorScheme.secondary,
                      size: buttonSize,
                    );
                  return Icon(
                    MdiIcons.thumbUpOutline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: buttonSize,
                  );
                },
                isLiked: liked,
                likeCount: likeCount,
                onTap: onLikeButtonTapped,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  CommentsDialog(
                    postId: widget.staticNotice.docId,
                  ),
                  isScrollControlled: true,
                  enableDrag: true,
                  ignoreSafeArea: false,
                  backgroundColor: Colors.transparent,
                );
              },
              child: MaterialButton(
                onPressed: () {
                  Get.bottomSheet(
                    CommentsDialog(
                      postId: widget.staticNotice.docId,
                    ),
                    isScrollControlled: true,
                    enableDrag: true,
                    ignoreSafeArea: false,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.commentTextOutline,
                      size: buttonSize,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Comment",
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final RenderBox box = context.findRenderObject() as RenderBox;
                //TODO put default link is no dynamic link available
                Share.share(
                    widget.staticNotice.dynamicLink ??
                        "https://youtu.be/qrMwxe2ya5E",
                    subject: widget.staticNotice.title,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
              child: MaterialButton(
                onPressed: () {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  //TODO put default link is no dynamic link available
                  Share.share(
                      widget.staticNotice.dynamicLink ??
                          "https://youtu.be/qrMwxe2ya5E",
                      subject: widget.staticNotice.title,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.shareOutline,
                      size: buttonSize + 5,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Share",
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
