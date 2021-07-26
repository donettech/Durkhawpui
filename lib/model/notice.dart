import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/creator.dart';

class Notice {
  late DateTime createdAt;
  late DateTime updatedAt;
  late Creator createdBy;
  late String docId;
  late String title;
  late String ngo;
  late String desc;
  late String excerpt;
  late int claps;
  late int viewCount;
  late String? attachmentLink;
  late int attachmentType;
  late bool useMap;
  late GeoPoint? geoPoint;
  /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */
  Notice({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.docId,
    required this.title,
    required this.ngo,
    required this.desc,
    required this.excerpt,
    required this.claps,
    required this.viewCount,
    required this.attachmentType,
    required this.useMap,
    required this.geoPoint,
    required this.attachmentLink,
  });
  Notice.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
          createdBy: Creator.fromJson(json['createdBy']),
          docId: documentId,
          title: json['title']! as String,
          ngo: json['ngo']! as String,
          desc: json['desc']! as String,
          excerpt: json['excerpt']! as String,
          claps: json['claps'] as int,
          viewCount: json['viewCount'] as int,
          attachmentType: json['attachmentType'] as int,
          useMap: json['useMap'],
          geoPoint: json['geoPoint'],
          attachmentLink: json['attachmentLink'],
        );
  Map<String, Object?> toJson() {
    return {
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      'createdBy': createdBy.toJson(),
      "title": title,
      "ngo": ngo,
      "desc": desc,
      "excerpt": excerpt,
      "claps": claps,
      "viewCount": viewCount,
      "attachmentType": attachmentType,
      'attachmentLink': attachmentLink,
      'useMap': useMap,
      'geoPoint': geoPoint,
    };
  }
}
