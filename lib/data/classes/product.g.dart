// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return Product(
    id: json['id'] as int,
    productName: json['name'] as String,
    qty: json['qty'] as int,
    price: json['price'] as num,
    categoryId: json['category_id'] as int,
    unit: json['unit'] as String?,
    image: json['image'] as String,
    note: json['note'] as String?,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.productName,
      'price': instance.price,
      'category_id': instance.categoryId,
      'qty': instance.qty,
      'unit': instance.unit,
      'image': instance.image,
      'note': instance.note,
    };
