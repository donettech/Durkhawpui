import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfPage extends StatelessWidget {
  final String pdfLink;
  const PdfPage({Key? key, required this.pdfLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF View"),
        centerTitle: true,
      ),
      body: Container(
        child: PDF(
          swipeHorizontal: false,
          enableSwipe: true,
          nightMode: darkModeOn ? true : false,
          fitEachPage: true,
        ).cachedFromUrl(
          pdfLink,
          placeholder: (progress) => Center(
              child: Text(
            '$progress %',
            style: GoogleFonts.roboto(
              color: Colors.red,
            ),
          )),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
