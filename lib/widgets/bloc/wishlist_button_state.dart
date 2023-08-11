part of 'wishlist_button_bloc.dart';

@immutable
final class WishlistButtonState {
  final bool isWishlisted;

  const WishlistButtonState({required this.isWishlisted});

  WishlistButtonState copyWith(bool? isWishListed) {
    return WishlistButtonState(isWishlisted: isWishlisted ?? this.isWishlisted);
  }
}
