import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfPreview extends StatelessWidget {
  final String link;
  PdfPreview({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            margin: EdgeInsets.only(top: 10),
            child: PDF().cachedFromUrl(
              link,
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    getFileNameFromLink(link),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.download_sharp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFileNameFromLink(String link) {
    var _name = link.split('/').last;
    var _first = _name.split('?').first;
    return _first;
  }
}
