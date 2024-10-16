import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'cards.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE Cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image_url TEXT NOT NULL,
        folder_id INTEGER,
        FOREIGN KEY (folder_id) REFERENCES Folders (id)
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert Folders
    List<String> folderNames = ['Hearts', 'Spades', 'Diamonds', 'Clubs'];
    for (String folderName in folderNames) {
      await db.insert('Folders', {'folder_name': folderName});
    }

    // Insert Cards
    List<Map<String, dynamic>> cards = [];
    List<String> suits = ['Hearts', 'Spades', 'Diamonds', 'Clubs'];
    for (String suit in suits) {
      for (int i = 1; i <= 13; i++) {
        String cardName;
        String imageUrl =
            'https://example.com/cards/${i}_of_${suit.toLowerCase()}.png';

        switch (i) {
          case 1:
            cardName = 'Ace of $suit';
            break;
          case 11:
            cardName = 'Jack of $suit';
            break;
          case 12:
            cardName = 'Queen of $suit';
            break;
          case 13:
            cardName = 'King of $suit';
            break;
          default:
            cardName = '$i of $suit';
        }

        cards.add({
          'name': cardName,
          'suit': suit,
          'image_url': imageUrl,
          'folder_id':
              (suits.indexOf(suit) + 1) // Assuming folder IDs start from 1
        });
      }
    }

    // Insert all cards
    for (var card in cards) {
      await db.insert('Cards', card);
    }
  }
}
