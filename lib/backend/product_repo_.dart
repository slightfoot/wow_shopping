import 'package:wow_shopping/features/products/models/product_proxy.dart';

abstract class ProductsRepo {
  // TODO: Cache products

  List<ProductProxy> get cachedItems;

  Future<List<ProductProxy>> fetchTopSelling();

  /// Find product from the top level products cache
  ///
  /// [id] for the product to fetch.
  ProductProxy findProduct(String id);
}
