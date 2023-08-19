import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend/product_repo.dart';
import '../backend/wishlist_repo.dart';

final initRepoProvider = FutureProvider.autoDispose((ref) async {
  await ref.read(productsRepoProvider).create();
  await ref.read(wishlistRepoProvider).create();
  // return Future.error('error in init repos');
});
