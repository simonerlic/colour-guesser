import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameResult {
  final DateTime date;
  final Color actualColor;
  final Color guessedColor;

  GameResult({
    required this.date,
    required this.actualColor,
    required this.guessedColor,
  });

  // Convert a GameResult into a Map.
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'actualColor': actualColor.value,
      'guessedColor': guessedColor.value,
    };
  }

  // Convert a Map into a GameResult.
  static GameResult fromMap(Map<String, dynamic> map) {
    return GameResult(
      date: DateTime.parse(map['date']),
      actualColor: Color(map['actualColor']),
      guessedColor: Color(map['guessedColor']),
    );
  }

  // Clear all GameResults from the device.
  static Future<void> clearGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('gameResults');
  }
}
