import 'package:flutter/material.dart';
import 'views/home/home_screen.dart';

void main() {
  runApp(const BetTrackerApp());
}

class BetTrackerApp extends StatelessWidget {
  const BetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bet Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff121212),
        colorScheme: const ColorScheme.dark(
          primary: const Color(0xff1fefb4),
          secondary: const Color(0xffff4a4a),
          surface: const Color(0xff1e1e1e),
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}