import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/controllers/UserController.dart';
import 'package:durkhawpui/model/calendar.dart';
import 'package:durkhawpui/model/creator.dart';
import 'package:durkhawpui/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarEdit extends StatefulWidget {
  const CalendarEdit({Key? key}) : super(key: key);

  @override
  _CalendarEditState createState() => _CalendarEditState();
}

class _CalendarEditState extends State<CalendarEdit> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));
  TextEditingController _mon = TextEditingController();
  TextEditingController _tue = TextEditingController();
  TextEditingController _wed = TextEditingController();
  TextEditingController _thu = TextEditingController();
  TextEditingController _fri = TextEditingController();
  TextEditingController _sat = TextEditingController();
  TextEditingController _sun = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _fire = FirebaseFirestore.instance;
  final userCtrl = Get.find<UserController>();
  CalendarModel? currentCalendar;

  @override
  void initState() {
    super.initState();
    getCalendar();
  }

  void getCalendar() async {
    var result = await _fire.collection('home').doc('calendar').get();
    if (result.exists) {
      CalendarModel _temp = CalendarModel.fromJson(
        result.data()!,
        result.id,
      );
      setState(() {
        currentCalendar = _temp;
        startDate = _temp.startDate;
        endDate = _temp.endDate;
        _mon.text = _temp.mon;
        _tue.text = _temp.tue;
        _wed.text = _temp.wed;
        _thu.text = _temp.thu;
        _fri.text = _temp.fri;
        _sat.text = _temp.sat;
        _sun.text = _temp.sun;
      });
    }
  }

  void _uploadCalendar() async {
    CalendarModel model = CalendarModel(
      docId: 'item',
      createdAt:
          currentCalendar != null ? currentCalendar!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
      updatedBy: Creator(
        id: userCtrl.user.value.userId,
        name: userCtrl.user.value.name,
      ),
      startDate: startDate,
      endDate: endDate,
      mon: _mon.text,
      tue: _tue.text,
      wed: _wed.text,
      thu: _thu.text,
      fri: _fri.text,
      sat: _sat.text,
      sun: _sun.text,
      showData: true,
    );
    _fire
        .collection('home')
        .doc('calendar')
        .set(model.toJson(), SetOptions(merge: true));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar tihdanglamna"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePickers(),
                Divider(
                  thickness: 1,
                ),
                _buildDays(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            _uploadCalendar();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Constants.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Save"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDays() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A ni mil in mipuite awmdan tur ziak rawh',
          style: GoogleFonts.roboto(
            fontSize: 16,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _mon,
          decoration: new InputDecoration(
            labelText: "Monday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _tue,
          decoration: new InputDecoration(
            labelText: "Tuesday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _wed,
          decoration: new InputDecoration(
            labelText: "Wednesday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _thu,
          decoration: new InputDecoration(
            labelText: "Thursday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _fri,
          decoration: new InputDecoration(
            labelText: "Friday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _sat,
          decoration: new InputDecoration(
            labelText: "Saturday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _sun,
          decoration: new InputDecoration(
            labelText: "Sunday",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(color: Constants.primary),
            ),
          ),
          validator: (val) {
            if (val!.length == 0) {
              return "Dah awl theih anilo";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildDatePickers() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 30),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          startDate = result;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range),
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 30),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          startDate = result;
                        });
                      }
                    },
                    child: Text(
                      _formatDateTime(startDate),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text('atanga'),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 30),
                        ),
                      );
                      if (result != null && result.isAfter(startDate)) {
                        setState(() {
                          endDate = result;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range),
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 30),
                        ),
                      );
                      if (result != null && result.isAfter(startDate)) {
                        setState(() {
                          endDate = result;
                        });
                      }
                    },
                    child: Text(
                      _formatDateTime(endDate),
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MMMM').format(dateTime);
  }
}
