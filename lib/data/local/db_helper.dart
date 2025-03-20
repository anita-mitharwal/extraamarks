import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/rocket_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'rockets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE rockets (
            id TEXT PRIMARY KEY,
            name TEXT,
            country TEXT,
            engines INTEGER,
            flickrImages TEXT,
            active INTEGER,
            costPerLaunch INTEGER,
            successRatePct INTEGER,
            description TEXT,
            wikipedia TEXT,
            heightFeet REAL,
            diameterFeet REAL
          )
        ''');
      },
    );
  }

  // ✅ Insert Rocket Data
  Future<void> insertRocket(Rocket rocket) async {
    final db = await database;
    await db.insert(
      'rockets',
      rocket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Get All Rockets
  Future<List<Rocket>> getRockets() async {
    final db = await database;
    final result = await db.query('rockets');
    return result.map((e) => Rocket.fromMap(e)).toList();
  }

  // ✅ Get Rocket Details by ID
  Future<Rocket?> getRocketById(String id) async {
    final db = await database;
    final result = await db.query('rockets', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Rocket.fromMap(result.first);
    }
    return null;
  }

  // ✅ Clear All Rockets (Optional)
  Future<void> clearRockets() async {
    final db = await database;
    await db.delete('rockets');
  }
}
