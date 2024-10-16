import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Database',
      home: FoldersScreen(),
    );
  }
}

class FoldersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> folders = [
    {'id': 1, 'folder_name': 'Hearts'},
    {'id': 2, 'folder_name': 'Spades'},
    {'id': 3, 'folder_name': 'Diamonds'},
    {'id': 4, 'folder_name': 'Clubs'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Folders')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardsScreen(folderId: folder['id']),
                ),
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://deckofcardsapi.com/static/img/${folder['folder_name'][0].toLowerCase()}01.png',
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(folder['folder_name'], style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                  FutureBuilder<int>(
                    future: _countCardsInFolder(folder['id']),
                    builder: (context, cardSnapshot) {
                      if (cardSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (cardSnapshot.hasError) {
                        return Text('Error: ${cardSnapshot.error}');
                      } else {
                        return Text('${cardSnapshot.data} cards');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<int> _countCardsInFolder(int folderId) async {
    final db = await DatabaseHelper().database;
    final result = await db
        .rawQuery('SELECT COUNT(*) FROM Cards WHERE folder_id = ?', [folderId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

class CardsScreen extends StatelessWidget {
  final int folderId;

  CardsScreen({required this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add card logic can go here
            },
          ),
        ],
      ),
      body: Center(
        child: Text('No cards available.'),
      ),
    );
  }
}
