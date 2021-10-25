part of 'favorite_stops_bloc.dart';

abstract class FavoriteStopsEvent extends Equatable {
  const FavoriteStopsEvent();
}

class InitializeFavorites extends FavoriteStopsEvent {
  const InitializeFavorites();

  @override
  List<Object?> get props => [];
}

class FavoriteAdded extends FavoriteStopsEvent {
  const FavoriteAdded(this.stop);

  final StopInfo stop;

  @override
  List<Object?> get props => [stop];
}

class FavoriteDeleted extends FavoriteStopsEvent {
  const FavoriteDeleted(this.stop);

  final StopInfo stop;

  @override
  List<Object?> get props => [stop];
}

class FavoritesAllDeleted extends FavoriteStopsEvent {
  const FavoritesAllDeleted();

  @override
  List<Object?> get props => [];
}
