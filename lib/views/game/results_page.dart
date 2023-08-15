import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:colour/views/widgets/split_colored_box.dart';
import 'package:colour/views/game/game_view.dart';
import 'package:share_plus/share_plus.dart';

class ResultsPage extends StatelessWidget {
  final Color goalColor;
  final Color userColor;
  final bool wasRandom;

  const ResultsPage({
    Key? key,
    required this.goalColor,
    required this.userColor,
    required this.wasRandom,
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
          title: const Text("Results"),
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                                Text("You got $score points!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    if (wasRandom) {
                                      Share.share("""
Prismatic - Practice
Δ🟥: ${(goalColor.red - userColor.red)}
Δ🟩: ${(goalColor.green - userColor.green)}
Δ🟦: ${(goalColor.blue - userColor.blue)}

Score: $score
""", subject: 'Share your Prismatic score!');
                                    } else {
                                      Share.share("""
Prismatic - Daily
Δ🟥: ${(goalColor.red - userColor.red)}
Δ🟩: ${(goalColor.green - userColor.green)}
Δ🟦: ${(goalColor.blue - userColor.blue)}

Score: $score
""", subject: 'Share your Prismatic score!');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  child: const Icon(Icons.share)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("𝚫🟥: ${(goalColor.red - userColor.red)}"),
                        Text("𝚫🟩: ${(goalColor.green - userColor.green)}"),
                        Text("𝚫🟦: ${(goalColor.blue - userColor.blue)}"),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (wasRandom)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GameView(useRandomDate: true)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text("Play Again"),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text("Done"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
