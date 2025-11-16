import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import '../models/password_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Initialize SQFlite FFI untuk desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'password_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        website TEXT,
        note TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  // CREATE - Tambah password baru
  Future<int> insertPassword(Password password) async {
    Database db = await database;
    
    Map<String, dynamic> data = {
      'title': password.title,
      'username': password.username,
      'password': password.password,
      'website': password.website,
      'note': password.note,
      'createdAt': password.createdAt.millisecondsSinceEpoch,
      'updatedAt': password.updatedAt.millisecondsSinceEpoch,
    };
    
    return await db.insert('passwords', data);
  }

  // READ - Ambil semua password
  Future<List<Password>> getPasswords() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      orderBy: 'title ASC',
    );
    
    return List.generate(maps.length, (i) {
      return Password.fromMap(maps[i]);
    });
  }

  // READ - Ambil satu password by ID
  Future<Password?> getPassword(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Password.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE - Update password
  Future<int> updatePassword(Password password) async {
    Database db = await database;
    
    Map<String, dynamic> data = {
      'title': password.title,
      'username': password.username,
      'password': password.password,
      'website': password.website,
      'note': password.note,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    
    return await db.update(
      'passwords',
      data,
      where: 'id = ?',
      whereArgs: [password.id],
    );
  }

  // DELETE - Hapus password
  Future<int> deletePassword(int id) async {
    Database db = await database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Utility method untuk clear database (untuk testing)
  Future<void> clearAllPasswords() async {
    Database db = await database;
    await db.delete('passwords');
  }

  // Utility method untuk close database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
