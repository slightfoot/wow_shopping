import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/cart_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

/// FIXME: Very similar to the [WishlistRepo] and should be refactored out and simplified
class CartRepo {
  CartRepo._(this._file, this._storage);

  final File _file;
  CartStorage _storage;
  late StreamController<List<CartItem>> _cartController;
  Timer? _saveTimer;

  static Future<CartRepo> create() async {
    CartStorage storage;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'cart.json'));
      if (await file.exists()) {
        storage = CartStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        storage = CartStorage.empty;
      }
      return CartRepo._(file, storage)..init();
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  void init() {
    _cartController = StreamController<List<CartItem>>.broadcast(
      onListen: () => _emitCart(),
    );
  }

  void _emitCart() {
    _cartController.add(currentCartItems);
  }

  List<CartItem> get currentCartItems => _storage.items;

  Stream<List<CartItem>> get streamCartItems => _cartController.stream;

  CartItem cartItemForProduct(ProductItem item) {
    return _storage.items //
        .firstWhere((el) => el.product.id == item.id, orElse: () => CartItem.none);
  }

  bool cartContainsProduct(ProductItem item) {
    return cartItemForProduct(item) != CartItem.none;
  }

  void addToCart(ProductItem item, {ProductOption option = ProductOption.none}) {
    if (cartContainsProduct(item)) {
      // FIXME: increase quantity
      return;
    }
    _storage = _storage.copyWith(
      items: {
        ..._storage.items,
        CartItem(
          product: item,
          option: option,
          deliveryFee: Decimal.zero, // FIXME: where from?
          deliveryDate: DateTime.now(), // FIXME: where from?
          quantity: 1,
        ),
      },
    );
    _emitCart();
    _saveCart();
  }

  void removeToCart(String productId) {
    _storage = _storage.copyWith(
      items: _storage.items.where((el) => el.product.id != productId),
    );
    _emitCart();
    _saveCart();
  }

  void _saveCart() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_storage.toJson()));
    });
  }
}
