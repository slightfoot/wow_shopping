import 'package:common/common.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wow_shopping/utils/formatting.dart';

part 'product_item.g.dart';

@JsonSerializable()
class ProductItem extends Equatable {
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

  static ProductItem fromDto(ProductDto dto) {
    return ProductItem(
      id: dto.id,
      category: dto.category,
      title: dto.title,
      subTitle: dto.subTitle,
      price: Decimal.parse(dto.price),
      priceWithTax: Decimal.parse(dto.priceWithTax),
      photos: dto.photos,
      description: dto.description,
      options: dto.options //
          .map(ProductOption.fromDto)
          .toList(),
    );
  }

  static ProductItem fromJson(Map json) => _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';

  @override
  List<Object?> get props {
    return [id, category, title, subTitle, price, priceWithTax, photos, description, options];
  }
}

@JsonSerializable()
class ProductOption extends Equatable {
  const ProductOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static const none = ProductOption(id: '', name: '');

  static ProductOption fromDto(ProductOptionDto dto) {
    return ProductOption(
      id: dto.id,
      name: dto.name,
    );
  }

  static ProductOption fromJson(Map json) => _$ProductOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';

  @override
  List<Object?> get props {
    return [id, name];
  }
}
