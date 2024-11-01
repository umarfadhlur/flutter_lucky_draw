import 'package:flutter/material.dart';
import 'package:flutter_lucky_draw/screens/participant_init_page.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart';
import 'package:flutter_lucky_draw/screens/winner_page.dart';
import 'package:flutter_lucky_draw/screens/prize_category_page.dart';

void main() {
  runApp(const LuckyDrawApp());
}

class LuckyDrawApp extends StatelessWidget {
  const LuckyDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Draw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ParticipantInitPage(),
        '/prize_category': (context) => const PrizeCategoryPage(),
        '/lucky_draw': (context) => const LuckyDrawPage(category: 'Category'),
        '/winners': (context) => const WinnerPage(),
      },
    );
  }
}