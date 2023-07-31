import 'package:flutter/material.dart';
import 'package:colour/views/color_selector_widget.dart';
import 'package:colour/views/split_colored_box_widget.dart';

import 'package:colour/views/tutorial/tutorial_results_page.dart';

class MatchingTutorialView extends StatefulWidget {
  const MatchingTutorialView({Key? key}) : super(key: key);

  @override
  _MatchingTutorialViewState createState() => _MatchingTutorialViewState();
}

class _MatchingTutorialViewState extends State<MatchingTutorialView> {
  Color selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Colours'),
      ),
      body: Center(
        child: Padding(
          // only horizontal padding
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "The goal of this game is to",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: const <TextSpan>[
                          TextSpan(
                            text: " blindly",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                " replicate a colour shown to you by only using the sliders.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Since it's a tutorial, I'll show you your colour as you move the sliders. Then, make the guess when you're ready.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.60,
                child: SplitColoredBoxWidget(
                  userColor: selectedColor,
                  goalColor: Colors.lime,
                ),
              ),
              const SizedBox(height: 16),
              ColorPicker(
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialResultsPage(
                          goalColor: Colors.lime,
                          userColor: selectedColor,
                        ),
                      ),
                    );
                  },
                  child: const Text("Make Guess"),
                ),
              ),
            ],
            // Fill up bottom space
          ),
        ),
      ),
    );
  }
}
