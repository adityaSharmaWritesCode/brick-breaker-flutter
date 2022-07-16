import 'package:brick_breaker/gamepage.dart';
import 'package:brick_breaker/homepage.dart';
import 'package:brick_breaker/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.route,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.tealAccent,
        primaryColor: Colors.tealAccent,
        textTheme: TextTheme(
            displayLarge: TextStyle(
              color: Colors.tealAccent.shade100,
              fontFamily: 'Press_Start_2P',
            ),
            displayMedium: const TextStyle(
              fontFamily: 'Amaranth',
            )),
      ),
      routes: {
        HomeScreen.route: (context) => const HomeScreen(),
        GameScreen.route: (context) => const GameScreen(),
        SettingScreen.route: (context) => const SettingScreen(),
      },
    );
  }
}

/*
  CHALLENGES : 
  1. Difficulty in Moving Player : 
  => Resolved through use of keyboard in desktop. 
      Have to work on dragging the scroll on mobile.

  2. How to maintain

*/