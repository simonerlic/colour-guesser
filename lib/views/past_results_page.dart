import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:colour/views/widgets/split_colored_box.dart';

class PastResultsPage extends StatelessWidget {
  final Color goalColor;
  final Color userColor;
  final String guessDate;

  const PastResultsPage({
    Key? key,
    required this.goalColor,
    required this.userColor,
    required this.guessDate,
  }) : super(key: key);

  int _getScore(Color goalColor, Color userColor) {
    // Calculate the difference between the goal color and the user's color
    final redDiff = (goalColor.red - userColor.red).abs();
    final greenDiff = (goalColor.green - userColor.green).abs();
    final blueDiff = (goalColor.blue - userColor.blue).abs();

    // Calculate the maximum possible difference (when all color components are 255)
    const maxDiff = 255 * 3;

    // Calculate the total difference between the colors and normalize it to a score within 0 to 100
    final totalDiff = redDiff + greenDiff + blueDiff;
    final normalizedDiff = totalDiff / maxDiff;

    // Scale the normalized difference to the desired score range (e.g., 0 to 100)
    const scoreRange = 100;
    final score = ((1 - normalizedDiff) * scoreRange).round();

    return score;
  }

  @override
  Widget build(BuildContext context) {
    int score = _getScore(goalColor, userColor);

    return Scaffold(
      appBar: AppBar(
        title: Text("Guess from $guessDate"),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SplitColoredBoxWidget(
              goalColor: goalColor,
              userColor: userColor,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Score",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text("You got $score points!"),
                            ],
                          ),
                          // const Spacer(),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.18,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         Share.share(
                          //             "Can you beat my score? https://prismatic.serlic.dev",
                          //             subject:
                          //                 'I got $score points in Prismatic!');
                          //       },
                          //       child: const Icon(Icons.share)),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Your Color: rgb(${userColor.red}, ${userColor.green}, ${userColor.blue})"),
                      Text(
                          "Goal Color: rgb(${goalColor.red}, ${goalColor.green}, ${goalColor.blue})"),
                      const SizedBox(
                        height: 16,
                      ),
                      Text("𝚫🟥: ${(goalColor.red - userColor.red).abs()}"),
                      Text(
                          "𝚫🟩: ${(goalColor.green - userColor.green).abs()}"),
                      Text("𝚫🟦: ${(goalColor.blue - userColor.blue).abs()}"),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.86,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          child: const Text("Done"),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
