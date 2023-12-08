import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.dark,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // ···
  ),
);
