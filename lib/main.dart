import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colour/models/hash_date_to_color.dart';
import 'package:colour/views/game_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colour Guesser',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: hashDateToColor(DateTime.now())),
        useMaterial3: true,
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
      hasPlayedDailyChallenge =
          lastPlayed != null && DateTime.parse(lastPlayed) == todayDate;
    });

    if (!hasPlayedDailyChallenge) {
      setNextDailyChallengeTimer();
    }
  }

  void setNextDailyChallengeTimer() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final nextDailyChallengeTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0);
    final timeUntilNextDailyChallenge =
        nextDailyChallengeTime.difference(DateTime.now());

    if (timeUntilNextDailyChallenge.isNegative) {
      // If by any chance the current time is already after the next daily challenge time, try again for the next day.
      setNextDailyChallengeTimer();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (DateTime.now().isAfter(nextDailyChallengeTime)) {
            // Reset the state to reflect the new daily challenge.
            checkIfDailyChallengePlayed();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _playGame(BuildContext context, bool useRandomDate) async {
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
        if (!useRandomDate) {
          hasPlayedDailyChallenge = true;
        }
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
    prefs.setString('lastPlayed', nullDate.toIso8601String());
    setState(() {
      hasPlayedDailyChallenge = false;
    });

    Future<void> showClearedDateDialog() async {
      await showDialog(
        builder: (context) => AlertDialog(
          title: const Text("Cleared Date"),
          content: const Text("Thanks for testing :)"),
          actions: [
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
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
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Colour Guesser",
                style: Theme.of(context).textTheme.headline5),
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
                    child: const Text('Random Challenge'),
                    onPressed: () {
                      _playGame(context, true);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      _resetDate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bug_report),
                        SizedBox(width: 8),
                        Text('Reset day'),
                      ],
                    ),
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
