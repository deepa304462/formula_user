
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

import '../models/favorite_model.dart';

class DBHelper{

  static Database? _db ;

  Future<Database?> get db async{
    if(_db != null){
      return _db ;
    }

    _db = await initDatabase();

    return _db;

  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'favorite.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;


  }


  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE favorites (id TEXT PRIMARY KEY, title TEXT NOT NULL, image IMAGE NOT NULL, pdf TEXT NOT NULL, ) "
    );
  }


  Future<FavoriteModel> insert (FavoriteModel favoriteModel) async {
    var dbClient = await db;
    await dbClient!.insert("favorites", favoriteModel.toMap());
    return favoriteModel;
  }


  Future<List<FavoriteModel>> getFavoriteList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('favorites');

    return queryResult.map((e) => FavoriteModel.fromMap(e)).toList();
  }

  Future<bool> isInBookMark(String itemId) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> queryResult = await dbClient!.query(
      'favorites',
      where: "id = ?",
      whereArgs: [itemId], // Pass the itemId as a parameter
    );

    // Check if the query result is not empty
    return queryResult.isNotEmpty;
  }

  Future<void> deleteFromFavorite(String id) async {
    print("bookmark");
    print("bookmark1");
    print(id);

    var dbClient = await db;


    await dbClient!.delete(
      'favorites',

      where: 'id = ?',

      whereArgs: [id],
    );
  }


}