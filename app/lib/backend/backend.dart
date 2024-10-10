import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/app.dart';
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/device_type.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/category_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/features/wishlist/wishlist_repo.dart';

export 'package:wow_shopping/app/device_type.dart' hide DeviceOrientation;
export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/features/wishlist/wishlist_repo.dart';

extension BackendBuildContext on BuildContext {
  Backend get backend {
    return ProviderScope.containerOf(this, listen: false) //
        .read(backendProvider)!;
  }

  DeviceTypeOrientationNotifier get deviceType => backend.deviceType;

  AuthRepo get authRepo => backend.authRepo;

  CategoryRepo get categoryRepo => backend.categoryRepo;

  ProductsRepo get productsRepo => backend.productsRepo;

  WishlistRepo get wishlistRepo => backend.wishlistRepo;

  CartRepo get cartRepo => backend.cartRepo;

  String resolveApiUrl(String path) => backend.resolveApiUrl(path);
}

extension BackendState<T extends StatefulWidget> on State<T> {
  AuthRepo get authRepo => context.authRepo;

  DeviceTypeOrientationNotifier get deviceType => context.deviceType;

  CategoryRepo get categoryRepo => context.categoryRepo;

  ProductsRepo get productsRepo => context.productsRepo;

  WishlistRepo get wishlistRepo => context.wishlistRepo;

  CartRepo get cartRepo => context.cartRepo;

  String resolveApiUrl(String path) => context.resolveApiUrl(path);
}

final backendProvider = Provider<Backend?>((ref) => null);

class Backend {
  Backend._(
    this.config,
    this.deviceType,
    this.authRepo,
    this.categoryRepo,
    this.productsRepo,
    this.wishlistRepo,
    this.cartRepo,
  );

  final AppConfig config;
  final DeviceTypeOrientationNotifier deviceType;
  final AuthRepo authRepo;
  final CategoryRepo categoryRepo;
  final ProductsRepo productsRepo;
  final WishlistRepo wishlistRepo;
  final CartRepo cartRepo;

  static Future<Backend> init(
    AppConfig config,
    DeviceTypeOrientationNotifier deviceType,
  ) async {
    late AuthRepo authRepo;
    final apiService = ApiService(
      config.baseApiUrl,
      () async => authRepo.token,
    );
    authRepo = await AuthRepo.create(apiService);
    final categoryRepo = await CategoryRepo.create(apiService, authRepo);
    final productsRepo = await ProductsRepo.create(apiService, authRepo);
    final wishlistRepo = await WishlistRepo.create(productsRepo);
    final cartRepo = await CartRepo.create();
    authRepo.retrieveUser();
    return Backend._(
      config,
      deviceType,
      authRepo,
      categoryRepo,
      productsRepo,
      wishlistRepo,
      cartRepo,
    );
  }

  String resolveApiUrl(String path) {
    return Uri.parse(config.baseApiUrl) //
        .replace(path: path)
        .toString();
  }
}
