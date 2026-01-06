import 'package:flutter/material.dart';

/// Data class for avatar customization options
class AvatarCustomizationData {
  static const List<String> categories = [
    'Geslacht',
    'Lichaam',
    'T-shirt',
    'Broek',
    'Schoenen',
  ];

  static const List<String> genderOptions = [
    'Man',
    'Vrouw',
  ];

  static const Map<String, List<int>> genderBodyMap = {
    'male': [0, 4, 5],
    'female': [1, 2, 3],
  };

  static const Map<String, List<String>> genderBodyLabels = {
    'male': ['Lichaam 1', 'Lichaam 2', 'Lichaam 3'],
    'female': ['Lichaam 1', 'Lichaam 2', 'Lichaam 3'],
  };

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

  static const List<Color> shoesColors = [
    Colors.black,
    Colors.white,
    Color(0xFF8B4513), // Brown
    Color(0xFF4A90E2), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
  ];

  static const List<String> bodyLabels = [
    'Lichaam 1',
    'Lichaam 2',
    'Lichaam 3',
  ];

  static const List<String> shirtLabels = [
    'T-Shirt',
    'Trui',
    'Hemd',
    'Hoodie',
  ];

  static const Map<String, List<String>> genderShirtFiles = {
    'male': ['shirt_0', 'shirt_1', 'shirt_2_male', 'shirt_3_male'],
    'female': ['shirt_0', 'shirt_1', 'shirt_2_female', 'shirt_3_female'],
  };

  static const List<String> pantsLabels = [
    'Korte Broek',
    'Lange Broek',
    'Lange Broek 2',
    'Lange Broek 3',
  ];

  static const Map<String, List<String>> genderPantsFiles = {
    'male': ['pants_0', 'pants_1', 'pants_2_male', 'pants_3_male'],
    'female': ['pants_0', 'pants_1', 'pants_2_female', 'pants_3_female'],
  };

  static const List<String> shoesLabels = [
    'Sneakers',
    'Laarzen',
  ];

  static const int bodyStyleCount = 3;
  static const int shirtStyleCount = 4;
  static const int pantsStyleCount = 4;
  static const int shoesStyleCount = 2;
}
