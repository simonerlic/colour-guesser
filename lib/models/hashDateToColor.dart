import 'package:flutter/material.dart';

int jenkinsHash(int value) {
  value = ((value + 0x7ed55d16) + (value << 12)) & 0xffffffff;
  value = ((value ^ 0xc761c23c) ^ (value >> 19)) & 0xffffffff;
  value = ((value + 0x165667b1) + (value << 5)) & 0xffffffff;
  value = ((value + 0xd3a2646c) ^ (value << 9)) & 0xffffffff;
  value = ((value + 0xfd7046c5) + (value << 3)) & 0xffffffff;
  value = ((value ^ 0xb55a4f09) ^ (value >> 16)) & 0xffffffff;
  return value;
}

Color hashDateToColor(DateTime date) {
  int year = date.year;
  int month = date.month;
  int day = date.day;

  int numericalValue = (year * 10000) + (month * 100) + day;

  int hash = jenkinsHash(numericalValue);

  int redChannel = (hash & 0xFF);
  int greenChannel = ((hash >> 8) & 0xFF);
  int blueChannel = ((hash >> 16) & 0xFF);

  print("R: $redChannel");
  print("G: $greenChannel");
  print("B: $blueChannel");

  return Color.fromARGB(255, redChannel, greenChannel, blueChannel);
}
