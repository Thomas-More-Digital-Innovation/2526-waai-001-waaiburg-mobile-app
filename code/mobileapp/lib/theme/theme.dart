import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Epilogue',
  colorScheme: colorScheme,
  applyElevationOverlayColor: false,
);

ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF46ae93),
  onPrimary: Colors.white,
  secondary: const Color(0xFF3855a2),
  onSecondary: Colors.white,
  tertiary: const Color(0xFFf9cc3e),
  onTertiary: Colors.white,
  error: Colors.red[100]!,
  onError: Colors.red,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceContainer: Colors.white.withAlpha(64),
  primaryContainer: const Color(0xBBFFFFFF),
  secondaryContainer: const Color(0xFFb1b4dc),
  onSecondaryContainer: Colors.white,
);

List<Color> columnButtonColors = [
  colorScheme.tertiary,
  const Color(0xFFb1b4dc), // TODO put color in color scheme
  colorScheme.secondary,
  colorScheme.primary,
];

Color getColumnButtonColor(int index) {
  return columnButtonColors[index % columnButtonColors.length];
}
