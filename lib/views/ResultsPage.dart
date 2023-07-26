// A new page that displays the user's guess and the correct answer

import 'package:flutter/material.dart';
import 'package:colour/views/SplitColoredBoxWidget.dart';

class ResultsPage extends StatelessWidget {
  final Color goalColor;
  final Color userColor;

  const ResultsPage(
      {super.key, required this.goalColor, required this.userColor});

  int _getScore(Color goalColor, Color userColor) {
    final redDiff = (goalColor.red - userColor.red).abs();
    final greenDiff = (goalColor.green - userColor.green).abs();
    final blueDiff = (goalColor.blue - userColor.blue).abs();

    const maxDiff = 255 * 3;

    final totalDiff = redDiff + greenDiff + blueDiff;
    final normalizedDiff = (1 - (totalDiff / maxDiff)).clamp(0.0, 1.0);

    const scoreRange = 100;
    final score = (normalizedDiff * scoreRange).round();

    return score;
  }

  @override
  Widget build(BuildContext context) {
    int score = _getScore(goalColor, userColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, //Theme.of(context).colorScheme.inversePrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text("Results"),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SplitColoredBoxWidget(
              goalColor: goalColor,
              userColor: userColor,
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              // Left align text
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Results",
                    style: Theme.of(context).textTheme.headlineSmall),
                Text("You got $score points!")
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
