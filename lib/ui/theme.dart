import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryColor = Color.fromRGBO(198, 73, 52, 1);
const Color primaryDarkColor = Color.fromRGBO(198, 73, 52, 1);
const Color secondaryColor = Color.fromRGBO(52, 177, 198, 1);
const Color secondaryDarkColor = Color.fromRGBO(77, 208, 225, 1);
const Color tertiaryColor = Color.fromRGBO(218, 153, 33, 1);
const Color tertiaryDarkColor = Color.fromRGBO(255, 203, 80, 1);
const Color lightErrorColor = Color.fromRGBO(184, 52, 90, 1);
const Color darkErrorColor = Color.fromRGBO(239, 107, 129, 1);

// Foreground for light accents (secondary, tertiary, dark error, light type
// colors). Plain white fails WCAG AA on them.
const Color onLightAccent = Color(0xFF1B1B1B);
// Muted white for secondary text inside black12 containers over the primary
// background (>= 4.5:1). Never use it directly on the primary color.
const Color onPrimaryMuted = Color(0xE6FFFFFF);
// Lucky friends accent: the bright orange only reads on dark surfaces.
const Color luckyAccentColor = Color(0xFFF0913F);
const Color luckyAccentLightColor = Color(0xFF9C4A0E);
// Disabled filled buttons: an opaque, darker shade of the primary color so
// they read as "off" on the primary background and on any surface, while
// keeping the label legible (~7.5:1 with onPrimaryMuted).
const Color disabledButtonBackground = Color(0xFF7A2E22);
const Color disabledButtonForeground = onPrimaryMuted;
// Disabled outlined buttons over the primary background (~3:1).
const Color disabledOutlinedForeground = Colors.white70;
const Color disabledOutlinedBorder = Colors.white38;

Color luckyAccent(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? luckyAccentColor
        : luckyAccentLightColor;

/// WCAG 2.x contrast ratio between two opaque colors (1 to 21).
double contrastRatio(Color a, Color b) {
  double la = a.computeLuminance();
  double lb = b.computeLuminance();
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

/// White when it reaches AA (4.5:1) over [background], otherwise dark.
Color readableOn(Color background) =>
    contrastRatio(Colors.white, background) >= 4.5
        ? Colors.white
        : onLightAccent;

final WidgetStateProperty<BorderSide> _outlinedButtonSide =
    WidgetStateProperty.resolveWith<BorderSide>(
      (Set<WidgetState> states) => BorderSide(
        color:
            states.contains(WidgetState.disabled)
                ? disabledOutlinedBorder
                : Colors.white,
      ),
    );

// --- LIGHT THEME ---
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: onLightAccent,
    tertiary: tertiaryColor,
    onTertiary: onLightAccent,
    error: lightErrorColor,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: disabledButtonBackground,
      disabledForegroundColor: disabledButtonForeground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: primaryColor),
  ),
  // Every screen but the color scheme one sits on the primary color, in both
  // themes, so these components default to white instead of primary.
  scaffoldBackgroundColor: primaryColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: disabledOutlinedForeground,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ).copyWith(side: _outlinedButtonSide),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      disabledBackgroundColor: disabledButtonBackground,
      disabledForegroundColor: disabledButtonForeground,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300),
    ),
  ),
);

// --- DARK THEME ---
final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryDarkColor,
    onPrimary: Colors.white,
    secondary: secondaryDarkColor,
    onSecondary: onLightAccent,
    tertiary: tertiaryDarkColor,
    onTertiary: onLightAccent,
    error: darkErrorColor,
    onError: onLightAccent,
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: disabledButtonBackground,
      disabledForegroundColor: disabledButtonForeground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondaryDarkColor,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: secondaryDarkColor, width: 2),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade300),
  ),
  // Every screen but the color scheme one sits on the primary color, in both
  // themes, so these components default to white instead of primary.
  scaffoldBackgroundColor: primaryColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: disabledOutlinedForeground,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ).copyWith(side: _outlinedButtonSide),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      disabledBackgroundColor: disabledButtonBackground,
      disabledForegroundColor: disabledButtonForeground,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    color: Colors.grey[850],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade800),
    ),
  ),
);

final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.catching_pokemon);
      }
      return const Icon(Icons.catching_pokemon);
    });

SystemUiOverlayStyle getSystemOverlayStyle(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
