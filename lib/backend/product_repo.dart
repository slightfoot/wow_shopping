import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/models/product_item.dart';

class ProductsRepo {
  ProductsRepo(this.products);

  late List<ProductItem> products;

  // TODO: Cache products

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

  Future<List<ProductItem>> fetchTopSelling() async {
    //await Future.delayed(const Duration(seconds: 3));
    return products; // TODO: filter to top-selling only
  }
}
