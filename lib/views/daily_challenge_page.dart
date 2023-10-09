import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:colour/views/game/game_view.dart';
import 'package:colour/views/game/gallery_page.dart';
import 'package:colour/views/tutorial/tutorial_view.dart';
import 'package:colour/views/widgets/countdown_timer.dart';
import 'package:colour/views/widgets/gamemode_card.dart';

// A page displaying a button to the game view and a button to the gallery page

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({Key? key}) : super(key: key);

  @override
  _DailyChallengePageState createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage>
    with WidgetsBindingObserver {
  bool hasPlayedDailyChallenge = false;
  Timer? timer;
  Duration? timeLeftUntilNextDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkIfDailyChallengePlayed();
    checkIfTutorialPlayed();
  }

  @override
  void didUpdateWidget(DailyChallengePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkIfDailyChallengePlayed();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkIfDailyChallengePlayed();
    }
  }

  Future<void> checkIfTutorialPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final tutorialPlayed = prefs.getBool('tutorialPlayed');

    if (tutorialPlayed == null || !tutorialPlayed) {
      prefs.setBool('tutorialPlayed', true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TutorialView(),
        ),
      );
    }
  }

  Future<void> checkIfDailyChallengePlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayed = prefs.getString('lastPlayed');

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    setState(() {
      hasPlayedDailyChallenge = lastPlayed != null &&
          DateTime.parse(lastPlayed).toUtc().day == todayDate.toUtc().day &&
          DateTime.parse(lastPlayed).toUtc().month == todayDate.toUtc().month &&
          DateTime.parse(lastPlayed).toUtc().year == todayDate.toUtc().year;
    });

    if (!hasPlayedDailyChallenge) {
      setNextDailyChallengeTimer();
    }

    if (hasPlayedDailyChallenge) {
      setNextDailyChallengeTimer();
    }
  }

  void setNextDailyChallengeTimer() {
    timer?.cancel();

    final now = DateTime.now();
    final nextDay =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    timeLeftUntilNextDay = nextDay.difference(now);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final int timeLeftInSecs = timeLeftUntilNextDay?.inSeconds ?? 0;

      setState(() {
        if (timeLeftInSecs > 0) {
          timeLeftUntilNextDay = Duration(seconds: timeLeftInSecs - 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resetDate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final nullDate = DateTime(1970, 01, 01);

    Future<void> showClearedDateDialog() async {
      await showDialog(
        builder: (context) => AlertDialog(
          title: const Text("Cleared Date"),
          content: const Text("Thanks for testing :)"),
          actions: [
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                prefs.setString('lastPlayed', nullDate.toIso8601String());
                prefs.setBool('tutorialPlayed', false);
                setState(() {
                  hasPlayedDailyChallenge = false;
                });
                checkIfTutorialPlayed();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        context: context,
      );
    }

    showClearedDateDialog();
  }

  Future<void> _playGame(BuildContext context, bool useRandomDate) async {
    checkIfDailyChallengePlayed();
    if (hasPlayedDailyChallenge && !useRandomDate) {
      // The game has already been played today.
      // Show a dialog or another kind of message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Already Played"),
          content: const Text(
              "You have already played the daily challenge today.\n\nPlease come back tomorrow to play again."),
          actions: [
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else if (!hasPlayedDailyChallenge && !useRandomDate) {
      // The game hasn't been played today.
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      prefs.setString('lastPlayed', todayDate.toIso8601String());

      // Wait for the game view to complete before updating the state and checking if the daily challenge was played.
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameView(useRandomDate: useRandomDate)),
      );

      // When the game view is closed, update the state and check if the daily challenge was played.
      setState(() {
        hasPlayedDailyChallenge = true;
      });
      checkIfDailyChallengePlayed();
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameView(useRandomDate: useRandomDate)),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an info button to the app bar

        automaticallyImplyLeading: false,
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
                      child: Icon(Icons.tune_rounded,
                          size: 28,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Prismatic",
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
            if (hasPlayedDailyChallenge)
              CountdownTimer(initialDuration: timeLeftUntilNextDay!),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  GamemodeCard(
                    title: 'Play the Daily Challenge',
                    description:
                        'Play the daily challenge and share to see how you stack up with your friends!',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playGame(context, false);
                    },
                    disabled: hasPlayedDailyChallenge,
                    iconData: Icons.play_arrow_rounded,
                  ),
                  const SizedBox(height: 8),
                  GamemodeCard(
                    title: 'View the Gallery',
                    description:
                        'See your past daily challenges and their results!',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryPage()),
                      );
                    },
                    disabled: false,
                    iconData: Icons.photo_library_outlined,
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
