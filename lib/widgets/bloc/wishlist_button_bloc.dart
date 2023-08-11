import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_button_event.dart';
part 'wishlist_button_state.dart';

class WishlistButtonBloc
    extends Bloc<WishlistButtonEvent, WishlistButtonState> {
  WishlistButtonBloc(
      {required WishlistRepo wishlistRepo, required ProductItem item})
      : _wishlistRepo = wishlistRepo,
        _item = item,
        super(WishlistButtonState(
            isWishlisted: wishlistRepo.isInWishlist(item))) {
    on<WishlistStarted>(_onWishlistStarted);
    on<IsTogglePressed>(_onTogglePressed);
  }

  final WishlistRepo _wishlistRepo;
  final ProductItem _item;

  Future<void> _onWishlistStarted(
      WishlistStarted event, Emitter<WishlistButtonState> emit) async {
    await emit.onEach(_wishlistRepo.streamIsInWishlist(_item),
        onData: (wishListed) =>
            add(IsTogglePressed(isItemWishlisted: wishListed)));
  }

  Future<void> _onTogglePressed(
      IsTogglePressed event, Emitter<WishlistButtonState> emit) async {
    if (event.isItemWishlisted) {
      _wishlistRepo.addToWishlist(_item.id);
    } else {
      _wishlistRepo.removeToWishlist(_item.id);
    }
    emit(state.copyWith(event.isItemWishlisted));
  }
}
