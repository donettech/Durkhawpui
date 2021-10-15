import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReactionButtons extends StatefulWidget {
  final Notice staticNotice;
  ReactionButtons({Key? key, required this.staticNotice}) : super(key: key);

  @override
  _ReactionButtonsState createState() => _ReactionButtonsState();
}

class _ReactionButtonsState extends State<ReactionButtons> {
  final _userCtrl = Get.find<UserController>();
  final double buttonSize = 20;
  final _fire = FirebaseFirestore.instance;
  late DocumentReference _ref;
  int likeCount = 0;
  bool liked = false;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.staticNotice.likes;
    commentCount = widget.staticNotice.commentCount;
    _ref = _fire
        .collection('posts')
        .doc(widget.staticNotice.docId)
        .collection('likes')
        .doc(_userCtrl.user.value.userId);
    _ref.get().then((DocumentSnapshot event) {
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
    if (isLiked) {
      _ref.delete();
      return false;
    } else {
      _ref.set({
        'createdAt': DateTime.now(),
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: LikeButton(
              size: buttonSize,
              circleColor: CircleColor(start: Colors.black, end: Colors.white),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Constants.likeColor,
                dotSecondaryColor: Constants.likeColor,
              ),
              likeBuilder: (bool isLiked) {
                if (isLiked)
                  return Icon(
                    MdiIcons.thumbUp,
                    color: Constants.likeColor,
                    size: buttonSize,
                  );
                return Icon(
                  MdiIcons.thumbUpOutline,
                  color: Colors.white,
                  size: buttonSize,
                );
              },
              likeCount: likeCount,
              onTap: onLikeButtonTapped,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.commentTextOutline,
                    size: buttonSize,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Comments"),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.shareOutline,
                    size: buttonSize,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Share"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
