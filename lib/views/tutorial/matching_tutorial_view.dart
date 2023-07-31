import 'package:flutter/material.dart';
import 'package:colour/views/color_selector_widget.dart';
import 'package:colour/views/split_colored_box_widget.dart';

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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "In this game, you'll",
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
                                " try to replicate a colour shown to you by only using the sliders.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Since this is a tutorial, I'll show you the colour as you make it- but normally, you'll only see the colour you've created once you've submitted your guess.",
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
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Text('TODO')),
                  );
                },
              ),
            ],
            // Fill up bottom space
          ),
        ),
      ),
    );
  }
}
