import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_item.g.dart';

@JsonSerializable()
class ProductItem {
  const ProductItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.priceWithTax,
    required this.photo,
  });

  final String id;
  final String category;
  final String title;
  final String subTitle;
  final double price;
  final double priceWithTax;
  final String photo;

  static const none = ProductItem(
    id: 'invalid',
    category: '',
    title: '',
    subTitle: '',
    price: 0.0,
    priceWithTax: 0.0,
    photo: '',
  );

  factory ProductItem.fromJson(Map json) => _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
