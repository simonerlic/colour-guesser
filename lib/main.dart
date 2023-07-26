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

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  Future<void> _playGame(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayed = prefs.getString('lastPlayed');

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastPlayed != null) {
      final lastPlayedDate = DateTime.parse(lastPlayed);
      if (lastPlayedDate == todayDate) {
        // The game has already been played today.
        // Show a dialog or another kind of message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Already Played"),
            content: Text("You've already played today. Come back tomorrow!"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        // The game hasn't been played today.
        prefs.setString('lastPlayed', todayDate.toIso8601String());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameView()),
        );
      }
    } else {
      // The game has never been played before.
      prefs.setString('lastPlayed', todayDate.toIso8601String());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameView()),
      );
    }
  }

  Future<void> _resetDate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final nullDate = DateTime(1970, 01, 01);

    prefs.setString('lastPlayed', nullDate.toIso8601String());
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
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: <Widget>[
                ElevatedButton(
                  child: Text('Play daily game'),
                  onPressed: () {
                    _playGame(context);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  child: Text('Info'),
                  onPressed: () {
                    // Navigate to Info Page
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  child: Text('Debug: Reset day'),
                  onPressed: () {
                    _resetDate(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
