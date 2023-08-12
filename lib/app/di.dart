import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/product_repo_.dart';
import 'package:wow_shopping/backend/product_repo_mock.dart';
import 'package:wow_shopping/backend/wishlist_repo_.dart';
import 'package:wow_shopping/backend/wishlist_repo_mock.dart';

void setupDi() {
  di.registerSingletonAsync<ProductsRepo>(() => ProductsRepoMock().init());
  di.registerSingletonAsync<WishlistRepo>(() => WishlistRepoMock().init(),
      dependsOn: [ProductsRepo]);
}
