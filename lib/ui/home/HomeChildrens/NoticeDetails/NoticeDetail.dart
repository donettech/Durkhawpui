import 'package:durkhawpui/model/notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'noticeDetailWidgets/attachment.dart';
import 'noticeDetailWidgets/commentCount.dart';
import 'noticeDetailWidgets/reactionButton.dart';

class NoticeDetails extends StatefulWidget {
  final Notice notice;
  NoticeDetails({Key? key, required this.notice}) : super(key: key);

  @override
  _NoticeDetailsState createState() => _NoticeDetailsState();
}

class _NoticeDetailsState extends State<NoticeDetails>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: "noticeTxt",
            transitionOnUserGestures: true,
            child: Text(
              widget.notice.title,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.notice.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _buildMd(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.notice.ngo.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  _formatDate(widget.notice.createdAt),
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                NoticeAttachmentBuilder(
                  attachmentType: widget.notice.attachmentType,
                  useMap: widget.notice.useMap,
                  location: widget.notice.geoPoint,
                  attachmentLink: widget.notice.attachmentLink,
                ),
                SizedBox(
                  height: 5,
                ),
                CommentCountText(
                  postId: widget.notice.docId,
                ),
                Divider(),
                ReactionButtons(staticNotice: widget.notice),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildMd() {
    return MarkdownBody(
      data: widget.notice.desc,
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
              fontSize: 18.0,
              color: Colors.white,
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
