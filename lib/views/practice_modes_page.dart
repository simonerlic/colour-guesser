import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Practice",
          // Use Lexend-Medium for the title
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
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
                    iconData: Icons.timer_rounded,
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
