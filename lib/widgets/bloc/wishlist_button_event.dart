part of 'wishlist_button_bloc.dart';

@immutable
sealed class WishlistButtonEvent {}

final class IsTogglePressed extends WishlistButtonEvent {
  final bool isItemWishlisted;

  IsTogglePressed({required this.isItemWishlisted});
}

final class WishlistStarted extends WishlistButtonEvent {}
