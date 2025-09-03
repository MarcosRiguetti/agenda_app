import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/evento.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'agenda.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE eventos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        dataHora TEXT,
        cor INTEGER
      )
    ''');
  }

  Future<int> insertEvento(Evento evento) async {
    final db = await database;
    return await db.insert('eventos', evento.toMap());
  }

  Future<List<Evento>> getEventos() async {
    final db = await database;
    final result = await db.query('eventos', orderBy: 'dataHora ASC');
    return result.map((map) => Evento.fromMap(map)).toList();
  }

  Future<int> updateEvento(Evento evento) async {
    final db = await database;
    return await db.update(
      'eventos',
      evento.toMap(),
      where: 'id = ?',
      whereArgs: [evento.id],
    );
  }

  Future<int> deleteEvento(int id) async {
    final db = await database;

    return await db.delete('eventos', where: 'id = ?', whereArgs: [id]);
  }
}
