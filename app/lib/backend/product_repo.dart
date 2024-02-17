import 'dart:async';
import 'dart:collection';

import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

class ProductsRepo {
  ProductsRepo(this._apiService, this._authRepo);

  final ApiService _apiService;
  final AuthRepo _authRepo;

  late StreamSubscription _authSub;
  var _products = <ProductItem>[];
  var _topSelling = <ProductItem>[];

  List<ProductItem> get products => _products;

  static Future<ProductsRepo> create(ApiService apiService, AuthRepo authRepo) async {
    final repo = ProductsRepo(apiService, authRepo);
    if (authRepo.isLoggedIn) {
      repo._fetchProducts();
    }
    repo.init();
    return repo;
  }

  void init() {
    _authSub = _authRepo.streamIsLoggedIn.listen((bool isLoggedIn) {
      if (isLoggedIn) {
        _fetchProducts();
      }
    });
  }

  void dispose() {
    _authSub.cancel();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await _apiService.getProducts();
      _products = UnmodifiableListView(
        data.map(ProductItem.fromDto),
      );
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
    }
  }

  List<ProductItem> currentTopSelling() => _topSelling;

  Future<List<ProductItem>> fetchTopSelling() async {
    try {
      final data = await _apiService.getTopSellingProducts();
      _topSelling = UnmodifiableListView(
        data.map(ProductItem.fromDto),
      );
      return _topSelling;
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
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
