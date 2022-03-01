import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  late Timestamp createdAt;
  LikeModel({required this.createdAt});
  LikeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
  }

  toJson() {
    return {
      'createdAt': createdAt,
    };
  }
}
