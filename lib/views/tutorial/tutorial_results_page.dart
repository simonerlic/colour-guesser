import 'package:flutter/material.dart';
import 'package:colour/views/widgets/split_colored_box.dart';
import 'package:colour/views/tutorial/finish_tutorial_view.dart';

class TutorialResultsPage extends StatelessWidget {
  final Color goalColor;
  final Color userColor;

  const TutorialResultsPage({
    Key? key,
    required this.goalColor,
    required this.userColor,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                    const Text(
                        "When you finish a round, you'll get your score and the difference between your color and the goal color."),
                    const SizedBox(
                      height: 16,
                    ),
                    Text("In this case, you got $score points! Well done!"),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "🟥 was off by ${(goalColor.red - userColor.red).abs()},"),
                        Text(
                            "🟩 was off by ${(goalColor.green - userColor.green).abs()}, and"),
                        Text(
                            "🟦 was off by ${(goalColor.blue - userColor.blue).abs()}"),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FinishTutorialPage(),
                      ),
                    );
                  },
                  child: const Text("Ok!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
