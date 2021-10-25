import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/domain/repositories/favorites_repository.dart';

part 'favorite_stops_event.dart';
part 'favorite_stops_state.dart';

class FavoriteStopsBloc extends Bloc<FavoriteStopsEvent, FavoriteStopsState> {
  final FavoritesRepository favoritesRepository;

  FavoriteStopsBloc({required this.favoritesRepository})
      : super(const FavoritesLoadInProgress()) {
    on<InitializeFavorites>(_onInitializeFavorites);
    on<FavoriteAdded>(_onFavoriteAdded);
    on<FavoriteDeleted>(_onFavoriteDeleted);
    on<FavoritesAllDeleted>(_onFavoritesAllDeleted);
  }

  void _onInitializeFavorites(
      InitializeFavorites event, Emitter<FavoriteStopsState> emit) async {
    emit(const FavoritesLoadInProgress());
    final List<StopInfo> stops = await favoritesRepository.getAllFavorites();
    emit(FavoritesLoadSuccess(stops: stops));
  }

  void _onFavoriteAdded(
      FavoriteAdded event, Emitter<FavoriteStopsState> emit) async {
    await favoritesRepository.addToFavorites(event.stop);
    final List<StopInfo> stops = [
      ...(state as FavoritesLoadSuccess).stops,
      event.stop,
    ];
    emit(FavoritesLoadSuccess(
      stops: stops,
    ));
  }

  void _onFavoriteDeleted(
      FavoriteDeleted event, Emitter<FavoriteStopsState> emit) async {
    await favoritesRepository.deleteFavorite(event.stop);
    emit(FavoritesLoadSuccess(
      stops: (state as FavoritesLoadSuccess)
          .stops
          .where((stop) => stop.label != event.stop.label)
          .toList(),
    ));
  }

  void _onFavoritesAllDeleted(
      FavoritesAllDeleted event, Emitter<FavoriteStopsState> emit) async {
    await favoritesRepository.deleteAllFavorites();
    emit(const FavoritesLoadSuccess(
      stops: [],
    ));
  }
}
