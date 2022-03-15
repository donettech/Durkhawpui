import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'noticeDetailWidgets/attachment.dart';
import 'noticeDetailWidgets/commentCount.dart';
import 'noticeDetailWidgets/reactionButton.dart';

class NoticeDetailLink extends StatefulWidget {
  final String noticeId;
  NoticeDetailLink({Key? key, required this.noticeId}) : super(key: key);

  @override
  _NoticeDetailLinkState createState() => _NoticeDetailLinkState();
}

class _NoticeDetailLinkState extends State<NoticeDetailLink>
    with SingleTickerProviderStateMixin {
  late Notice notice;
  bool loading = true;
  final _fire = FirebaseFirestore.instance.collection('posts');

  @override
  void initState() {
    super.initState();
    _getNotice();
  }

  void _getNotice() async {
    var snap = await _fire.doc(widget.noticeId).get();
    Notice _model = Notice.fromJson(snap.data()!, snap.id);
    setState(() {
      notice = _model;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              elevation: 0,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notice.ngo + " ",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    "post_title".tr,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              centerTitle: true,
            ),
            body: loading
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notice.title,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          _buildMd(),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            notice.ngo.toUpperCase(),
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            _formatDate(notice.createdAt),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          NoticeAttachmentBuilder(
                            attachmentType: notice.attachmentType,
                            useMap: notice.useMap,
                            location: notice.geoPoint,
                            attachmentLink: notice.attachmentLink,
                            markerName: notice.markerName,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CommentCountText(
                                postId: notice.docId,
                              ),
                            ],
                          ),
                          Divider(),
                          ReactionButtons(staticNotice: notice),
                          Divider(),
                        ],
                      ),
                    ),
                  ));
  }

  Widget _buildMd() {
    return MarkdownBody(
      data: notice.desc,
      selectable: true,
      onTapLink: (tappedLink, aa, sdf) async {
        print("Link tapped1 " + tappedLink);
        try {
          await canLaunch(tappedLink)
              ? await launch(tappedLink)
              : throw 'Could not launch ';
        } catch (e) {
          print(e.toString());
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(
        ThemeData(
          textTheme: TextTheme(
            bodyText2: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textTheme.caption!.color,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    var _new = DateFormat("h:mm a dd-MMM-yy").format(date);
    return _new;
  }
}
