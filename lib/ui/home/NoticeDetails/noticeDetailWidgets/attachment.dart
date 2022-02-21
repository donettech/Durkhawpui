import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/ui/commonWidgets/markerMap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pdfPreview.dart';

class NoticeAttachmentBuilder extends StatelessWidget {
  final int attachmentType;
  final String? attachmentLink;
  final bool useMap;
  final GeoPoint? location;
  final String? markerName;
  NoticeAttachmentBuilder(
      {Key? key,
      required this.attachmentType,
      required this.useMap,
      this.markerName,
      this.location,
      this.attachmentLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        if (useMap)
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
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: Container(
                  child: MarkerMap(
                    height: 250,
                    point: location!,
                    address: markerName ?? "",
                  ),
                ),
              ),
            ],
          ),
        if (attachmentType != 0)
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
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: _getPdfImage(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _getPdfImage() {
    /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */
    switch (attachmentType) {
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
                imageUrl: attachmentLink!,
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
          return PdfPreview(
            link: attachmentLink!,
          );
        }
      default:
        {
          return Container();
        }
    }
  }
}
