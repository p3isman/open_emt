import 'dart:convert';
import 'dart:io';

import 'package:open_emt/data/models/stop_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static Database? _database;
  String _path = '';

  /// Database getter
  Future<Database?> get database async {
    // If database exists return it
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  /// Creates a table for the quotes in case it doesn't exist
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    _path = join(documentsDirectory.path, 'favorites.db');

    // Creates a database
    return await openDatabase(
      _path,

      // If newer version, onCreate will be called
      version: 2,

      onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Favorites(id INTEGER PRIMARY KEY, stop TEXT)');
      },
    );
  }

// INSERTS
  Future<int> addFavorite(StopInfo stopInfo) async {
    final db = await database;
    final res =
        await db!.insert('Favorites', {'stop': jsonEncode(stopInfo.toJson())});

    /// ID of the last inserted row
    return res;
  }

// SELECTS
  Future<List<StopInfo>> getAllFavorites() async {
    final db = await database;

    final res = await db!.query('Favorites', columns: ['stop']);

    return res.isNotEmpty
        ? res
            .map((row) =>
                StopInfo.fromJson(jsonDecode(row.values.first as String)))
            .toList()
        : [];
  }

// DELETES
  Future<int> deleteFavorite(StopInfo stop) async {
    final db = await database;
    final res = await db!
        .delete('Favorites', where: 'stop = ?', whereArgs: [jsonEncode(stop)]);

    return res;
  }

  Future<int> deleteAllFavorites() async {
    final db = await database;
    final res = await db!.delete('Favorites');

    return res;
  }
}
