import 'dart:math';

import 'package:flutter/material.dart';
import 'package:colour/models/hash_date_to_color.dart';
import 'package:colour/views/colored_box_widget.dart';
import 'package:colour/views/color_selector_widget.dart';
import 'package:colour/views/results_page.dart';

class GameView extends StatefulWidget {
  final bool useRandomDate;

  const GameView({Key? key, this.useRandomDate = false}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Color selectedColor = Colors.black;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    currentDate = widget.useRandomDate ? generateRandomDate() : DateTime.now();
  }

  DateTime generateRandomDate() {
    final random = Random();
    final minDate = DateTime(2000, 1, 1);
    final maxDate = DateTime.now();
    final randomDuration =
        Duration(days: random.nextInt(maxDate.difference(minDate).inDays));
    return minDate.add(randomDuration);
  }

  @override
  Widget build(BuildContext context) {
    Color color = hashDateToColor(currentDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text('Colour Guesser'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ColoredBoxWidget(
              color: color,
            ),
            ColorPicker(
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            Text(
              selectedColor.toString(),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsPage(
                        goalColor: color,
                        userColor: selectedColor,
                      ),
                    ),
                  );
                },
                child: const Text("Make Guess"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
