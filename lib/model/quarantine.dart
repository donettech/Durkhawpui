import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/creator.dart';

class Quaratine {
  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime quarantineFrom;
  late DateTime quarantineTo;
  late String docId;
  late String name;
  late String veng;
  late String ymaSection;
  late String contactor;
  late GeoPoint location;
  late Creator createdBy;

  Quaratine({
    required this.createdAt,
    required this.updatedAt,
    required this.quarantineFrom,
    required this.quarantineTo,
    required this.docId,
    required this.name,
    required this.veng,
    required this.ymaSection,
    required this.contactor,
    required this.location,
    required this.createdBy,
  });
  Quaratine.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          docId: documentId,
          name: json['name']! as String,
          contactor: json['contactor']! as String,
          location: json['location']! as GeoPoint,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
          quarantineFrom: (json['quarantineFrom']! as Timestamp).toDate(),
          quarantineTo: (json['quarantineTo'] as Timestamp).toDate(),
          ymaSection: json['ymaSection'] as String,
          veng: json['veng'] as String,
          createdBy: Creator.fromJson(
            json['createdBy'],
          ),
        );
  Map<String, Object?> toJson() {
    return {
      "name": name,
      "contactor": contactor,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "quarantineFrom": quarantineFrom,
      "quarantineTo": quarantineTo,
      "ymaSection": ymaSection,
      'veng': veng,
      'createdBy': createdBy.toJson()
    };
  }
}
