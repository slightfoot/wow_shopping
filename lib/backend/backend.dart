import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/backend/wishlist_repo.dart';

extension BackendBuildContext on BuildContext {
  Backend get backend => BackendInheritedWidget.of(this, listen: false);

  ProductsRepo get productsRepo => backend.productsRepo;

  WishlistRepo get wishlistRepo => backend.wishlistRepo;
}

extension BackendState<T extends StatefulWidget> on State<T> {
  ProductsRepo get productsRepo => context.productsRepo;

  WishlistRepo get wishlistRepo => context.wishlistRepo;
}

typedef ProductsRepoGetter = ProductsRepo Function();

class AuthRepo {
  AuthRepo(this._productsRepoGetter);

  final ProductsRepoGetter _productsRepoGetter;
  late final productsRepo = _productsRepoGetter();

  void blah() {
    productsRepo.cachedItems;
  }
}

class Backend {
  Backend._(
    this.productsRepo,
    this.wishlistRepo,
  );

  final ProductsRepo productsRepo;
  final WishlistRepo wishlistRepo;

  static Future<Backend> init() async {
    late ProductsRepo productsRepo;
    final authRepo = AuthRepo(() => productsRepo);
    productsRepo = await ProductsRepo.create(authRepo);
    final wishlistRepo = await WishlistRepo.create(productsRepo);
    return Backend._(
      productsRepo,
      wishlistRepo,
    );
  }
}

@immutable
class BackendInheritedWidget extends InheritedWidget {
  const BackendInheritedWidget({
    Key? key,
    required this.backend,
    required Widget child,
  }) : super(key: key, child: child);

  final Backend backend;

  static Backend of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<BackendInheritedWidget>()!.backend;
    } else {
      return context.getInheritedWidgetOfExactType<BackendInheritedWidget>()!.backend;
    }
  }

  @override
  bool updateShouldNotify(BackendInheritedWidget oldWidget) {
    return backend != oldWidget.backend;
  }
}
