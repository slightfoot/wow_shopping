import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/features/wishlist/wishlist_storage.dart';
import 'package:rxdart/rxdart.dart';

class WishlistRepo {
  WishlistRepo._(this._productsRepo, this._file, this._wishlist);

  final ProductsRepo _productsRepo;
  final File _file;
  WishlistStorage _wishlist;
  final _wishlistSubject = BehaviorSubject<WishlistState>.seeded(
    const WishlistStateNone(),
  );
  Timer? _saveTimer;

  static Future<WishlistRepo> create(ProductsRepo productsRepo) async {
    WishlistStorage wishlist;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'wishlist.json'));
      if (await file.exists()) {
        wishlist = WishlistStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        wishlist = WishlistStorage.empty;
      }
      return WishlistRepo._(productsRepo, file, wishlist)..init();
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  void init() {
    _wishlistSubject.add(_mapWishlistProducts(_wishlist.items));
  }

  WishlistState get currentState => _wishlistSubject.value;

  Stream<WishlistState> get streamState => _wishlistSubject.stream;

  WishlistStateActive _mapWishlistProducts(Iterable<String> productIds) {
    return WishlistStateActive(
      items: productIds.map(_productsRepo.findProduct).toList(),
    );
  }

  bool isInWishlist(ProductItem item) {
    return _wishlist.items.contains(item.id);
  }

  Stream<bool> streamIsInWishlist(ProductItem item) {
    return streamState //
        .whereType<WishlistStateActive>()
        .map((WishlistStateActive state) {
      return state.items.any((product) => product.id == item.id);
    });
  }

  void addToWishlist(String productId) {
    if (_wishlist.items.contains(productId)) {
      return;
    }
    updateWishlist({..._wishlist.items, productId});
  }

  void removeToWishlist(String productId) {
    updateWishlist(_wishlist.items.where((el) => el != productId));
  }

  void updateWishlist(Iterable<String> productIds) {
    _wishlist = _wishlist.copyWith(items: productIds);
    _wishlistSubject.add(_mapWishlistProducts(productIds));
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_wishlist.toJson()));
    });
  }
}

sealed class WishlistState {
  const WishlistState();
}

final class WishlistStateNone extends WishlistState {
  const WishlistStateNone();
}

final class WishlistStateActive extends WishlistState {
  const WishlistStateActive({required this.items});

  final List<ProductItem> items;
}
