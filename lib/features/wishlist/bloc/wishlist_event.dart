part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlistItems extends WishlistEvent {
  final List<ProductItem> wishlistItems;
  const LoadWishlistItems({this.wishlistItems = const <ProductItem>[]});
  @override
  List<Object> get props => [];
}

class AddWishlistItems extends WishlistEvent {
  final ProductItem wishlistItem;
  const AddWishlistItems({required this.wishlistItem});
  @override
  List<Object> get props => [wishlistItem];
}
class SelectAllWishlistItems extends WishlistEvent {
  final List<ProductItem> wishlistItems;
  const SelectAllWishlistItems({this.wishlistItems = const <ProductItem>[]});
  @override
  List<Object> get props => [];
}
class UpdateWishlistItems extends WishlistEvent {
  final ProductItem wishlistItem;
  const UpdateWishlistItems({required this.wishlistItem});
  @override
  List<Object> get props => [wishlistItem];
}

class DeleteWishlistItems extends WishlistEvent {
  final ProductItem wishlistItem;
  const DeleteWishlistItems({required this.wishlistItem});
  @override
  List<Object> get props => [wishlistItem];
}
