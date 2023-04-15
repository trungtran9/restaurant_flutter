import 'package:json_annotation/json_annotation.dart';
part 'area.g.dart';
@JsonSerializable()
class Area {
  Area({
    required this.id,
    required this.name,
  });
  final int id;
  @JsonKey(name: "name")
  String name;
  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
  @override
  String toString() {
    return "$name".toString();
  }
}
