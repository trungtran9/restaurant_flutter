import 'package:json_annotation/json_annotation.dart';
part 'select_print.g.dart';
@JsonSerializable()
class SelectPrint {
  SelectPrint({
    required this.id,
    required this.printName,
    required this.ip,
    required this.port,
  });

  @JsonKey(name: "ID")
  final String id;
  @JsonKey(name: "printer_name")
  String printName;
  String port;
  String ip;
  factory SelectPrint.fromJson(Map<String, dynamic> json) => _$SelectPrintFromJson(json);

  Map<String, dynamic> toJson() => _$SelectPrintToJson(this);
  @override
  String toString() {
    return "$printName".toString();
  }
}
