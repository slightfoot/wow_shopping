part of 'top_selling_bloc.dart';

@immutable
sealed class TopSellingEvent {}

final class TopSellingFetchRequested extends TopSellingEvent {}

final class TopSellingProductsSubscribed extends TopSellingEvent {}
