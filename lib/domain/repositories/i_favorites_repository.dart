import 'package:open_emt/data/models/stop_model.dart';

class IFavoritesRepository {
  /// Adds a quote to database
  Future<void> addToFavorites(StopInfo stop) async {}

  /// Deletes a quote from database
  Future<void> deleteFavorite(StopInfo stop) async {}

  /// Deletes all quotes from database and widget list
  Future<void> deleteAllFavorites() async {}

  /// Returns all favorite stops
  Future<List<StopInfo>?> getAllFavorites() async {}

  // bool checkIfFavorite(
  //   List<StopInfo> favorites,
  //   StopInfo stop,
  // ) {
  //   for (var i in favorites) {
  //     if (i.label == stop.label) return true;
  //   }

  //   return false;
  // }
}
