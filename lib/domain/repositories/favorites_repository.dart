import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/data/services/db_service.dart';

class FavoritesRepository {
  final DBService dbService;

  const FavoritesRepository({required this.dbService});

  /// Adds a quote to database
  Future<void> addToFavorites(StopInfo stop) async {
    await dbService.addFavorite(stop);
  }

  /// Deletes a quote from database
  Future<void> deleteFavorite(StopInfo stop) async {
    await dbService.deleteFavorite(stop);
  }

  /// Deletes all quotes from database and widget list
  Future<void> deleteAllFavorites() async {
    await dbService.deleteAllFavorites();
  }

  Future<List<StopInfo>> getAllFavorites() async {
    return await dbService.getAllFavorites();
  }

  bool checkIfFavorite(
    List<StopInfo> favorites,
    StopInfo stop,
  ) {
    for (var i in favorites) {
      if (i.label == stop.label) return true;
    }

    return false;
  }
}
