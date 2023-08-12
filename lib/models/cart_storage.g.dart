// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartStorage _$CartStorageFromJson(Map json) => CartStorage(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$CartStorageToJson(CartStorage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
