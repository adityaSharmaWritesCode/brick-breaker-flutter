import 'package:brick_breaker/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
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