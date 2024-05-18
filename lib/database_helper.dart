import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialize the database if not already initialized
    _database = await openDatabase(
      join(await getDatabasesPath(), 'notesDB.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, created_at TEXT)',
        );
      },
      version: 1,
    );

    return _database!;
  }

  static Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await getDatabase();
    return await db.query('notes');
  }

  static Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await getDatabase();
    await db.insert('notes', note,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNoteById(int id) async {
    final db = await getDatabase();
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateNote(Map<String, dynamic> note) async {
    final db = await getDatabase();
    return await db
        .update('notes', note, where: 'id = ?', whereArgs: [note['id']]);
  }
}
