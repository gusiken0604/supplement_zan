import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/supplement.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'supplements.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE supplements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertSupplement(Supplement supplement) async {
    final db = await database;
    return await db.insert('supplements', supplement.toMap());
  }

  Future<List<Supplement>> getAllSupplements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('supplements');
    return List.generate(maps.length, (i) => Supplement.fromMap(maps[i]));
  }
}