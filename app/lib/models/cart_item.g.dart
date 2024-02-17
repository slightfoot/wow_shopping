// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map json) => CartItem(
      product: ProductItem.fromJson(json['product'] as Map),
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      deliveryFee: Decimal.fromJson(json['delivery_fee'] as String),
      option: ProductOption.fromJson(json['option'] as Map),
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'product': instance.product.toJson(),
      'delivery_date': instance.deliveryDate.toIso8601String(),
      'delivery_fee': instance.deliveryFee.toJson(),
      'option': instance.option.toJson(),
      'quantity': instance.quantity,
    };
