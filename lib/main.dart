import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:colour/views/game_view.dart';
import 'package:colour/views/gallery_page.dart';
import 'package:colour/views/tutorial/tutorial_view.dart';
import 'package:colour/views/widgets/countdown_timer.dart';
import 'package:colour/models/game_result.dart';
import 'package:colour/models/hash_date_to_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prismatic',
      theme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(
            seedColor: hashDateToColor(DateTime.now()),
            brightness: Brightness.light),
        useMaterial3: true,

        // Define the default TextTheme. Use Lexend-Regular for the body and Lexend-Medium for the title.
        textTheme: const TextTheme(
          bodySmall:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w400),
          headlineMedium:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(
            seedColor: hashDateToColor(DateTime.now()),
            brightness: Brightness.dark),
        useMaterial3: true,

        // Define the default TextTheme. Use Lexend-Regular for the body and Lexend-Medium for the title.
        textTheme: const TextTheme(
          bodySmall:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w400),
          headlineMedium:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500),
          // Colour to be a tinted version of the primary colour
        ),
      ),
      themeMode: ThemeMode.system,
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool hasPlayedDailyChallenge = false;
  Timer? timer;
  Duration? timeLeftUntilNextDay;

  @override
  void initState() {
    super.initState();
    checkIfDailyChallengePlayed();
    checkIfTutorialPlayed();
  }

  @override
  void didUpdateWidget(StartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkIfDailyChallengePlayed();
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

  Future<void> checkIfTutorialPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final tutorialPlayed = prefs.getBool('tutorialPlayed');

    if (tutorialPlayed == null || !tutorialPlayed) {
      prefs.setBool('tutorialPlayed', true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TutorialPage(),
        ),
      );
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an info button to the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TutorialPage()),
              );
            },
          ),
        ],
        // hide the back button
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_mosaic_rounded,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text("Prismatic",
                    // Use Lexend-Medium for the title
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 8),
            if (hasPlayedDailyChallenge)
              CountdownTimer(initialDuration: timeLeftUntilNextDay!),
            const SizedBox(height: 50),
            Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playGame(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          // theme colour, but with 20% opacity if the daily challenge has been played
                          hasPlayedDailyChallenge
                              ? Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.2)
                              : Theme.of(context).colorScheme.background,
                      foregroundColor: hasPlayedDailyChallenge
                          ? Colors.grey.shade500
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text('Daily Challenge'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _playGame(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text('Practice Challenge'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryPage()),
                      );
                    },
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      _resetDate(context);
                      GameResult.clearGameResults();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text('Past Daily Challenges'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
