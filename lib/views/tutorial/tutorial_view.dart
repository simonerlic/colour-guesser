import 'package:flutter/material.dart';
import 'package:colour/views/tutorial/slider_tutorial_view.dart';

class TutorialView extends StatelessWidget {
  const TutorialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Text(
                'This tutorial will go over a little bit of the fundamentals of colour and the game itself.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Press the button below to start the tutorial.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: ElevatedButton(
                  child: const Text('Let\'s go!'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SliderTutorialView()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
