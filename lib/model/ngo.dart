import 'package:cloud_firestore/cloud_firestore.dart';

class NgoModel {
  NgoModel(
      {required this.docId,
      required this.name,
      required this.desc,
      required this.slug,
      required this.createdAt,
      required this.updatedAt});
  NgoModel.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          docId: documentId,
          name: json['name']! as String,
          desc: json['desc']! as String,
          slug: json['slug']! as String,
          createdAt: (json['createdAt'] as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
        );
  late String docId;
  late String name;
  late String desc;
  late String slug;
  late DateTime createdAt;
  late DateTime updatedAt;

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "desc": desc,
      "slug": slug,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
