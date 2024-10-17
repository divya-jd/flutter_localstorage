import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// DatabaseHelper class to manage database operations
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'card_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Folders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            folder_name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE Cards(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            folder_id INTEGER,
            name TEXT,
            image_url TEXT,
            FOREIGN KEY (folder_id) REFERENCES Folders (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Insert a new folder (addFolder method)
  Future<int> addFolder(String folderName) async {
    final db = await database;
    return await db.insert('Folders', {'folder_name': folderName});
  }

  // Update an existing folder
  Future<int> updateFolder(int id, String folderName) async {
    final db = await database;
    return await db.update(
      'Folders',
      {'folder_name': folderName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a folder
  Future<int> deleteFolder(int id) async {
    final db = await database;
    return await db.delete(
      'Folders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch all folders
  Future<List<Map<String, dynamic>>> getFolders() async {
    final db = await database;
    return await db.query('Folders');
  }

  // Insert a new card (addCard method)
  Future<int> addCard(int folderId, String name, String imageUrl) async {
    final db = await database;
    return await db.insert('Cards', {
      'folder_id': folderId,
      'name': name,
      'image_url': imageUrl,
    });
  }

  // Fetch all cards in a folder
  Future<List<Map<String, dynamic>>> getCards(int folderId) async {
    final db = await database;
    return await db.query('Cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  // Delete a card (deleteCard method)
  Future<int> deleteCard(int cardId) async {
    final db = await database;
    return await db.delete(
      'Cards',
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }
}

// Main application entry point
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _folders = [];

  @override
  void initState() {
    super.initState();
    _fetchFolders();
  }

  Future<void> _fetchFolders() async {
    final folders = await _dbHelper.getFolders();
    setState(() {
      _folders = folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_folders[index]['folder_name']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add a new folder (for demonstration)
          await _dbHelper.addFolder('New Folder');
          _fetchFolders();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
