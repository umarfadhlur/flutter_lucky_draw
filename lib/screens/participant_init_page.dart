import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prize_category_page.dart';

class ParticipantInitPage extends StatefulWidget {
  const ParticipantInitPage({super.key});

  @override
  ParticipantInitPageState createState() => ParticipantInitPageState();
}

class ParticipantInitPageState extends State<ParticipantInitPage> {
  final TextEditingController _participantController = TextEditingController();

  int get _participantCount {
    // Hitung setiap baris yang tidak kosong sebagai peserta individu
    return _participantController.text
        .trim()
        .split('\n')
        .where((line) => line.isNotEmpty)
        .length;
  }

  Future<void> _startDraw() async {
    // Pisahkan input menjadi daftar peserta
    List<String> participants = _participantController.text
        .trim()
        .split('\n')
        .where((line) => line.isNotEmpty)
        .toList();

    if (participants.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Simpan daftar peserta
      await prefs.setStringList('participants', participants);

      // Lanjutkan ke halaman berikutnya
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrizeCategoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inisiasi Peserta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _participantController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan nama peserta (pisahkan per baris)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null, // Izinkan input multi-baris
                onChanged: (_) => setState(
                    () {}), // Update jumlah peserta setiap perubahan teks
              ),
            ),
            const SizedBox(height: 10),
            Text('Jumlah peserta: $_participantCount'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _participantCount > 0
                  ? _startDraw
                  : null, // Nonaktifkan jika tidak ada peserta
              child: const Text('Mulai Undian'),
            ),
          ],
        ),
      ),
    );
  }
}
