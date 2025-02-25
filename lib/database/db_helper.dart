import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supplement_zan/models/supplement.dart';

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
          CREATE TABLE supplements(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            dailyConsumption INTEGER
          )
        ''');
      },
    );
  }
  Future<int> insertSupplement(Supplement supplement) async {
  final db = await database;

  // 🔹 `INSERT` 後に `ID` を取得
  int insertedId = await db.insert(
    'supplements',
    {
      'name': supplement.name,
      'quantity': supplement.quantity,
      'dailyConsumption': supplement.dailyConsumption,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print("✅ サプリメントがデータベースに追加されました: ${supplement.name} (ID: $insertedId)");
  return insertedId; // ✅ `ID` を返す
}
// Future<int> insertSupplement(Supplement supplement) async {
//   final db = await database;

//   // 🔹 データを追加し、生成された `ID` を取得
//   int insertedId = await db.insert(
//     'supplements',
//     supplement.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );

//   print("✅ サプリメントがデータベースに追加されました: ${supplement.name} (ID: $insertedId)");
//   return insertedId; // 🔹 追加された `ID` を返す
// }
 
Future<int> updateSupplement(Supplement supplement) async {
  final db = await database;

  // 更新前にデバッグログを出力
  print("🔄 更新前のサプリメント情報: ${supplement.name} (ID: ${supplement.id})");

  int result = await db.update(
    'supplements',
    supplement.toMap(),
    where: 'id = ?',
    whereArgs: [supplement.id], // ✅ `id` を適切に指定
  );

  print("✅ サプリメントをデータベースで更新: ${supplement.name} (ID: ${supplement.id}, 結果: $result)");
  return result;
}

// Future<int> updateSupplement(Supplement supplement) async {
//   final db = await database;
//   int result = await db.update(
//     'supplements',
//     supplement.toMap(),
//     where: 'id = ?',
//     whereArgs: [supplement.id],
//   );

//   print("✅ サプリメントをデータベースで更新: ${supplement.name} (ID: ${supplement.id}, 結果: $result)");
//   return result;
// }


  Future<int> updateSupplementQuantity(int id, int newQuantity) async {
    final db = await database;
    return await db.update(
      'supplements',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<List<Supplement>> getAllSupplements() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('supplements');

  return List.generate(maps.length, (i) {
    return Supplement(
      id: maps[i]['id'] ?? 0, // ✅ `null` を回避し、データベースの `ID` を使用
      name: maps[i]['name'],
      quantity: maps[i]['quantity'],
      dailyConsumption: maps[i]['dailyConsumption'],
    );
  });
}
}