import 'package:json_annotation/json_annotation.dart';
part 'table.g.dart';
@JsonSerializable()
class Table {
  Table({
    required this.id,
    this.tableName,
    this.updated,
    required this.status,
    this.total,
    this.areaId,
  });
  @JsonKey(required: true)
  @JsonKey(name: "ID")
  final int id;
  final DateTime? updated;
  @JsonKey(name: "table_status")
  final int status;
  @JsonKey(name: "table_name")
  String? tableName;
  @JsonKey(name: "area_id")
  int? areaId;
  final num? total;
  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  Map<String, dynamic> toJson() => _$TableToJson(this);
  @override
  String toString() {
    return "$tableName".toString();
  }
  String getTableStatus() {
    if(status == 1)
      return 'Đang dùng';
    else if(status == 2)
      return 'Bàn đặt';
    return 'Bàn trống';
  } 
}
