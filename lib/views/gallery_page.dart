import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colour/models/game_result.dart';
import 'package:colour/views/widgets/split_colored_box.dart';
import 'package:colour/views/past_results_page.dart';
import 'package:intl/intl.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<GameResult>? _gameResults;

  @override
  void initState() {
    super.initState();
    _getGameResults();
  }

  Future<void> _getGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedResults = prefs.getStringList('gameResults');

    if (savedResults != null) {
      List<GameResult> gameResults = savedResults.map<GameResult>((resultData) {
        // Adjust this part according to how you are serializing and deserializing GameResult objects
        return GameResult.fromMap(jsonDecode(resultData));
      }).toList();

      setState(() {
        _gameResults = gameResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: _gameResults == null
          ? const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("No results yet"),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _gameResults!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // change this number to adjust the number of items in a row
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PastResultsPage(
                                goalColor: _gameResults![index].actualColor,
                                userColor: _gameResults![index].guessedColor,
                                guessDate: DateFormat.yMMMd()
                                    .format(_gameResults![index].date),
                              ),
                            ),
                          );
                        },
                        child: SplitColoredBoxWidget(
                          goalColor: _gameResults![index].actualColor,
                          userColor: _gameResults![index].guessedColor,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().format(_gameResults![index].date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
