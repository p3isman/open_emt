part of 'favorite_stops_bloc.dart';

abstract class FavoriteStopsState extends Equatable {
  const FavoriteStopsState();

  @override
  List<Object> get props => [];
}

class FavoritesLoadInProgress extends FavoriteStopsState {
  const FavoritesLoadInProgress();

  @override
  List<Object> get props => [];
}

class FavoritesLoadSuccess extends FavoriteStopsState {
  const FavoritesLoadSuccess({this.stops = const []});

  final List<StopInfo> stops;

  @override
  List<Object> get props => [stops];
}

class FavoritesLoadFailure extends FavoriteStopsState {
  const FavoritesLoadFailure();

  @override
  List<Object> get props => [];
}
