import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'destination.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'destinations.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE destinations(name TEXT '
            'PRIMARY KEY, capital TEXT, region TEXT, '
            'population INTEGER, flagUrl TEXT)');
      },
    );
  }

  static Future<void> cacheDestinations(
      List<Destination> destinations) async {
    final database = await db;
    for (final d in destinations) {
      await database.insert(
        'destinations',
        d.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Destination>> getCachedDestinations() async {
    final database = await db;
    final rows = await database.query('destinations');
    return rows.map((row) => Destination.fromMap(row)).toList();
  }
}
