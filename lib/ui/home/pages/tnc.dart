import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditions extends StatelessWidget {
  TermsAndConditions({Key? key}) : super(key: key);
  final _fire = FirebaseFirestore.instance.collection('pages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fire.doc('tnc').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot obj = snapshot.data as DocumentSnapshot;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    obj.data()!['text'],
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
