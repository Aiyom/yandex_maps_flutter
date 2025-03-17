import 'package:yandex_maps/map/resources/typography.dart';
import 'package:flutter/material.dart';

final class MapkitFlutterTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: const Color(0xFF5CD8D2),
      onSecondary: const Color(0xFF5CD8D2).withOpacity(0.7),
      tertiary: const Color(0xFF5CD8D2),
      onTertiary: Colors.grey,
      error: Colors.red,
      onError: Colors.redAccent,
      background: Colors.white,
      onBackground: Colors.black38,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    textTheme: MapkitFlutterTypography.textTheme,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: const Color(0xFF5CD8D2),
      onSecondary: const Color(0xFF5CD8D2).withOpacity(0.7),
      tertiary: Colors.white,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.redAccent,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.grey[850]!,
      onSurface: Colors.white,
    ),
    textTheme: MapkitFlutterTypography.textTheme,
  );
}