// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map json) => ProductItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      subTitle: json['sub_title'] as String,
      price: Decimal.fromJson(json['price'] as String),
      priceWithTax: Decimal.fromJson(json['price_with_tax'] as String),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => ProductOption.fromJson(e as Map))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'title': instance.title,
      'sub_title': instance.subTitle,
      'price': instance.price.toJson(),
      'price_with_tax': instance.priceWithTax.toJson(),
      'photos': instance.photos,
      'description': instance.description,
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

ProductOption _$ProductOptionFromJson(Map json) => ProductOption(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
