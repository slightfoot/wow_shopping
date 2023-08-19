import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/models/product_item.dart';

final productsRepoProvider = Provider<ProductsRepo>((ref) {
  return ProductsRepo();
});

class ProductsRepo {
  ProductsRepo();

  late final List<ProductItem> _products;

  // TODO: Cache products

  List<ProductItem> get cachedItems => List.of(_products);

  Future<void> create() async {
    try {
      final data = json.decode(
        await rootBundle.loadString(Assets.productsData),
      );
      final products = (data['products'] as List) //
          .cast<Map>()
          .map(ProductItem.fromJson)
          .toList();
      _products = products;
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
  }

  Future<List<ProductItem>> fetchTopSelling() async {
    await Future.delayed(const Duration(seconds: 3));
    return List.unmodifiable(_products); // TODO: filter to top-selling only
  }

  /// Find product from the top level products cache
  ///
  /// [id] for the product to fetch.
  ProductItem findProduct(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
      orElse: () => ProductItem.none,
    );
  }
}
