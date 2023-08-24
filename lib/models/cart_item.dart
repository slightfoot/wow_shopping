import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  const CartItem({
    required this.product,
    required this.deliveryDate,
    required this.deliveryFee,
    required this.option,
    required this.quantity,
  });

  final ProductItem product;
  final DateTime deliveryDate;
  final Decimal deliveryFee;
  final ProductOption option;
  final int quantity;

  static final none = CartItem(
    product: ProductItem.none,
    deliveryDate: DateTime.now(),
    deliveryFee: Decimal.zero,
    option: ProductOption.none,
    quantity: 0,
  );

  Decimal get total => product.price * Decimal.fromInt(quantity);

  CartItem copyWith({
    ProductItem? product,
    DateTime? deliveryDate,
    Decimal? deliveryFee,
    ProductOption? option,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      option: option ?? this.option,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromJson(Map json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
