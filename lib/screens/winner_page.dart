import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WinnerPage extends StatefulWidget {
  const WinnerPage({super.key});

  @override
  WinnerPageState createState() => WinnerPageState();
}

class WinnerPageState extends State<WinnerPage> {
  List<Map<String, String>> winners = [];

  @override
  void initState() {
    super.initState();
    _loadWinners();
  }

  Future<void> _clearWinners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('winners');
    winners.clear();
    setState(() {});
  }

  Future<void> _loadWinners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? winnersList = prefs.getStringList('winners');

    if (winnersList != null && winnersList.isNotEmpty) {
      winners.clear();
      for (String winnerString in winnersList) {
        try {
          Map<String, dynamic> winnerData = jsonDecode(winnerString);
          winners.add(Map<String, String>.from(winnerData));
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding JSON: $e');
          }
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemenang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _clearWinners();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: winners.isEmpty
            ? const Center(child: Text('Tidak ada pemenang tersedia.'))
            : ListView.builder(
                itemCount: winners.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peserta: ${winners[index]['winner']}'),
                          Text('Hadiah: ${winners[index]['prize']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
