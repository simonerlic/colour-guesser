import 'package:flutter/material.dart';
import 'package:colour/views/tutorial/matching_tutorial_view.dart';
import 'package:colour/views/color_selector_widget.dart';
import 'package:colour/views/colored_box_widget.dart';

class SliderTutorialView extends StatefulWidget {
  const SliderTutorialView({Key? key}) : super(key: key);

  @override
  _SliderTutorialViewState createState() => _SliderTutorialViewState();
}

class _SliderTutorialViewState extends State<SliderTutorialView> {
  Color selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creating Colours'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text:
                            "There's a lot of theory behind how colours are created, but for now, all you need to know is that each colour is made up of a combination of",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: const <TextSpan>[
                          TextSpan(
                            text: " red",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: ",",
                          ),
                          TextSpan(
                            text: " green",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: ", and",
                          ),
                          TextSpan(
                            text: " blue",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: " values.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Try moving the sliders below to see how the values affect the colours! When you\'re ready, press the "Next" button to continue.',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.60,
                child: ColoredBoxWidget(color: selectedColor),
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
                    MaterialPageRoute(
                        builder: (context) => const MatchingTutorialView()),
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
