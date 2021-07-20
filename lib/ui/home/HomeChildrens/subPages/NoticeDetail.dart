import 'package:cached_network_image/cached_network_image.dart';
import 'package:durkhawpui/model/notice.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NoticeDetails extends StatelessWidget {
  final Notice notice;
  NoticeDetails({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            notice.title,
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {},
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notice.desc,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    notice.ngo.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    _formatDate(
                      notice.createdAt,
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildAttachment(),
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
                              notice.claps.toString(),
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
    switch (notice.attachmentType) {
      case 0:
        {
          return Container();
        }
      case 1:
        {
          return InkWell(
            onTap: () {},
            child: Container(
              width: 70,
              height: 70,
              child: Icon(
                Icons.image,
                size: 70,
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
          return Text(notice.attachmentLink.toString());
        }
    }
  }

  String _formatDate(DateTime date) {
    var _new = DateFormat("h:mm a dd-MMMM-yy").format(date);
    return _new;
  }
}
