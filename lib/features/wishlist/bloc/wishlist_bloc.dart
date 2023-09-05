import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wow_shopping/models/product_item.dart';

import '../../../backend/wishlist_repo.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';



class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required WishlistRepo wishlistRepo})
      : _wishlistRepo = wishlistRepo,
        super(WishlistLoading()) {
    on<LoadWishlistItems>(_onLoadWishlistItems);
    on<AddWishlistItems>(_onAddWishlistItems);
    on<DeleteWishlistItems>(_onDeleteWishlistItems);
    on<UpdateWishlistItems>(_onUpdateWishlistItems);
    on<SelectAllWishlistItems>(_onSelectAllWishlistItems);
  }

  final WishlistRepo _wishlistRepo;

  void _onLoadWishlistItems(LoadWishlistItems event,
      Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
  }
    void _onAddWishlistItems(AddWishlistItems event,
        Emitter<WishlistState> emit) async {

    }
  void _onSelectAllWishlistItems(AddWishlistItems event,
      Emitter<WishlistState> emit) {}

  void _onDeleteWishlistItems(DeleteWishlistItems event,
      Emitter<WishlistState> emit) {}

  void _onUpdateWishlistItems(UpdateWishlistItems event,
      Emitter<WishlistState> emit) {}

