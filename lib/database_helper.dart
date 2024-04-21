import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather_app.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather (
        id INTEGER PRIMARY KEY,
        location TEXT,
        weatherIcon TEXT,
        temperature INTEGER,
        windSpeed INTEGER,
        humidity INTEGER,
        cloud INTEGER,
        currentDate TEXT
      )
    ''');
  }

  Future<int> insertWeather(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('weather', row);
  }

  Future<Map<String, dynamic>> queryWeather() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('weather', orderBy: 'id DESC', limit: 1);
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }
}
