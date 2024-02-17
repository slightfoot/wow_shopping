import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wow_shopping/utils/formatting.dart';

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
    required this.photos,
    required this.description,
    this.options = const [],
  });

  final String id;
  final String category;
  final String title;
  final String subTitle;
  final Decimal price;
  final Decimal priceWithTax;
  final List<String> photos;
  final String description;
  final List<ProductOption> options;

  static final none = ProductItem(
    id: 'invalid',
    category: '',
    title: '',
    subTitle: '',
    price: Decimal.zero,
    priceWithTax: Decimal.zero,
    photos: [],
    description: '',
    options: [],
  );

  String get formattedPrice => formatCurrency(price);

  String get formattedPriceWithTax => formatCurrency(priceWithTax);

  factory ProductItem.fromJson(Map json) => _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}

@JsonSerializable()
class ProductOption {
  const ProductOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static const none = ProductOption(id: '', name: '');

  factory ProductOption.fromJson(Map json) => _$ProductOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
