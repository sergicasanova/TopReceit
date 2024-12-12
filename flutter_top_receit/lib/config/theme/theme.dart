import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

class AppTheme {
  final bool useMaterial3;
  int selectedColor;
  final bool isDarkmode;
  final String fontFamily;

  AppTheme({
    this.useMaterial3 = true,
    this.selectedColor = 0,
    this.isDarkmode = false,
    this.fontFamily = 'Roboto',
  });

  ThemeData getTheme() => ThemeData(
        useMaterial3: useMaterial3,
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: colorList[selectedColor],
        appBarTheme: AppBarTheme(
          color: colorList[selectedColor],
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.getFont(fontFamily)
              .copyWith(color: Colors.black, fontSize: 20),
        ),
        scaffoldBackgroundColor: isDarkmode ? Colors.black : Colors.white,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.getFont(fontFamily).copyWith(
              fontSize: 45, color: isDarkmode ? Colors.white : Colors.black),
          bodyLarge: GoogleFonts.getFont(fontFamily).copyWith(
              fontSize: 18,
              color: isDarkmode ? Colors.white70 : Colors.black87),
        ),
      );
}
