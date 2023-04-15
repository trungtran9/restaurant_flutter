// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return Table(
    id: json['id'] as int,
    tableName: json['table_name'] as String?,
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    status: json['table_status'] as int,
    total: json['total'] as num?,
    areaId: json['area_id'] as int?,
  );
}

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
      'id': instance.id,
      'updated': instance.updated?.toIso8601String(),
      'table_status': instance.status,
      'table_name': instance.tableName,
      'area_id': instance.areaId,
      'total': instance.total,
    };
