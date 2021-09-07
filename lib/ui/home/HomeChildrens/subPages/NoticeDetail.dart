import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/ui/commonWidgets/markerMap.dart';
import 'package:durkhawpui/ui/commonWidgets/pdfPage.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetails extends StatefulWidget {
  final Notice notice;
  NoticeDetails({Key? key, required this.notice}) : super(key: key);

  @override
  _NoticeDetailsState createState() => _NoticeDetailsState();
}

class _NoticeDetailsState extends State<NoticeDetails>
    with SingleTickerProviderStateMixin {
  final _fire = FirebaseFirestore.instance.collection('posts');
  String description = '';
  double position = 50;
  double size = 40;
  bool loading = true;
  int amount = 1;

  @override
  void initState() {
    super.initState();
  }

  void incrementClap() async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference postRef = _fire.doc(widget.notice.docId);
      DocumentSnapshot snapshot = await transaction.get(postRef);
      int clapCount = snapshot.data()!['claps'];
      transaction.update(postRef, {"claps": clapCount + 1});
    });
  }

  void clap() {
    if (mounted) {
      incrementClap();
      setState(() {
        position = 100;
        size = 70;
        loading = !loading;
        amount++;
      });
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        setState(() {
          position = 50;
          size = 40;
          loading = !loading;
        });
      });
    }
  }

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: clap,
          child: SizedBox(
            width: 35,
            height: 35,
            child: Image.asset(
              'assets/clap.png',
              color: Constants.primary,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
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
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: widget.notice.desc,
                                selectable: true,
                                onTapLink: (tappedLink, aa, sdf) async {
                                  print("Link tapped1 " + tappedLink);
                                  try {
                                    await canLaunch(tappedLink)
                                        ? await launch(tappedLink)
                                        : throw 'Could not launch ';
                                    // launch(tappedLink);
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
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (widget.notice.attachmentType != 0)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Attachment: ",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 15),
                                      child: _buildAttachment(),
                                    ),
                                  ],
                                ),
                              if (widget.notice.useMap)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Map Location: ",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 15),
                                      child: _buildMap(),
                                    ),
                                  ],
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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Constants.fabColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                StreamBuilder<Object>(
                                    stream: _fire
                                        .doc(widget.notice.docId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        DocumentSnapshot snap =
                                            snapshot.data as DocumentSnapshot;
                                        print(snap);
                                        Notice model = Notice.fromJson(
                                            snap.data()!, snap.id);
                                        return Text(
                                          model.claps.toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                          ),
                                        );
                                      }
                                      return Text(
                                        widget.notice.claps.toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      );
                                    }),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/clap.png',
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                            onPressed: clap,
                          ),
                          Spacer(),
                          ElevatedButton.icon(
                            onPressed: () async {
                              //TODO create dynamic link
                              print(widget.notice.dynamicLink.toString());
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              await Share.share(
                                  'https://msrmarket.page.link/tV2GBkydxtLFMxh17',
                                  subject: widget.notice.title,
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Constants.fabColor),
                            ),
                            icon: Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Share",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
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
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: position,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: loading
                      ? Container(key: UniqueKey())
                      : AnimatedContainer(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          duration: Duration(milliseconds: 300),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "+" + amount.toString(),
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset(
                                    'assets/clap.png',
                                    color: Constants.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),
        ));
  }

  Widget _buildMap() {
    return Container(
      child: MarkerMap(
        height: 250,
        point: widget.notice.geoPoint!,
      ),
    );
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
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 0.8,
              ),
            ),
            width: double.infinity,
            child: InteractiveViewer(
              panEnabled: false,
              boundaryMargin: EdgeInsets.all(0),
              minScale: 0.5,
              maxScale: 4,
              scaleEnabled: true,
              child: CachedNetworkImage(
                imageUrl: widget.notice.attachmentLink!,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        strokeWidth: 0.8,
                      ),
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
            onPressed: () {
              print(widget.notice.attachmentLink);
              Get.to(
                PdfPage(
                  pdfLink: widget.notice.attachmentLink!,
                ),
              );
            },
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
    var _new = DateFormat("h:mm a dd-MMM-yy").format(date);
    return _new;
  }
}
