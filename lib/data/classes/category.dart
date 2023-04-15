import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';
@JsonSerializable()
class Category {
  Category({
    required this.id,
    required this.name,
  });
  @JsonKey(name: "ID")
  final int id;
  @JsonKey(name: "prd_group_name")
  String name;
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
  @override
  String toString() {
    return "$name".toString();
  }
}
