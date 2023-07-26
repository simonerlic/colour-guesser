import 'package:flutter/material.dart';

class SplitColoredBoxWidget extends StatefulWidget {
  final Color goalColor;
  final Color userColor;

  const SplitColoredBoxWidget(
      {required this.goalColor, required this.userColor});

  @override
  _SplitColoredBoxWidgetState createState() => _SplitColoredBoxWidgetState();
}

class _SplitColoredBoxWidgetState extends State<SplitColoredBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.goalColor, // Use the "goal" color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.userColor, // Use the user's selected color
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
