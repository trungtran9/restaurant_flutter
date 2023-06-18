// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_print.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectPrint _$SelectPrintFromJson(Map<String, dynamic> json) => SelectPrint(
      id: json['ID'] as String,
      printName: json['printer_name'] as String,
      ip: json['ip'] as String,
      port: json['port'] as String,
    );

Map<String, dynamic> _$SelectPrintToJson(SelectPrint instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'printer_name': instance.printName,
      'port': instance.port,
      'ip': instance.ip,
    };
