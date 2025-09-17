import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:common/common.dart';
import 'package:server/api/exception.dart';
import 'package:server/server/assets.dart';
import 'package:server/utils/json.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ProductsApi {
  ProductsApi() {
    _init();
  }

  var _products = <ProductDto>[];

  late final _router =
      Router() //
        ..post('/all', _postProducts)
        ..post('/product/<id>', _postProduct)
        ..post('/top-selling', _postTopSelling)
        ..post('/featured-categories', _postFeaturedCategories);

  Future<void> _init() async {
    try {
      final data = json.decode(
        await File(Assets.productsData).readAsString(),
      );
      _products =
          (data['products'] as List) //
              .cast<Map<String, dynamic>>()
              .map(ProductDto.fromJson)
              .toList();
    } catch (error, stackTrace) {
      print('$error\n$stackTrace');
      rethrow;
    }
  }

  Future<Response> call(Request request) async => await _router(request);

  Future<Response> _postProduct(Request request) async {
    final id = request.params['id'];
    print('fetching product $id');

    final product = _products.firstWhereOrNull(
      (product) => product.id == id,
    );
    if (product == null) {
      throw ApiException.notFound('Product $id not found');
    }
    return jsonResponse(product);
  }

  Future<Response> _postProducts(Request request) async {
    return jsonResponse({'products': _products});
  }

  Future<Response> _postTopSelling(Request request) async {
    return jsonResponse({'products': _products});
  }

  Future<Response> _postFeaturedCategories(Request request) async {
    final data = json.decode(
      await File(Assets.featuredCategoriesData).readAsString(),
    );
    return jsonResponse(data);
  }
}
