import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinishTutorialPage extends StatelessWidget {
  const FinishTutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Text(
                'You\'re all set!',
                style: TextStyle(fontSize: 24),
                // center text
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Congrats on finishing the tutorial.\nYou\'re now ready to play the game!',
              ),
              const SizedBox(height: 16),
              const Text(
                'This tutorial will always be available on the "Practice" tab if you need to come back to it.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Good luck, and have fun!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Thanks!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
