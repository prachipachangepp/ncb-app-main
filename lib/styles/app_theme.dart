import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ncbColor = Color(0xffe41f2c);

  static ThemeData getDarkTheme({required double fontSizeMultiplier}) {
    return ThemeData.from(
      colorScheme: ColorScheme.dark(
        primary: ncbColor,
        onPrimary: Colors.white,
        secondary: ncbColor,
        surface: Colors.grey[900]!,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      textTheme: getTextTheme(fontSizeMultiplier: fontSizeMultiplier)
          .apply(bodyColor: Colors.white),
    );
  }

  static ThemeData getTheme({required double fontSizeMultiplier}) {
    return ThemeData.from(
      colorScheme: ColorScheme.light(
        primary: ncbColor,
        secondary: ncbColor,
        background: Colors.grey[100]!,
      ),
      textTheme: getTextTheme(fontSizeMultiplier: fontSizeMultiplier),
    );
  }

  static TextTheme getTextTheme({required double fontSizeMultiplier}) {
    return GoogleFonts.rubikTextTheme(
      m2TextTheme().apply(fontSizeFactor: fontSizeMultiplier),
    );
  }

  static TextTheme m2TextTheme() {
    return TextTheme(
      headline1: buildHeadline1(),
      headline2: buildHeadline2(),
      headline3: buildHeadline3(),
      headline4: buildHeadline4(),
      headline5: buildHeadline5(),
      headline6: buildHeadline6(),
      subtitle1: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.15,
      ),
      subtitle2: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.1,
      ),
      bodyText1: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
      bodyText2: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      ),
      button: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.25,
      ),
      caption: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
      ),
      overline: const TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.5,
      ),
    );
  }

  static TextStyle buildHeadline6() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    );
  }

  static TextStyle buildHeadline5() {
    return const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.0,
    );
  }

  static TextStyle buildHeadline4() {
    return const TextStyle(
      fontSize: 34.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    );
  }

  static TextStyle buildHeadline3() {
    return const TextStyle(
      fontSize: 48.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.0,
    );
  }

  static TextStyle buildHeadline2() {
    return const TextStyle(
      fontSize: 60.0,
      fontWeight: FontWeight.w200,
      letterSpacing: -0.5,
    );
  }

  static TextStyle buildHeadline1() {
    return const TextStyle(
      fontSize: 96.0,
      fontWeight: FontWeight.w200,
      letterSpacing: -1.5,
    );
  }

  static TextTheme m3TextTheme() {
    return TextTheme(
      displayLarge: buildDisplayLarge(),
      displayMedium: buildDisplayMedium(),
      displaySmall: buildDisplaySmall(),
      headlineLarge: buildHeadlineLarge(),
      headlineMedium: buildHeadlineMedium(),
      headlineSmall: buildHeadlineSmall(),
      titleLarge: buildTitleLarge(),
      titleMedium: buildTitleMedium(),
      titleSmall: buildTitleSmall(),
      labelLarge: buildLabelLarge(),
      labelMedium: const TextStyle(
        height: 16,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: const TextStyle(
        height: 16,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: const TextStyle(
        height: 24,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: const TextStyle(
        height: 20,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: const TextStyle(
        height: 16,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static TextStyle buildLabelLarge() {
    return const TextStyle(
      height: 20,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buildTitleSmall() {
    return const TextStyle(
      height: 20,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buildTitleMedium() {
    return const TextStyle(
      height: 24,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buildTitleLarge() {
    return const TextStyle(
      height: 28,
      fontSize: 22,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildHeadlineSmall() {
    return const TextStyle(
      height: 32,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildHeadlineMedium() {
    return const TextStyle(
      height: 36,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildHeadlineLarge() {
    return const TextStyle(
      height: 40,
      fontSize: 32,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildDisplaySmall() {
    return const TextStyle(
      height: 44,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildDisplayMedium() {
    return const TextStyle(
      height: 52,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buildDisplayLarge() {
    return const TextStyle(
      height: 64,
      fontSize: 57,
      fontWeight: FontWeight.w400,
    );
  }
}
