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
            location TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE dates (
            date TEXT PRIMARY KEY
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

  static Future<void> insertDate(Map<String, dynamic> date) async {
    final db = await database;
    await db.insert('dates', date);
  }

  static Future<List<Map<String, dynamic>>> getAllDates() async {
    final db = await database;
    return await db.query('dates');
  }

// Add other methods for updating, deleting, and querying events
}
