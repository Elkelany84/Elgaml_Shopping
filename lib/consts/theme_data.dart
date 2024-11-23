import 'package:flutter/material.dart';

import 'app_colors.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme
            ? AppColors.darkScaffoldColor
            : AppColors.lightScaffoldColor,
        cardColor: isDarkTheme
            ? const Color.fromARGB(255, 13, 6, 37)
            : AppColors.lightCardColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          backgroundColor: isDarkTheme
              ? AppColors.darkScaffoldColor
              : AppColors.lightScaffoldColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ));
  }
}

int blue = 0xFF1307EA;
Color kCOlor1 = Color(blue);
const Color kCOlor2 = Color(0xFFEA1C07);
const Color kCOlor3 = Color(0xFF07EA11);
const Color kCOlor4 = Color(0xFFC3EA07);
const Color kCOlor5 = Color(0xFF0A0707);
const Color kCOlor6 = Color(0xFFEA0773);
const Color kCOlor7 = Color(0xFF07EA7C);
const Color kCOlor8 = Color(0xFFEA7307);
//create grey color
