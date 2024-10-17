import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cards.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE folders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            folder_name TEXT
          )
        ''').then((_) {
          return db.execute('''
            CREATE TABLE cards(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              folder_id INTEGER,
              name TEXT,
              image_url TEXT,
              FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
            )
          ''');
        });
      },
    );
  }

  Future<void> addFolder(String name) async {
    final db = await database;
    await db.insert(
      'folders',
      {'folder_name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    final db = await database;
    return await db.query('folders');
  }

  Future<void> updateFolder(int id, String name) async {
    final db = await database;
    await db.update(
      'folders',
      {'folder_name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFolder(int id) async {
    final db = await database;
    await db.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addCard(int folderId, String name, String imageUrl) async {
    final db = await database;
    await db.insert(
      'cards',
      {'folder_id': folderId, 'name': name, 'image_url': imageUrl},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchCards(int folderId) async {
    final db = await database;
    return await db
        .query('cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<bool> cardExists(int folderId, String name) async {
    final db = await database;
    final result = await db.query(
      'cards',
      where: 'folder_id = ? AND name = ?',
      whereArgs: [folderId, name],
    );
    return result.isNotEmpty;
  }

  Future<void> updateCard(int id, String name, String imageUrl) async {
    final db = await database;
    await db.update(
      'cards', // Your table name
      {'name': name, 'image_url': imageUrl},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCard(int id) async {
    final db = await database;
    await db.delete(
      'cards', // Your table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}