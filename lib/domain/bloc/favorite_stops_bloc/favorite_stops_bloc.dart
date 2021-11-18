import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/data/repositories/favorites_repository.dart';

part 'favorite_stops_event.dart';
part 'favorite_stops_state.dart';

class FavoriteStopsBloc extends Bloc<FavoriteStopsEvent, FavoriteStopsState> {
  final FavoritesRepository favoritesRepository;

  FavoriteStopsBloc({required this.favoritesRepository})
      : super(const FavoritesLoadInProgress()) {
    on<InitializeFavorites>(_onInitializeFavorites);
    on<FavoriteAdded>(_onFavoriteAdded);
    on<FavoriteUpdated>(_onFavoriteUpdated);
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

  void _onFavoriteUpdated(
      FavoriteUpdated event, Emitter<FavoriteStopsState> emit) async {
    // Update database
    final StopInfo updatedStop =
        event.stop.copyWith(direction: event.values['Direction']);
    await favoritesRepository.updateFavorite(event.stop, updatedStop);
    // Update state
    final int index = (state as FavoritesLoadSuccess).stops.indexOf(event.stop);
    final List<StopInfo> newStops = [...(state as FavoritesLoadSuccess).stops];
    newStops.removeAt(index);
    newStops.insert(index, updatedStop);
    emit(FavoritesLoadSuccess(stops: newStops));
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
