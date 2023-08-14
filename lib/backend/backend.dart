import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/backend/wishlist_repo.dart';

extension BackendBuildContext on BuildContext {
  Backend get backend => BackendInheritedWidget.of(this, listen: false);

  ProductsRepo get productsRepo => backend.productsRepo;

  WishlistRepo get wishlistRepo => backend.wishlistRepo;

  CartRepo get cartRepo => backend.cartRepo;
}

extension BackendState<T extends StatefulWidget> on State<T> {
  ProductsRepo get productsRepo => context.productsRepo;

  WishlistRepo get wishlistRepo => context.wishlistRepo;

  CartRepo get cartRepo => context.cartRepo;
}

class Backend {
  Backend._(
    this.productsRepo,
    this.wishlistRepo,
    this.cartRepo,
  );

  final ProductsRepo productsRepo;
  final WishlistRepo wishlistRepo;
  final CartRepo cartRepo;

  static Future<Backend> init() async {
    final productsRepo = await ProductsRepo.create();
    final wishlistRepo = await WishlistRepo.create(productsRepo);
    final cartRepo = await CartRepo.create();
    return Backend._(
      productsRepo,
      wishlistRepo,
      cartRepo,
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
