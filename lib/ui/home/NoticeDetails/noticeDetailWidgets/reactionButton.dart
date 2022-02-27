import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    _postRef.snapshots().listen((DocumentSnapshot event) {
      if (mounted && event.data() != null) {
        Notice _model = Notice.fromJson(event.data()!, event.id);
        setState(() {
          likeCount = _model.likes;
          commentCount = _model.commentCount;
        });
      }
    });
    _likeRef = _postRef.collection('likes').doc(_userCtrl.user.value.userId);
    _likeRef.get().then((DocumentSnapshot event) {
      if (event.exists) {
        setState(() {
          liked = true;
        });
      }
    });
    _likeRef.snapshots().listen((DocumentSnapshot event) {
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

  void onLikeTapped() async {
    if (_userCtrl.user.value.name.toLowerCase() == "guest") {
      _userCtrl.promptLogin();
      return;
    }
    setState(() {
      likeCount = likeCount + 1;
      liked = true;
    });
    _likeRef.set({
      'createdAt': DateTime.now(),
    });
    changeLikeCount(
      increment: true,
      reference: _postRef,
    );
  }

  void onDislikeTapped() async {
    if (_userCtrl.user.value.name.toLowerCase() == "guest") {
      _userCtrl.promptLogin();
      return;
    }
    setState(() {
      likeCount = likeCount - 1;
      liked = false;
    });
    _likeRef.delete();
    changeLikeCount(
      increment: false,
      reference: _postRef,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {
                liked ? onDislikeTapped() : onLikeTapped();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  liked
                      ? Pulse(
                          duration: Duration(milliseconds: 500),
                          child: Icon(
                            MdiIcons.thumbUp,
                            color: Theme.of(context).primaryColor,
                            size: buttonSize,
                          ),
                        )
                      : Swing(
                          duration: Duration(milliseconds: 500),
                          child: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            size: buttonSize,
                          ),
                        ),
                  SizedBox(width: 5),
                  liked
                      ? FadeInUp(
                          from: 20,
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            likeCount == 0 ? "" : likeCount.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        )
                      : FadeInDown(
                          from: 20,
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            likeCount == 0 ? "" : likeCount.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
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
                    color: Theme.of(context).textTheme.bodyText2!.color,
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
                      color: Theme.of(context).textTheme.bodyText2!.color,
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
