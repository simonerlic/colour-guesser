import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colour/models/hash_date_to_color.dart';
import 'package:colour/views/game_view.dart';
import 'package:colour/views/gallery_page.dart';
import 'package:colour/models/game_result.dart';
import 'package:colour/views/tutorial/tutorial_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chromanigma',
      theme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme:
            ColorScheme.fromSeed(seedColor: hashDateToColor(DateTime.now())),
        useMaterial3: true,

        // Define the default TextTheme. Use Lexend-Regular for the body and Lexend-Medium for the title.
        textTheme: const TextTheme(
          bodySmall:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w400),
          headlineMedium:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500),
        ),
      ),
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
    final now = DateTime.now();
    final nextDay =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    final difference = nextDay.difference(now);

    timer = Timer(difference, () {
      checkIfDailyChallengePlayed();
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
          content:
              const Text("You've already played today. Come back tomorrow!"),
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
            Text("Chromanigma",
                // Use Lexend-Medium for the title
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 50),
            Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      _playGame(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasPlayedDailyChallenge ? Colors.grey.shade200 : null,
                      foregroundColor:
                          hasPlayedDailyChallenge ? Colors.grey.shade500 : null,
                    ),
                    child: const Text('Daily Challenge'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    child: const Text('Practice Challenge'),
                    onPressed: () {
                      _playGame(context, true);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryPage()),
                      );
                    },
                    onLongPress: () {
                      _resetDate(context);
                      GameResult.clearGameResults();
                    },
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
