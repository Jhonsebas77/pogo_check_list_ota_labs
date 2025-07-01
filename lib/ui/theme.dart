import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.greenAccent,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  useMaterial3: true,
);

final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.catching_pokemon);
      }
      return const Icon(Icons.catching_pokemon);
    });
