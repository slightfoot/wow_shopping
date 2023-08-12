import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/product_repo_.dart';
import 'package:wow_shopping/backend/product_repo_mock.dart';
import 'package:wow_shopping/backend/wishlist_repo_.dart';
import 'package:wow_shopping/backend/wishlist_repo_mock.dart';
import 'package:wow_shopping/shared/command_error_filters.dart';

void setup() {
  di.registerSingleton(InteractionManager());
  di.registerSingletonAsync<ProductsRepo>(() => ProductsRepoMock().init());
  di.registerSingletonAsync<WishlistRepo>(() => WishlistRepoMock().init(),
      dependsOn: [ProductsRepo]);

  Command.globalExceptionHandler = (error, stackTrace) {
    di<InteractionManager>().showMessage(error.toString());
  };
}
