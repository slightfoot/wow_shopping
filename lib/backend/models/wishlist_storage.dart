import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_storage.g.dart';

@JsonSerializable()
class WishlistStorage {
  const WishlistStorage({
    required this.items,
  });

  final Set<String> items;

  static const empty = WishlistStorage(items: {});

  WishlistStorage copyWith({
    Iterable<String>? items,
  }) {
    return WishlistStorage(
      items: items != null ? Set.unmodifiable(items) : this.items,
    );
  }

  factory WishlistStorage.fromJson(Map json) => _$WishlistStorageFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistStorageToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
