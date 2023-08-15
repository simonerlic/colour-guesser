import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:colour/views/widgets/colored_box.dart';
import 'package:colour/views/widgets/color_selector.dart';
import 'package:colour/views/game/results_page.dart';
import 'package:colour/models/hash_date_to_color.dart';
import 'package:colour/models/game_result.dart';

class GameView extends StatefulWidget {
  final bool useRandomDate;

  const GameView({Key? key, this.useRandomDate = false}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Color selectedColor = Colors.black;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    currentDate = widget.useRandomDate ? generateRandomDate() : DateTime.now();
  }

  DateTime generateRandomDate() {
    final random = Random();
    final minDate = DateTime(2000, 1, 1);
    final maxDate = DateTime.now();
    final randomDuration =
        Duration(days: random.nextInt(maxDate.difference(minDate).inDays));
    return minDate.add(randomDuration);
  }

  @override
  Widget build(BuildContext context) {
    Color color = hashDateToColor(currentDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text('Make a Guess'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ColoredBoxWidget(
                color: color,
              ),
              ColorPicker(
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: ElevatedButton(
                  onPressed: () {
                    if (!widget.useRandomDate) {
                      saveResult();
                    }

                    HapticFeedback.lightImpact();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(
                          goalColor: color,
                          userColor: selectedColor,
                          wasRandom: widget.useRandomDate,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text("Make Guess"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final gameResultsJson = prefs.getStringList('gameResults') ?? [];

    final gameResult = GameResult(
      date: DateTime.now(),
      actualColor: hashDateToColor(currentDate),
      guessedColor: selectedColor,
    );

    gameResultsJson.add(jsonEncode(gameResult.toMap()));

    await prefs.setStringList('gameResults', gameResultsJson);
  }
}
