import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  Member({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.avatarUrl,
  });
  Member.fromJson(Map<String, dynamic> json, String documentId)
      : this(
          userId: documentId,
          name: json['name']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          role: json['role']! as String,
          avatarUrl: json['avatarUrl']! as String,
          createdAt: (json['createdAt'] as Timestamp).toDate(),
        );
  late String userId;
  late String name;
  late String email;
  late String role;
  late String phone;
  late String avatarUrl;
  late DateTime createdAt;

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "email": email,
      "role": role,
      "phone": phone,
      "createdAt": createdAt,
      "avatarUrl": avatarUrl,
    };
  }
}
