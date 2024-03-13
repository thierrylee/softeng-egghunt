import 'package:flutter/material.dart';

abstract class ThemeFactory {
  static const Color _blueMainColor = Color(0xff06224e);

  static const Color _whiteFontColor = Color(0xffffffff);

  static const Color _lightPrimaryColor = _blueMainColor;
  static const Color _lightSecondaryColor = Color(0xff355fff);
  static const Color _lightSurfaceColor = Color(0xffc3daec);

  static const Color _darkPrimaryColor = Color(0xff00d0da);
  static const Color _darkSecondaryColor = Color(0xffffc107);
  static const Color _darkSurfaceColor = Color(0xff30486e);

  static ThemeData buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: _blueMainColor,
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        surface: _lightSurfaceColor,
        onSurface: _blueMainColor,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: _blueMainColor,
        foregroundColor: _whiteFontColor,
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _blueMainColor,
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        surface: _darkSurfaceColor,
        onSurface: _whiteFontColor,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: _blueMainColor,
        foregroundColor: _whiteFontColor,
      ),
    );
  }
}
