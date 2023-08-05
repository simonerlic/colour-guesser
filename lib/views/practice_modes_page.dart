import 'dart:async';

import 'package:colour/views/tutorial/tutorial_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:colour/views/game/game_view.dart';
import 'package:colour/views/game/timed_game_view.dart';
import 'package:colour/views/widgets/gamemode_card.dart';

// A page displaying a button to the game view and a button to the gallery page

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  Future<void> _playGame(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GameView(useRandomDate: true)),
    );
  }

  Future<void> _playTimedGame(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const TimedGameView(useRandomDate: true)),
    );
  }

  Future<void> _playTutorial(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TutorialView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text(
          //   "Practice",
          //   // Use Lexend-Medium for the title
          //   style: TextStyle(
          //     fontFamily: 'Lexend',
          //     fontWeight: FontWeight.w500,
          //     fontSize: 24.0,
          //   ),
          // ),
          // centerTitle: true,
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(Icons.lightbulb_circle_outlined,
                          size: 28,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Practice",
                      // Use Lexend-Medium for the title
                      style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  GamemodeCard(
                    title: 'Play a Random Challenge',
                    description:
                        'Need more practice? Hone your skills with a random challenge!',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playGame(context);
                    },
                    disabled: false,
                    iconData: Icons.shuffle_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  GamemodeCard(
                    title: 'Play a Timed Challenge',
                    description:
                        'Do you work well under pressure? Test your skills with a timed challenge!',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playTimedGame(context);
                    },
                    disabled: false,
                    iconData: Icons.timer_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  GamemodeCard(
                    title: 'Play the Tutorial',
                    description:
                        'Don\'t know how to play? Learn how to play the game here!',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playTutorial(context);
                    },
                    disabled: false,
                    iconData: Icons.school_outlined,
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
