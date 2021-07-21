import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NoticeDetails extends StatefulWidget {
  final Notice notice;
  NoticeDetails({Key? key, required this.notice}) : super(key: key);

  @override
  _NoticeDetailsState createState() => _NoticeDetailsState();
}

class _NoticeDetailsState extends State<NoticeDetails> {
  String description = '';
  final _fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.notice.title,
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.notice.desc = description;
            _fire
                .collection('posts')
                .doc(widget.notice.docId)
                .update(widget.notice.toJson());
          },
          child: SizedBox(
            width: 35,
            height: 35,
            child: Image.asset(
              'assets/clap.png',
              color: Constants.primary,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    _buildAttachment(),
                    if (widget.notice.attachmentType != 0) SizedBox(height: 15),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(data: widget.notice.desc),
                            SizedBox(
                              height: 10,
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
                          ],
                        )),
                    SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, elevation: 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.notice.claps.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  'assets/clap.png',
                                  color: Constants.primary,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildAttachment() {
    /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */
    switch (widget.notice.attachmentType) {
      case 0:
        {
          return Container();
        }
      case 1:
        {
          return InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.notice.attachmentLink!,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      strokeWidth: 0.8,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        }
      case 2:
        {
          return IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.picture_as_pdf,
              color: Colors.orange,
              size: 50,
            ),
          );
        }
      default:
        {
          return Text(widget.notice.attachmentLink.toString());
        }
    }
  }

  String _formatDate(DateTime date) {
    var _new = DateFormat("h:mm a dd-MMMM-yy").format(date);
    return _new;
  }
}