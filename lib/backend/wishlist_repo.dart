import 'dart:async';
import 'package:wow_shopping/models/product_item.dart';

class WishlistRepo {
  WishlistRepo(this._wishlist);

  late Set<String> _wishlist;
  late StreamController<Set<String>> _wishlistController;

  static Future<WishlistRepo> create() async {
    try {
      // FIXME: load current wishlist from disk?
      return WishlistRepo(Set.unmodifiable({}))..init();
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
  }

  void init() {
    _wishlistController = StreamController<Set<String>>.broadcast(
      onListen: () {
        _wishlistController.add(_wishlist);
      },
    );
  }

  Set<String> get currentWishlistItems => _wishlist;

  Stream<Set<String>> get streamWishlistItems => _wishlistController.stream;

  bool isInWishlist(ProductItem item) {
    return _wishlist.contains(item.id);
  }

  Stream<bool> streamIsInWishlist(ProductItem item) async* {
    bool last = isInWishlist(item);
    yield last;
    await for (final list in streamWishlistItems) {
      final current = list.contains(item.id);
      if (current != last) {
        yield current;
        last = current;
      }
    }
  }

  Future<void> addToWishlist(ProductItem item) async {
    if (!_wishlist.contains(item.id)) {
      _wishlist = Set.unmodifiable({..._wishlist, item.id});
      _wishlistController.add(_wishlist);
    }
  }

  Future<void> removeToWishlist(ProductItem item) async {
    _wishlist = Set.unmodifiable(_wishlist.where((el) => el != item.id));
    _wishlistController.add(_wishlist);
  }
}
