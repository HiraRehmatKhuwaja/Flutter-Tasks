import 'package:flutter_application_9/Notes..dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static Database? _database;
  final String tablename = "notes";
  get database async {
    if (_database != null) {
      return _database!;
    } else
      _database = await intDb();
    return _database!;
  }

  Future<Database> intDb() async {
    final dbpath = await getDatabasesPath();
    final db = join(dbpath, "notes.db");
    return await openDatabase(
      db,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $tablename(id INTEGER PRIMARY KEY, tilte TEXT, desc TEXT)");
      },
    );
  }

  insert(Notes note) async {
    final db = await database;
    Map<String, dynamic> notemap = {
      "id": note.id,
      "title": note.title,
      "desc": note.desc
    };
    db.insert(tablename, notemap);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return db.query(tablename);
  }

  update(Notes note) async {
    final db = await database;
    Map<String, dynamic> notemap = {
      "id": note.id,
      "note": note.title,
      "desc": note.desc
    };
    db.update(
      tablename,
      notemap,
      where: "id = ? and title = ?",
      whereArgs: [note.id, note.title],
    );
  }

  delete(int id) async {
    final db = await database;
    db.delete(tablename,
     where: "id=?",
     whereArgs: [id]);
  }
}
