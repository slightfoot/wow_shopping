part of 'wishlist_bloc.dart';

//@immutable
abstract class WishlistState extends Equatable{
  const WishlistState();
}
class WishlistLoading extends WishlistState {
  @override
  List<Object> get props => [];
}

class WishlistLoaded extends WishlistState {
  final List<ProductItem> wishlistItems;
  const WishlistLoaded({required this.wishlistItems});

  @override
  List<Object> get props => [wishlistItems];
}

