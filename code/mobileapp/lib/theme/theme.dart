import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Epilogue',
  colorScheme: colorScheme,
  applyElevationOverlayColor: false,
);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF46ae93),
  onPrimary: Colors.white,
  secondary: Color(0xFF3855a2),
  onSecondary: Colors.white,
  tertiary: Color(0xFFf9cc3e),
  onTertiary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
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
