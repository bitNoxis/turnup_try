import 'package:flutter/material.dart';

class OurTheme {
  final Color _lightGreen = Color.fromARGB(255, 213, 235, 220);
  final Color _lightGrey = Color.fromARGB(255, 164, 164, 164);
  final Color _darkeyGrey = Color.fromARGB(255, 199, 124, 135);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: _lightGreen,
      primaryColor: _lightGreen,
      accentColor: _lightGrey,
      secondaryHeaderColor: _darkeyGrey,
      hintColor: _lightGrey,
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: _lightGrey,
              ),
          ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: _lightGreen,
          ),
        ),
      ),
    );

  }
}
