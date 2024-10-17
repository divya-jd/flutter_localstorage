
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper
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

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<Map<String, dynamic>> folders = [
    {'id': 1, 'folder_name': 'Hearts'},
    {'id': 2, 'folder_name': 'Clubs'},
    {'id': 3, 'folder_name': 'Spades'},
    {'id': 4, 'folder_name': 'Diamonds'},
  ];

  void _addFolder() {
    String folderName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  int newId = folders.length + 1; // Simple ID assignment
                  folders.add({'id': newId, 'folder_name': folderName});
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateFolder(Map<String, dynamic> folder) {
    final TextEditingController controller =
        TextEditingController(text: folder['folder_name']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Folder'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  final index =
                      folders.indexWhere((f) => f['id'] == folder['id']);
                  if (index != -1) {
                    folders[index]['folder_name'] = controller.text;
                  }
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFolder(Map<String, dynamic> folder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Folder'),
          content: Text('Are you sure you want to delete this folder?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  folders.removeWhere((f) => f['id'] == folder['id']);
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showFolderOptions(String action) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return ListTile(
              title: Text(folder['folder_name']),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                if (action == 'edit') {
                  _updateFolder(folder);
                } else if (action == 'delete') {
                  _deleteFolder(folder);
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addFolder,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showFolderOptions('edit'),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showFolderOptions('delete'),
          ),
        ],
      ),
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
                    (folder['folder_name'] == 'Hearts' ||
                            folder['folder_name'] == 'Diamonds')
                        ? 'https://cdn.pixabay.com/photo/2022/02/23/20/25/card-7031432_1280.png'
                        : (folder['folder_name'] == 'Spades' ||
                                folder['folder_name'] == 'Clubs')
                            ? 'https://deckofcardsapi.com/static/img/back.png'
                            : 'https://i.redd.it/look-for-opinions-on-my-2-playing-card-back-designs-look-to-v0-r4rle6ipe3fc1.png?width=816&format=png&auto=webp&s=e5a6eca1e034c45a1221c80a23fe16dbbe6c45db',
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(folder['folder_name'], style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Define cardsByFolder outside the CardsScreen class
final Map<int, List<Map<String, dynamic>>> cardsByFolder = {
  1: [
    {
      'name': 'Heart Ace',
      'image_url': 'https://deckofcardsapi.com/static/img/AH.png'
    },
    {
      'name': 'Heart 2',
      'image_url': 'https://deckofcardsapi.com/static/img/2H.png'
    },
    {
      'name': 'Heart 3',
      'image_url': 'https://deckofcardsapi.com/static/img/3H.png'
    },
    {
      'name': 'Heart 4',
      'image_url': 'https://deckofcardsapi.com/static/img/4H.png'
    },
    {
      'name': 'Heart 5',
      'image_url': 'https://deckofcardsapi.com/static/img/5H.png'
    },
    {
      'name': 'Heart 6',
      'image_url': 'https://deckofcardsapi.com/static/img/6H.png'
    },
    {
      'name': 'Heart 7',
      'image_url': 'https://deckofcardsapi.com/static/img/7H.png'
    },
    {
      'name': 'Heart 8',
      'image_url': 'https://deckofcardsapi.com/static/img/8H.png'
    },
    {
      'name': 'Heart 9',
      'image_url': 'https://deckofcardsapi.com/static/img/9H.png'
    },
    {
      'name': 'Heart King',
      'image_url': 'https://deckofcardsapi.com/static/img/KH.png'
    },
    {
      'name': 'Heart Queen',
      'image_url': 'https://deckofcardsapi.com/static/img/QH.png'
    },
    {
      'name': 'Heart Jack',
      'image_url': 'https://deckofcardsapi.com/static/img/JH.png'
    }
  ],
  2: [
    {
      'name': 'Club Ace',
      'image_url': 'https://deckofcardsapi.com/static/img/AC.png'
    },

    {
      'name': 'Club 2',
      'image_url': 'https://deckofcardsapi.com/static/img/2C.png'
    },
    {
      'name': 'Club 3',
      'image_url': 'https://deckofcardsapi.com/static/img/3C.png'
    },
    {
      'name': 'Club 4',
      'image_url': 'https://deckofcardsapi.com/static/img/4C.png'
    },
    {
      'name': 'Club 5',
      'image_url': 'https://deckofcardsapi.com/static/img/5C.png'
    },
    {
      'name': 'Club 6',
      'image_url': 'https://deckofcardsapi.com/static/img/6C.png'
    },
    {
      'name': 'Club 7',
      'image_url': 'https://deckofcardsapi.com/static/img/7C.png'
    },
    {
      'name': 'Club 8',
      'image_url': 'https://deckofcardsapi.com/static/img/8C.png'
    },
    {
      'name': 'Club 9',
      'image_url': 'https://deckofcardsapi.com/static/img/9C.png'
    },
    {
      'name': 'Club King ',
      'image_url': 'https://deckofcardsapi.com/static/img/KC.png'
    },
    {
      'name': 'Club Queen',
      'image_url': 'https://deckofcardsapi.com/static/img/QC.png'
    },
    {
      'name': 'Club Jack',
      'image_url': 'https://deckofcardsapi.com/static/img/JC.png'
    },

  ],
  3: [
    {
      'name': 'Spade Ace',
      'image_url': 'https://deckofcardsapi.com/static/img/AS.png'
    },
    {
      'name': 'Spade 2',
      'image_url': 'https://deckofcardsapi.com/static/img/2S.png'
    },
    {
      'name': 'Spade 3',
      'image_url': 'https://deckofcardsapi.com/static/img/3S.png'
    },
    {
      'name': 'Spade 4',
      'image_url': 'https://deckofcardsapi.com/static/img/4S.png'
    },
    {
      'name': 'Spade 5',
      'image_url': 'https://deckofcardsapi.com/static/img/5S.png'
    },
    {
      'name': 'Spade 6',
      'image_url': 'https://deckofcardsapi.com/static/img/6S.png'
    },
    {
      'name': 'Spade 7',
      'image_url': 'https://deckofcardsapi.com/static/img/7S.png'
    },
    {
      'name': 'Spade 8',
      'image_url': 'https://deckofcardsapi.com/static/img/8S.png'
    },
    {
      'name': 'Spade 9',
      'image_url': 'https://deckofcardsapi.com/static/img/9S.png'
    },
    {
      'name': 'Spade King',
      'image_url': 'https://deckofcardsapi.com/static/img/KS.png'
    },
    {
      'name': 'Spade Queen',
      'image_url': 'https://deckofcardsapi.com/static/img/QS.png'
    },
    {
      'name': 'Spade Jack',
      'image_url': 'https://deckofcardsapi.com/static/img/JS.png'
    },

  
  ],
  4: [
    {
      'name': 'Diamond Ace',
      'image_url': 'https://deckofcardsapi.com/static/img/AD.png'
    },
    {
      'name': 'Diamond 2',
      'image_url': 'https://deckofcardsapi.com/static/img/2D.png'
    },
    {
      'name': 'Diamond 3',
      'image_url': 'https://deckofcardsapi.com/static/img/3D.png'
    },
    {
      'name': 'Diamond 4',
      'image_url': 'https://deckofcardsapi.com/static/img/4D.png'
    },
    {
      'name': 'Diamond 5',
      'image_url': 'https://deckofcardsapi.com/static/img/5D.png'
    },

    {
      'name': 'Diamond 6',
      'image_url': 'https://deckofcardsapi.com/static/img/6D.png'
    },

    {
      'name': 'Diamond 7',
      'image_url': 'https://deckofcardsapi.com/static/img/7D.png'
    },
    {
      'name': 'Diamond 8',
      'image_url': 'https://deckofcardsapi.com/static/img/8D.png'
    },
    {
      'name': 'Diamond 9',
      'image_url': 'https://deckofcardsapi.com/static/img/9D.png'
    },
    {
      'name': 'Diamond King',
      'image_url': 'https://deckofcardsapi.com/static/img/KD.png'
    },
    {
      'name': 'Diamond Queen',
      'image_url': 'https://deckofcardsapi.com/static/img/QD.png'
    },
    {
      'name': 'Diamond Jack',
      'image_url': 'https://deckofcardsapi.com/static/img/JD.png'
    },
    
  ],
};

class CardsScreen extends StatefulWidget {
  final int folderId;

  CardsScreen({required this.folderId});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards(); // Fetch initial cards from the database
  }

  Future<void> _fetchCards() async {
    List<Map<String, dynamic>> fetchedCards =
        await DatabaseHelper().fetchCards(widget.folderId);
    setState(() {
      cards = fetchedCards;
    });
  }

  void _addCard(Map<String, dynamic> card) async {
  bool cardExists = cards.any((c) => c['name'] == card['name']);
  if (cardExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card "${card['name']}" is already in this folder!'),
        duration: Duration(seconds: 2),
      ),
    );
  } else if (cards.length >= 5) { // Limit to 5 cards
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You can only add up to 5 cards in this folder!'),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    await DatabaseHelper()
        .addCard(widget.folderId, card['name'], card['image_url']);
    _fetchCards(); // Refresh the card list after adding a new card
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card "${card['name']}" added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

  void _updateCard(Map<String, dynamic> card) async {
    final TextEditingController controller =
        TextEditingController(text: card['name']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Card'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Card Name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await DatabaseHelper().updateCard(
                      card['id'], controller.text, card['image_url']);
                  _fetchCards(); // Refresh the card list after updating
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without updating
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCard(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(
              onPressed: () async {
                await DatabaseHelper().deleteCard(card['id']);
                _fetchCards(); // Refresh the card list after deletion
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCardsForUpdate() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return ListTile(
              title: Text(card['name']),
              leading: Image.network(card['image_url'], width: 50),
              onTap: () {
                _updateCard(card); // Call the updateCard method
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }

  void _showCardsForDelete() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return ListTile(
              title: Text(card['name']),
              leading: Image.network(card['image_url'], width: 50),
              onTap: () {
                _deleteCard(card); // Call the deleteCard method
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }

  void _showAvailableCards() {
    List<Map<String, dynamic>> availableCards =
        cardsByFolder[widget.folderId] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Card'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: availableCards.length,
              itemBuilder: (context, index) {
                final card = availableCards[index];
                return ListTile(
                  title: Text(card['name']),
                  leading: Image.network(card['image_url'], width: 50),
                  onTap: () {
                    _addCard(card); // Call the addCard method
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAvailableCards,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showCardsForUpdate,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showCardsForDelete,
          ),
        ],
      ),
      body: cards.isEmpty
          ? Center(child: Text('No cards available. Add some!'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return GestureDetector(
                  onTap: () {
                    // Additional tap logic if needed
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(card['image_url'], height: 100),
                        SizedBox(height: 10),
                        Text(card['name']),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
//crud