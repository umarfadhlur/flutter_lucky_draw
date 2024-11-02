import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucky_draw/screens/participant_init_page.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart';
import 'package:flutter_lucky_draw/screens/winner_page.dart';
import 'package:flutter_lucky_draw/screens/prize_category_page.dart';
import 'package:flutter_lucky_draw/utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const LuckyDrawApp());
}

class LuckyDrawApp extends StatelessWidget {
  const LuckyDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Draw',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
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
