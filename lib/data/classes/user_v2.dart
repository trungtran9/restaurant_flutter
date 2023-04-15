class UserV2 {
  int id;
  String? name;
  String? email;

  UserV2({
    required this.id,
    this.name,
    this.email,
  });

  factory UserV2.fromJson(Map<String, dynamic> json) {
    return UserV2(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}