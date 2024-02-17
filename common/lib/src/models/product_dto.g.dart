// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      subTitle: json['sub_title'] as String,
      price: json['price'] as String,
      priceWithTax: json['price_with_tax'] as String,
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => ProductOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'title': instance.title,
      'sub_title': instance.subTitle,
      'price': instance.price,
      'price_with_tax': instance.priceWithTax,
      'photos': instance.photos,
      'description': instance.description,
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

ProductOptionDto _$ProductOptionDtoFromJson(Map<String, dynamic> json) =>
    ProductOptionDto(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductOptionDtoToJson(ProductOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
