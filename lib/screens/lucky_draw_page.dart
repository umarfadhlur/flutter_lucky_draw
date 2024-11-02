import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_lucky_draw/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LuckyDrawPage extends StatefulWidget {
  final String category;

  const LuckyDrawPage({super.key, required this.category});

  @override
  LuckyDrawPageState createState() => LuckyDrawPageState();
}

class LuckyDrawPageState extends State<LuckyDrawPage> {
  List<String> _participants = [];
  final StreamController<int> _controller = StreamController<int>();
  int _winnerIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? storedParticipants = prefs.getStringList('participants');
      if (storedParticipants != null) {
        setState(() {
          _participants = storedParticipants;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading participants: $e");
      }
    }
  }

  Color getColor(int index) {
    switch (index % 3) {
      case 0:
        return KansaiColors.red;
      case 1:
        return KansaiColors.blue;
      case 2:
        return KansaiColors.navy;
      default:
        return KansaiColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Spin!'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/kansai.png',
              width: 100.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Positioned widget to place the image at the top left corner
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Image.asset(
              'assets/luckydraw.png', // Adjust the path as necessary
              width: 300.0, // Adjust the size as needed
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: _participants.isEmpty
                ? const CircularProgressIndicator()
                : FortuneWheel(
                    animateFirst: false,
                    selected: _controller.stream,
                    items: _participants.asMap().entries.map(
                      (entry) {
                        int index = entry.key;
                        String participant = entry.value;
                        return FortuneItem(
                          style: FortuneItemStyle(
                            color: getColor(index),
                            borderColor: KansaiColors.navy,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              participant,
                              style: const TextStyle(
                                color: KansaiColors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onFling: () => const Duration(milliseconds: 50),
                    onAnimationEnd: () {
                      if (_winnerIndex != -1) {
                        _showWinnerPopup(
                            _participants[_winnerIndex], widget.category);
                      }
                      _winnerIndex = -1;
                    },
                    duration: const Duration(seconds: 20),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_participants.isNotEmpty) {
            _winnerIndex = Random().nextInt(_participants.length);
            _controller.add(_winnerIndex);
          }
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  void _showWinnerPopup(String winner, String prize) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You Are the Winner!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                winner,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
  