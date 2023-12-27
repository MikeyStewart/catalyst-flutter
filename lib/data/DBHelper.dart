import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Singleton pattern to ensure only one instance of the database exists
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'events.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables if they don't exist
        await db.execute('''
          CREATE TABLE events (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            categories TEXT,
            date TEXT,
            adultWarnings TEXT,
            startTime TEXT,
            endTime TEXT,
            location TEXT,
            saved INTEGER  -- Integer used to represent a boolean (0 for false, 1 for true)
          )
        ''');
      },
    );
  }

  static Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db.insert('events', event);
  }

  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    final db = await database;
    return await db.query('events');
  }

  static Future<List<String>> getUniqueDates() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT DISTINCT date FROM events ORDER BY date ASC');

    // Extract dates from the result and convert them to a list of strings
    List<String> uniqueDates = result.map((map) => map['date'] as String).toList();

    return uniqueDates;
  }

  static Future<void> updateEvent(Map<String, dynamic> event) async {
    final db = await database;

    await db.update(
      'events',
      event,
      where: 'id = ?',
      whereArgs: [event['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
