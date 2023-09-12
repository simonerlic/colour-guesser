import 'dart:math';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:colour/views/widgets/split_colored_box.dart';
import 'package:colour/views/widgets/color_selector.dart';
import 'package:colour/views/game/timed_results_page.dart';
import 'package:colour/models/hash_date_to_color.dart';

class TimedGameView extends StatefulWidget {
  final bool useRandomDate;

  const TimedGameView({Key? key, this.useRandomDate = false}) : super(key: key);

  @override
  _TimedGameViewState createState() => _TimedGameViewState();
}

class _TimedGameViewState extends State<TimedGameView> {
  Color selectedColor = Colors.black;
  DateTime currentDate = DateTime.now();
  late Timer timer;
  int timeRemaining = 15;
  bool hasMadeGuess = false;

  @override
  void initState() {
    super.initState();
    currentDate = widget.useRandomDate ? generateRandomDate() : DateTime.now();
    timer = Timer(const Duration(seconds: 20), makeGuess);
    hasMadeGuess = false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showCountdown(context));
  }

  void makeGuess() {
    if (hasMadeGuess) return;

    if (timer.isActive) {
      timer.cancel(); // Cancel the timer if it's still active
    }

    hasMadeGuess = true;

    HapticFeedback.lightImpact();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TimedResultsPage(
          goalColor: hashDateToColor(currentDate),
          userColor: selectedColor,
          wasRandom: widget.useRandomDate,
          remainingTime: timeRemaining,
        ),
      ),
    );
  }

  DateTime generateRandomDate() {
    final random = Random();
    final minDate = DateTime(2000, 1, 1);
    final maxDate = DateTime.now();
    final randomDuration =
        Duration(days: random.nextInt(maxDate.difference(minDate).inDays));
    return minDate.add(randomDuration);
  }

  void _showCountdown(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    for (int countdown = 3; countdown > 0; countdown--) {
      overlayEntry = OverlayEntry(
        builder: (context) => Material(
          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
          child: Center(
            child: Text(
              '$countdown',
              style: const TextStyle(
                  fontSize: 120,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      overlayState.insert(overlayEntry);
      await Future.delayed(Duration(seconds: 1));
      overlayEntry.remove();
    }

    _startGameTimer();
  }

  void _startGameTimer() {
    timer = Timer(const Duration(seconds: 20), makeGuess);

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (timeRemaining < 1) {
          t.cancel(); // If time runs out, cancel the timer
          makeGuess(); // and automatically make a guess
        } else {
          if (mounted) {
            // Check if the widget is still in the widget tree
            setState(() {
              timeRemaining--; // Else, decrement the remaining time
            });
          }
        }
      },
    );
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
          padding: const EdgeInsets.all(10),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$timeRemaining',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                SplitColoredBoxWidget(
                  userColor: selectedColor,
                  goalColor: color,
                ),
                const SizedBox(height: 8),
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
                    onPressed: makeGuess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text("Make Guess"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel(); // cancel the timer when the widget is disposed
    super.dispose();
  }
}
