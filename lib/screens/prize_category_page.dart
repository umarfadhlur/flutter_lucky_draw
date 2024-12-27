import 'package:flutter/material.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart';
import 'package:flutter_lucky_draw/screens/participant_init_page.dart';
import 'package:flutter_lucky_draw/screens/winner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrizeCategoryPage extends StatefulWidget {
  const PrizeCategoryPage({super.key});

  @override
  PrizeCategoryPageState createState() => PrizeCategoryPageState();
}

class PrizeCategoryPageState extends State<PrizeCategoryPage> {
  List<Map<String, String>> prizeCategories = [
    {
      'name': 'Yamaha Fazzio Hybrid 125',
      'imageUrl': 'https://img.youtube.com/vi/7b1LcPnBviY/0.jpg',
    },
    {
      'name': 'Honda Beat 125',
      'imageUrl': 'https://img.youtube.com/vi/c3uNNgNWuI8/0.jpg',
    },
    {
      'name': 'New Honda Blade 125 FI',
      'imageUrl': 'https://img.youtube.com/vi/50iLuNCxs3s/0.jpg',
    },
    {
      'name': 'Honda Icon E',
      'imageUrl': 'https://img.youtube.com/vi/8ksiXH2fiL8/0.jpg',
    },
  ];
  List<String> participants = [];

  @override
  void initState() {
    super.initState();
    _loadParticipants();
    _loadPrizeCategories();
  }

  Future<void> _loadParticipants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedParticipants = prefs.getStringList('participants');
    if (storedParticipants != null) {
      setState(() {
        participants = storedParticipants;
      });
    }
  }

  Future<void> _loadPrizeCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCategories = prefs.getString('prizeCategories');
    if (storedCategories != null) {
      setState(() {
        prizeCategories = List<Map<String, String>>.from(
          (storedCategories as List)
              .map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  Future<void> _savePrizeCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('prizeCategories', prizeCategories.toString());
  }

  Future<void> _addPrizeCategory(String name, String imageUrl) async {
    prizeCategories.add({
      'name': name,
      'imageUrl': imageUrl,
    });
    await _savePrizeCategories();
    setState(() {});
  }

  void _showAddCategoryDialog() {
    String newName = '';
    String newImageUrl = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Hadiah Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Nama Hadiah'),
                onChanged: (value) {
                  newName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Link Gambar'),
                onChanged: (value) {
                  newImageUrl = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty && newImageUrl.isNotEmpty) {
                  _addPrizeCategory(newName, newImageUrl);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Kategori Hadiah'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Jumlah Peserta Tersedia: ${participants.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: prizeCategories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: participants.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LuckyDrawPage(
                                    category: prizeCategories[index]['name']!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: GridTile(
                        header: prizeCategories[index]['imageUrl'] != null
                            ? Image.network(
                                prizeCategories[index]['imageUrl']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image),
                        child: Center(
                          child: Text(prizeCategories[index]['name'] ?? ''),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _showAddCategoryDialog,
                child: const Text('Tambah Hadiah'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: participants.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WinnerPage(),
                          ),
                        );
                      }
                    : null,
                child: const Text('Riwayat Pemenang'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ParticipantInitPage()),
      (Route<dynamic> route) => false,
    );
    return false;
  }
}
