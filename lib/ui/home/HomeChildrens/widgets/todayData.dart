import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/timeController.dart';
import 'package:durkhawpui/model/calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TodayData extends StatelessWidget {
  const TodayData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<TimeController>(
              id: 'aVeryUniqueID',
              init: TimeController(),
              builder: (value) => Text(
                '${value.timeString.value}: ',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('calendar')
                  .doc('item')
                  .get(),
              builder: (context, snap) {
                if (snap.hasData) {
                  DocumentSnapshot snapshot = snap.data as DocumentSnapshot;
                  if (snapshot.exists) {
                    CalendarModel _temp =
                        CalendarModel.fromJson(snapshot.data()!, snapshot.id);
                    return Text(
                      _textForDay(_temp),
                      style: GoogleFonts.ebGaramond(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                  return Text(
                    '',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  );
                }
                return Text(
                  '',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _textForDay(CalendarModel calendar) {
    String shortDay = _shortDay();
    switch (shortDay) {
      case 'Mon':
        {
          return calendar.mon;
        }
      case 'Tue':
        {
          return calendar.tue;
        }
      case 'Wed':
        {
          return calendar.wed;
        }
      case 'Thu':
        {
          return calendar.thu;
        }
      case 'Fri':
        {
          return calendar.fri;
        }
      case 'Sat':
        {
          return calendar.sat;
        }
      case 'Sun':
        {
          return calendar.sun;
        }
      default:
        {
          return "N/A";
        }
    }
  }

  String _shortDay() {
    var _new = DateFormat("EEE").format(DateTime.now());
    return _new;
  }
}
