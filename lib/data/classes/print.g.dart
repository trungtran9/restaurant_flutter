// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Print _$PrintFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return Print(
    id: json['id'] as int,
    productName: json['name'] as String,
    qty: json['qty'] as int,
    status: json['status'] as int?,
    printCount: json['print_count'] as int?,
  );
}

Map<String, dynamic> _$PrintToJson(Print instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.productName,
      'status': instance.status,
      'print_count': instance.printCount,
      'qty': instance.qty,
    };
