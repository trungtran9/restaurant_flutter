import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.displayName,
    required this.id,
    required this.username,
    required this.companyId
  });
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "displayName")
  final String? displayName;

  @JsonKey(name: "username")
  String username;


  @JsonKey(name: "companyId")
  int companyId;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "user(username: $username, companyId: $companyId, id: $id, displayName: $displayName)";
  }
}
