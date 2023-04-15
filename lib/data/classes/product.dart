import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';
@JsonSerializable()
class Product {
  Product({
    required this.id,
    required this.productName,
    required this.qty,
    required this.price,
    required this.categoryId,
    this.unit,
    required this.image,
    this.note,
  });
  @JsonKey(required: true)
  final int id;
  @JsonKey(name: "name")
  String productName;
  num price;
  @JsonKey(name: "category_id")
  int categoryId;
  int qty;
  final String? unit;
  @JsonKey(nullable: true)
  String image;
  String? note;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
  @override
  String toString() {
    return "$productName : $note-- $categoryId".toString();
  }
}
