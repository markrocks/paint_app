import 'package:flutter/material.dart';

class AppConstants {
  // Brush sizes
  static const double smallBrushSize = 5.0;
  static const double mediumBrushSize = 25.0;
  static const double largeBrushSize = 40.0;

  // You can add more constants here as needed
  static const double defaultOpacity = 1.0;
  static const double paintbrushOpacity = 0.1;
  static const double crayonOpacity = 0.1;

  // Color palette
  static const List<Color> defaultColors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.pink,
    Colors.teal,
  ];

  // Load screen time in seconds
  static const int loadScreenDuration = 1; // or whatever duration you want
}
