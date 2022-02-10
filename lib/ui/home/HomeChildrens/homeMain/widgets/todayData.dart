import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/controllers/timeController.dart';
import 'package:durkhawpui/model/calendar.dart';
import 'package:durkhawpui/ui/home/HomeChildrens/homeMain/widgets/calendarEdit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TodayData extends StatefulWidget {
  TodayData({Key? key}) : super(key: key);

  @override
  _TodayDataState createState() => _TodayDataState();
}

class _TodayDataState extends State<TodayData> {
  final userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(
      children: [
        Container(
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
                    .collection('home')
                    .doc('calendar')
                    .get(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    DocumentSnapshot snapshot = snap.data as DocumentSnapshot;
                    if (snapshot.exists) {
                      CalendarModel _temp =
                          CalendarModel.fromJson(snapshot.data()!, snapshot.id);
                      if (!_temp.showData) {
                        return SizedBox(
                          height: 5,
                        );
                      }
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
        Positioned(
          right: 5,
          child: (userCtrl.user.value.role == "admin")
              ? IconButton(
                  onPressed: () async {
                    await Get.to(() => CalendarEdit());
                    setState(() {});
                  },
                  icon: Icon(Icons.mode_edit_rounded),
                )
              : Container(),
        ),
      ],
    ));
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
