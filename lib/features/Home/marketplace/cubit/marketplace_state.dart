part of 'marketplace_cubit.dart';

@immutable
sealed class MarketplaceState {}

final class MarketplaceInitial extends MarketplaceState {}

final class MarketplaceLoading extends MarketplaceState {}

final class MarketplaceLoaded extends MarketplaceState {
  final List<ProductModel> products;
  MarketplaceLoaded({required this.products});
}

final class MarketplaceError extends MarketplaceState {
  final String message;
  MarketplaceError({required this.message});
}
