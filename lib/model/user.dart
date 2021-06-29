class Member {
  Member({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });
  Member.fromJson(Map<String, Object?> json, String documentId)
      : this(
          userId: documentId,
          name: json['name']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          role: json['role']! as String,
        );
  late String userId;
  late String name;
  late String email;
  late String role;
  late String phone;

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "email": email,
      "role": role,
      "phone": phone,
    };
  }
}
