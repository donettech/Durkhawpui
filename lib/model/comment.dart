import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment(
      {required this.docId,
      required this.text,
      required this.userName,
      required this.userAvatar,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});
  Comment.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          docId: documentId,
          text: json['text']! as String,
          userId: json['userId']! as String,
          userName: json['userName']! as String,
          userAvatar: json['userAvatar']! as String,
          createdAt: (json['createdAt'] as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] != null)
              ? (json['updatedAt'] as Timestamp).toDate()
              : null,
        );
  late String docId;
  late String text;
  late String userId;
  late String userName;
  late String userAvatar;
  late DateTime createdAt;
  DateTime? updatedAt;

  Map<String, Object?> toJson() {
    return {
      "text": text,
      "userId": userId,
      "userName": userName,
      'userAvatar': userAvatar,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
