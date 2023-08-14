part of 'top_selling_bloc.dart';

@immutable
sealed class TopSellingState {}

final class TopSellingInitial extends TopSellingState {}

final class TopSellingLoading extends TopSellingState {}

final class TopSellingLoaded extends TopSellingState {
  TopSellingLoaded(this.products);

  final List<ProductItem> products;
}

final class TopSellingFailure extends TopSellingState {}
