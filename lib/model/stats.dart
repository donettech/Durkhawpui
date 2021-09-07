import 'package:cloud_firestore/cloud_firestore.dart';
import 'creator.dart';

class CovStats {
  CovStats({
    required this.active,
    required this.total,
    required this.deceased,
    required this.updatedAt,
    required this.updatedBy,
    required this.createdAt,
  });
  CovStats.fromJson(Map<String, dynamic> json)
      : this(
          active: json['active'],
          total: json['total']! as int,
          deceased: json['deceased']! as int,
          updatedBy: Creator.fromJson(json['updatedBy']),
          createdAt: (json['createdAt'] as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
        );
  late int active;
  late int total;
  late int deceased;
  late DateTime createdAt;
  late DateTime updatedAt;
  late Creator updatedBy;

  Map<String, Object?> toJson() {
    return {
      "total": total,
      "active": active,
      "deceased": deceased,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      "updatedBy": updatedBy.toJson(),
    };
  }
}
