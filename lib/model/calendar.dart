import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/creator.dart';

class CalendarModel {
  late String docId;
  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime startDate;
  late DateTime endDate;
  late Creator updatedBy;
  late bool showData;
  late String mon;
  late String tue;
  late String wed;
  late String thu;
  late String fri;
  late String sat;
  late String sun;
  CalendarModel({
    required this.docId,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.startDate,
    required this.endDate,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
    required this.showData,
  });
  CalendarModel.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          docId: documentId,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
          startDate: (json['startDate'] as Timestamp).toDate(),
          endDate: (json['endDate'] as Timestamp).toDate(),
          updatedBy: Creator.fromJson(json['updatedBy']),
          mon: json['mon']! as String,
          tue: json['tue']! as String,
          wed: json['wed']! as String,
          thu: json['thu'] as String,
          fri: json['fri'] as String,
          sat: json['sat'] as String,
          sun: json['sun'],
          showData: json['showData'] as bool,
        );
  Map<String, Object?> toJson() {
    return {
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "startDate": startDate,
      "endDate": endDate,
      'updatedBy': updatedBy.toJson(),
      "mon": mon,
      "tue": tue,
      "wed": wed,
      "thu": thu,
      "fri": fri,
      "sat": sat,
      'sun': sun,
      "showData": showData,
    };
  }
}
