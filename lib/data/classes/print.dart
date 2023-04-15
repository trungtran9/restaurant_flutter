import 'package:json_annotation/json_annotation.dart';
part 'print.g.dart';
@JsonSerializable()
class Print {
  Print({
    required this.id,
    required this.productName,
    required this.qty,
    this.status,
    this.printCount,
  });
  @JsonKey(required: true)
  final int id;
  @JsonKey(name: "name")
  String productName;
  int? status;
  @JsonKey(name: "print_count")
  int? printCount;
  int qty;
  factory Print.fromJson(Map<String, dynamic> json) => _$PrintFromJson(json);

  Map<String, dynamic> toJson() => _$PrintToJson(this);
  @override
  String toString() {
    return "$productName".toString();
  }
}
