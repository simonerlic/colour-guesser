import 'package:flutter/material.dart';

class ColoredBoxWidget extends StatelessWidget {
  final Color color;

  const ColoredBoxWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 10,
          ),
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
