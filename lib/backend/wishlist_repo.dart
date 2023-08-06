import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/wishlist_storage.dart';

class WishlistRepo {
  WishlistRepo._(this._productsRepo, this._file, this._wishlist);

  final ProductsRepo _productsRepo;
  final File _file;
  WishlistStorage _wishlist;
  late StreamController<List<ProductItem>> _wishlistController;
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
    _wishlistController = StreamController<List<ProductItem>>.broadcast(
      onListen: () => _emitWishlist(),
    );
  }

  void _emitWishlist() {
    _wishlistController.add(currentWishlistItems);
  }

  List<ProductItem> get currentWishlistItems =>
      _wishlist.items.map(_productsRepo.findProduct).toList();

  Stream<List<ProductItem>> get streamWishlistItems => _wishlistController.stream;

  bool isInWishlist(ProductItem item) {
    return _wishlist.items.contains(item.id);
  }

  Stream<bool> streamIsInWishlist(ProductItem item) async* {
    bool last = isInWishlist(item);
    yield last;
    await for (final list in streamWishlistItems) {
      final current = list.any((product) => product.id == item.id);
      if (current != last) {
        yield current;
        last = current;
      }
    }
  }

  void addToWishlist(String productId) {
    if (_wishlist.items.contains(productId)) {
      return;
    }
    _wishlist = _wishlist.copyWith(
      items: {..._wishlist.items, productId},
    );
    _emitWishlist();
    _saveWishlist();
  }

  void removeToWishlist(String productId) {
    _wishlist = _wishlist.copyWith(
      items: _wishlist.items.where((el) => el != productId),
    );
    _emitWishlist();
    _saveWishlist();
  }

  void _saveWishlist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_wishlist.toJson()));
    });
  }
}
