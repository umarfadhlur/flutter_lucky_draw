import 'package:flutter/material.dart';
import 'package:flutter_lucky_draw/screens/asset_video_player.dart';
import 'package:flutter_lucky_draw/screens/participant_init_page.dart';
import 'package:flutter_lucky_draw/screens/winner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrizeCategoryPage extends StatefulWidget {
  const PrizeCategoryPage({super.key});

  @override
  PrizeCategoryPageState createState() => PrizeCategoryPageState();
}

class PrizeCategoryPageState extends State<PrizeCategoryPage> {
  List<String> prizeCategories = [
    'Mesin Cuci Aqua 10KG Top Load',
    'AC Sharp Inverter 1/2 PK',
  ];
  List<String> participants = [];

  @override
  void initState() {
    super.initState();
    _loadParticipants();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Pilih Kategori Hadiah')),
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
                child: ListView.builder(
                  itemCount: prizeCategories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(prizeCategories[index]),
                      onTap: participants.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssetVideoPlayerScreen(
                                    category: prizeCategories[index],
                                  ),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),
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
                    : null, // Tidak aktif jika tidak ada peserta
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
