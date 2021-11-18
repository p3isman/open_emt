import 'package:open_emt/data/models/stop_model.dart';

class IFavoritesRepository {
  /// Adds a stop to database
  Future<void> addToFavorites(StopInfo stop) async {}

  /// Updates a stop
  Future<void> updateFavorite(
    StopInfo oldStop,
    StopInfo updatedStop,
  ) async {}

  /// Deletes a stop from database
  Future<void> deleteFavorite(StopInfo stop) async {}

  /// Deletes all stops from database and widget list
  Future<void> deleteAllFavorites() async {}

  /// Returns all favorite stops
  Future<List<StopInfo>?> getAllFavorites() async {}
}
