import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/models/product_item.dart';

class ProductsRepo {
  ProductsRepo(this._products);

  final List<ProductItem> _products;

  // TODO: Cache products

  List<ProductItem> get cachedItems => List.of(_products);

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

  List<ProductItem> currentTopSelling() {
    return UnmodifiableListView(_products);
  }

  Future<List<ProductItem>> fetchTopSelling() async {
    //await Future.delayed(const Duration(seconds: 3));
    return UnmodifiableListView(_products); // TODO: filter to top-selling only
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
