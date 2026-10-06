import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pogo_check_list_ota_labs/core/constants/constants.dart';
import 'package:pogo_check_list_ota_labs/core/enums/enums.dart';
import 'package:pogo_check_list_ota_labs/ui/theme.dart';
import 'package:pogo_check_list_ota_labs/ui/widgets/widgets.dart';

const double aaText = 4.5;

void expectContrast(Color foreground, Color background, String label) {
  double ratio = contrastRatio(foreground, background);
  expect(
    ratio,
    greaterThanOrEqualTo(aaText),
    reason: '$label: ${ratio.toStringAsFixed(2)}:1',
  );
}

void main() {
  test('primary color is kept as every screen background', () {
    expect(primaryColor, const Color.fromRGBO(198, 73, 52, 1));
    for (ThemeData theme in <ThemeData>[appTheme, appDarkTheme]) {
      expect(theme.colorScheme.primary, primaryColor);
      expect(theme.scaffoldBackgroundColor, primaryColor);
      expect(theme.appBarTheme.backgroundColor, primaryColor);
    }
  });

  for (MapEntry<String, ThemeData> entry in <String, ThemeData>{
    'light': appTheme,
    'dark': appDarkTheme,
  }.entries) {
    test('${entry.key} color scheme pairs reach AA', () {
      ColorScheme c = entry.value.colorScheme;
      Map<String, List<Color>> pairs = <String, List<Color>>{
        'onPrimary/primary': <Color>[c.onPrimary, c.primary],
        'onSecondary/secondary': <Color>[c.onSecondary, c.secondary],
        'onTertiary/tertiary': <Color>[c.onTertiary, c.tertiary],
        'onError/error': <Color>[c.onError, c.error],
        'onSurface/surface': <Color>[c.onSurface, c.surface],
        'onSurfaceVariant/surfaceContainerHighest': <Color>[
          c.onSurfaceVariant,
          c.surfaceContainerHighest,
        ],
        'onPrimaryContainer/primaryContainer': <Color>[
          c.onPrimaryContainer,
          c.primaryContainer,
        ],
        'onSecondaryContainer/secondaryContainer': <Color>[
          c.onSecondaryContainer,
          c.secondaryContainer,
        ],
        'onTertiaryContainer/tertiaryContainer': <Color>[
          c.onTertiaryContainer,
          c.tertiaryContainer,
        ],
        'onErrorContainer/errorContainer': <Color>[
          c.onErrorContainer,
          c.errorContainer,
        ],
        'onInverseSurface/inverseSurface': <Color>[
          c.onInverseSurface,
          c.inverseSurface,
        ],
        'white/scaffold background': <Color>[
          Colors.white,
          entry.value.scaffoldBackgroundColor,
        ],
        'lucky accent/surfaceContainerHighest': <Color>[
          if (c.brightness == Brightness.dark)
            luckyAccentColor
          else
            luckyAccentLightColor,
          c.surfaceContainerHighest,
        ],
      };
      for (MapEntry<String, List<Color>> pair in pairs.entries) {
        expectContrast(
          pair.value[0],
          pair.value[1],
          '${entry.key} ${pair.key}',
        );
      }
    });

    test('${entry.key} muted text on primary + black12 reaches AA', () {
      Color primary = entry.value.colorScheme.primary;
      Color container = Color.alphaBlend(Colors.black12, primary);
      expectContrast(
        Color.alphaBlend(onPrimaryMuted, container),
        container,
        '${entry.key} onPrimaryMuted',
      );
    });
  }

  test('snackbar backgrounds reach AA with white', () {
    for (SnackbarType type in SnackbarType.values) {
      expectContrast(Colors.white, backgroundColorType(type), type.name);
    }
  });

  test('type colors get a readable foreground', () {
    kTypeColors.forEach((String type, Color color) {
      expectContrast(readableOn(color), color, type);
      // Badges paint the type color at 90 % over the surface.
      for (Color surface in <Color>[Colors.white, Colors.black]) {
        Color badge = Color.alphaBlend(color.withValues(alpha: 0.9), surface);
        expectContrast(readableOn(badge), badge, '$type badge');
      }
    });
  });
}
