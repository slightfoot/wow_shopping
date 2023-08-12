import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/models/product_item.dart';
import 'package:wow_shopping/features/products/models/product_proxy.dart';

class ProductsRepo {
  ProductsRepo(this._products);

  final List<ProductItem> _products;

  // TODO: Cache products

  List<ProductProxy> get cachedItems =>
      List.of(_products.map((e) => ProductProxy(e)));

  static Future<ProductsRepo> create() async {
    try {
      final data = json.decode(
        await rootBundle.loadString(Assets.productsData),
      );
      final products = (data['products'] as List) //
          .cast<Map>()
          .map(ProductItem.fromJson)
          .toList();
      return ProductsRepo(products);
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
  }

  Future<List<ProductProxy>> fetchTopSelling() async {
    //await Future.delayed(const Duration(seconds: 3));
    return List.unmodifiable(_products
        .map((e) => ProductProxy(e))); // TODO: filter to top-selling only
  }

  /// Find product from the top level products cache
  ///
  /// [id] for the product to fetch.
  ProductProxy findProduct(String id) {
    return ProductProxy(_products.firstWhere(
      (product) => product.id == id,
      orElse: () => ProductItem.none,
    ));
  }
}
