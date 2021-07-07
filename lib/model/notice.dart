import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/creator.dart';

class Notice {
  late DateTime createdAt;
  late DateTime updatedAt;
  late Creator createdBy;
  late String docId;
  late String title;
  late String desc;
  late String excerpt;
  late String? attachmentLink;
  late int attachmentType;
  /* 
  notice attachment types
  0=none
  1=image
  2=pdf
   */
//TODO notice model diklo adjust ngai
  Notice({
    required this.createdAt,
    required this.updatedAt,
    required this.docId,
    required this.title,
    required this.desc,
    required this.excerpt,
    required this.attachmentType,
    required this.attachmentLink,
    required this.createdBy,
  });
  Notice.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          docId: documentId,
          title: json['title']! as String,
          desc: json['desc']! as String,
          excerpt: json['excerpt']! as String,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
          attachmentType: json['attachmentType'] as int,
          attachmentLink: json['attachmentLink'] as String,
          createdBy: Creator.fromJson(json['createdBy']),
        );
  Map<String, Object?> toJson() {
    return {
      "title": title,
      "desc": desc,
      "excerpt": excerpt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "attachmentType": attachmentType,
      'attachmentLink': attachmentLink,
      'createdBy': createdBy.toJson()
    };
  }
}
