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
      price: (json['price'] as num).toDouble(),
      priceWithTax: (json['price_with_tax'] as num).toDouble(),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'title': instance.title,
      'sub_title': instance.subTitle,
      'price': instance.price,
      'price_with_tax': instance.priceWithTax,
      'photos': instance.photos,
      'description': instance.description,
    };
