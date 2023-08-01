import 'package:flutter/material.dart';

class ColoredBoxWidget extends StatefulWidget {
  final Color color;

  const ColoredBoxWidget({super.key, required this.color});

  @override
  _ColoredBoxWidgetState createState() => _ColoredBoxWidgetState();
}

class _ColoredBoxWidgetState extends State<ColoredBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: widget.color, // Use the color from the widget's state
          // shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
