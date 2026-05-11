import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class DbService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE favorites (
  id $idType,
  nama $textType,
  deskripsi_singkat $textType,
  waktu_masak $textType,
  bahan_utama $textType,
  bahan_lengkap $textType,
  langkah_langkah $textType
)
''');
  }

  static Future<void> addFavorite(Recipe recipe) async {
    final db = await database;
    await db.insert('favorites', recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeFavorite(String nama) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'nama = ?',
      whereArgs: [nama],
    );
  }

  static Future<bool> isFavorite(String nama) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'nama = ?',
      whereArgs: [nama],
    );
    return maps.isNotEmpty;
  }

  static Future<List<Recipe>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    
    return maps.map((json) => Recipe.fromMap(json)).toList();
  }
}
