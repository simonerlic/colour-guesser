import 'package:flutter/material.dart';

import 'package:colour/views/start_page.dart';
import 'package:colour/models/hash_date_to_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prismatic',
      theme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(
            seedColor: hashDateToColor(DateTime.now()),
            brightness: Brightness.light),
        useMaterial3: true,

        // Define the default TextTheme. Use Lexend-Regular for the body and Lexend-Medium for the title.
        textTheme: const TextTheme(
          bodySmall:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w400),
          headlineMedium:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(
            seedColor: hashDateToColor(DateTime.now()),
            brightness: Brightness.dark),
        useMaterial3: true,

        // Define the default TextTheme. Use Lexend-Regular for the body and Lexend-Medium for the title.
        textTheme: const TextTheme(
          bodySmall:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w400),
          headlineMedium:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500),
          // Colour to be a tinted version of the primary colour
        ),
      ),
      themeMode: ThemeMode.system,
      home: const StartPage(),
    );
  }
}
