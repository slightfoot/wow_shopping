import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/features/wishlist/wishlist_repo.dart';

export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/features/wishlist/wishlist_repo.dart';

extension BackendBuildContext on BuildContext {
  Backend get backend => BackendInheritedWidget.of(this, listen: false);

  AuthRepo get authRepo => backend.authRepo;

  ProductsRepo get productsRepo => backend.productsRepo;

  WishlistRepo get wishlistRepo => backend.wishlistRepo;

  CartRepo get cartRepo => backend.cartRepo;
}

extension BackendState<T extends StatefulWidget> on State<T> {
  AuthRepo get authRepo => context.authRepo;

  ProductsRepo get productsRepo => context.productsRepo;

  WishlistRepo get wishlistRepo => context.wishlistRepo;

  CartRepo get cartRepo => context.cartRepo;
}

class Backend {
  Backend._(
    this.authRepo,
    this.productsRepo,
    this.wishlistRepo,
    this.cartRepo,
  );

  final AuthRepo authRepo;
  final ProductsRepo productsRepo;
  final WishlistRepo wishlistRepo;
  final CartRepo cartRepo;

  static Future<Backend> init() async {
    late AuthRepo authRepo;
    final apiService = ApiService(() async => authRepo.token);
    authRepo = await AuthRepo.create(apiService);
    final productsRepo = await ProductsRepo.create();
    final wishlistRepo = await WishlistRepo.create(productsRepo);
    final cartRepo = await CartRepo.create();
    authRepo.retrieveUser();
    return Backend._(
      authRepo,
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
