class Creator {
  late String id;
  late String name;

  Creator({
    required this.id,
    required this.name,
  });
  Creator.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name']! as String,
          id: json['id']! as String,
        );
  Map<String, Object?> toJson() {
    return {"name": name, "id": id};
  }
}
