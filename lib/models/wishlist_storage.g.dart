// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistStorage _$WishlistStorageFromJson(Map json) => WishlistStorage(
      items: (json['items'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$WishlistStorageToJson(WishlistStorage instance) =>
    <String, dynamic>{
      'items': instance.items.toList(),
    };
