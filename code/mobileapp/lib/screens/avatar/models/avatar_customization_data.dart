import 'package:flutter/material.dart';

/// Data class for avatar customization options
class AvatarCustomizationData {
  static const List<String> categories = [
    'Lichaam',
    'T-shirt',
    'Broek',
    'Haar',
    'Extra',
  ];

  static const List<Color> skinColors = [
    Color(0xFFFFD7B5), // Light
    Color(0xFFE0AC69), // Medium
    Color(0xFFC68642), // Tan
    Color(0xFF8D5524), // Dark
    Color(0xFF3D2817), // Really Dark/Deep Brown
    Color(0xFFFFE135), // Yellow
    Color(0xFFFFB6C1), // Pink
    Color(0xFF7CFC00), // Green
    Color(0xFF4A90E2), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF9B59B6), // Purple
    Color(0xFFFFA500), // Orange
  ];

  static const List<Color> shirtColors = [
    Color(0xFF4A90E2), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFF34495E), // Dark Gray
    Colors.white,
    Colors.black,
  ];

  static const List<Color> pantsColors = [
    Color(0xFF2C3E50), // Dark Blue
    Color(0xFF34495E), // Gray
    Colors.black,
    Color(0xFF3498DB), // Blue
    Color(0xFF27AE60), // Green
    Color(0xFF8E44AD), // Purple
  ];

  static const List<Color> hairColors = [
    Color(0xFF5D4037), // Brown
    Color(0xFF1A1A1A), // Black
    Color(0xFFFFEB3B), // Blonde
    Color(0xFFE53935), // Red
    Color(0xFF9E9E9E), // Gray
    Color(0xFFFF6F00), // Orange
  ];

  static const List<String> shirtLabels = [
    'Korte Mouwen',
    'Hoodie',
    'Stijl 2',
    'Stijl 3',
    'Stijl 4',
  ];

  static const List<String> pantsLabels = [
    'Korte Broek',
    'Lange Broek',
    'Stijl 2',
    'Stijl 3',
  ];

  static const List<String> hairLabels = [
    'Stijl 0',
    'Stijl 1',
    'Stijl 2',
    'Stijl 3',
    'Stijl 4',
  ];

  static final List<AccessoryOption> accessories = [
    AccessoryOption(id: null, name: 'Geen', icon: Icons.close),
    AccessoryOption(id: 0, name: 'Bril 1', icon: Icons.remove_red_eye),
    AccessoryOption(id: 1, name: 'Bril 2', icon: Icons.visibility),
    AccessoryOption(id: 2, name: 'Hoed', icon: Icons.face),
    AccessoryOption(id: 3, name: 'Cap', icon: Icons.sports_baseball),
    AccessoryOption(id: 4, name: 'Oorbellen', icon: Icons.circle_outlined),
    AccessoryOption(id: 5, name: 'Ketting', icon: Icons.horizontal_rule),
  ];

  static const int shirtStyleCount = 5;
  static const int pantsStyleCount = 4;
  static const int hairStyleCount = 5;
}

/// Model for accessory options
class AccessoryOption {
  final int? id;
  final String name;
  final IconData icon;

  const AccessoryOption({
    required this.id,
    required this.name,
    required this.icon,
  });
}
