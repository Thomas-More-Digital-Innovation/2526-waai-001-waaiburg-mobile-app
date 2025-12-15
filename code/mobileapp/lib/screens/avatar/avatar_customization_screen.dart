import 'package:flutter/material.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/screens/avatar/widgets/avatar_widget.dart';
import 'package:mobileapp/screens/avatar/widgets/color_picker_grid.dart';
import 'package:mobileapp/screens/avatar/widgets/style_picker.dart';
import 'package:mobileapp/screens/avatar/widgets/accessory_picker.dart';
import 'package:mobileapp/screens/avatar/models/avatar_customization_data.dart';
import 'package:mobileapp/screens/avatar/utils/color_utils.dart';
import 'package:mobileapp/shared/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AvatarCustomizationScreen extends StatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  State<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> {
  late AvatarConfiguration _currentConfig;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _loadAvatarConfig();
  }

  Future<void> _loadAvatarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString('avatar_config');

    setState(() {
      if (configJson != null) {
        _currentConfig = AvatarConfiguration.fromJson(jsonDecode(configJson));
      } else {
        _currentConfig = const AvatarConfiguration();
      }
    });
  }

  Future<void> _saveAvatarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_config', jsonEncode(_currentConfig.toJson()));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Avatar opgeslagen!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _updateSkinColor(Color color) {
    setState(() {
      _currentConfig =
          _currentConfig.copyWith(skinColor: ColorUtils.colorToHex(color));
    });
  }

  void _updateShirtStyle(int style) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(shirtId: style);
    });
  }

  void _updateShirtColor(Color color) {
    setState(() {
      _currentConfig =
          _currentConfig.copyWith(shirtColor: ColorUtils.colorToHex(color));
    });
  }

  void _updatePantsStyle(int style) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(pantsId: style);
    });
  }

  void _updatePantsColor(Color color) {
    setState(() {
      _currentConfig =
          _currentConfig.copyWith(pantsColor: ColorUtils.colorToHex(color));
    });
  }

  void _updateHairStyle(int style) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(hairId: style);
    });
  }

  void _updateHairColor(Color color) {
    setState(() {
      _currentConfig =
          _currentConfig.copyWith(hairColor: ColorUtils.colorToHex(color));
    });
  }

  void _updateAccessory(int? accessoryId) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(accessoryId: accessoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: Text('Pas je avatar aan'),
      ),
      body: Column(
        children: [
          // Avatar preview
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            child: Center(
              child: AvatarWidget(
                config: _currentConfig,
                size: 200,
                showBorder: true,
              ),
            ),
          ),

          // Category tabs
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AvatarCustomizationData.categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategory == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(AvatarCustomizationData.categories[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Options grid
          Expanded(
            child: AvatarOptionsGrid(
              selectedCategory: _selectedCategory,
              currentConfig: _currentConfig,
              onSkinColorUpdate: _updateSkinColor,
              onShirtStyleUpdate: _updateShirtStyle,
              onShirtColorUpdate: _updateShirtColor,
              onPantsStyleUpdate: _updatePantsStyle,
              onPantsColorUpdate: _updatePantsColor,
              onHairStyleUpdate: _updateHairStyle,
              onHairColorUpdate: _updateHairColor,
              onAccessoryUpdate: _updateAccessory,
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAvatarConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Opslaan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarOptionsGrid extends StatelessWidget {
  final int selectedCategory;
  final AvatarConfiguration currentConfig;
  final Function(Color) onSkinColorUpdate;
  final Function(int) onShirtStyleUpdate;
  final Function(Color) onShirtColorUpdate;
  final Function(int) onPantsStyleUpdate;
  final Function(Color) onPantsColorUpdate;
  final Function(int) onHairStyleUpdate;
  final Function(Color) onHairColorUpdate;
  final Function(int?) onAccessoryUpdate;

  const AvatarOptionsGrid({
    super.key,
    required this.selectedCategory,
    required this.currentConfig,
    required this.onSkinColorUpdate,
    required this.onShirtStyleUpdate,
    required this.onShirtColorUpdate,
    required this.onPantsStyleUpdate,
    required this.onPantsColorUpdate,
    required this.onHairStyleUpdate,
    required this.onHairColorUpdate,
    required this.onAccessoryUpdate,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedCategory) {
      case 0:
        return ColorPickerGrid(
          colors: AvatarCustomizationData.skinColors,
          currentColor: ColorUtils.hexToColor(currentConfig.skinColor),
          onColorSelected: onSkinColorUpdate,
        );

      case 1:
        return _StyleAndColorSection(
          styleCount: AvatarCustomizationData.shirtStyleCount,
          currentStyle: currentConfig.shirtId,
          onStyleSelected: onShirtStyleUpdate,
          labels: AvatarCustomizationData.shirtLabels,
          partType: 'shirt',
          directory: 'shirts',
          colors: AvatarCustomizationData.shirtColors,
          currentColor: ColorUtils.hexToColor(currentConfig.shirtColor),
          onColorSelected: onShirtColorUpdate,
        );

      case 2:
        return _StyleAndColorSection(
          styleCount: AvatarCustomizationData.pantsStyleCount,
          currentStyle: currentConfig.pantsId,
          onStyleSelected: onPantsStyleUpdate,
          labels: AvatarCustomizationData.pantsLabels,
          partType: 'pants',
          directory: 'pants',
          colors: AvatarCustomizationData.pantsColors,
          currentColor: ColorUtils.hexToColor(currentConfig.pantsColor),
          onColorSelected: onPantsColorUpdate,
        );

      case 3:
        return _StyleAndColorSection(
          styleCount: AvatarCustomizationData.hairStyleCount,
          currentStyle: currentConfig.hairId,
          onStyleSelected: onHairStyleUpdate,
          labels: AvatarCustomizationData.hairLabels,
          partType: 'hair',
          directory: 'hair',
          colors: AvatarCustomizationData.hairColors,
          currentColor: ColorUtils.hexToColor(currentConfig.hairColor),
          onColorSelected: onHairColorUpdate,
        );

      case 4:
        return AccessoryPicker(
          currentAccessoryId: currentConfig.accessoryId,
          onAccessorySelected: onAccessoryUpdate,
        );

      default:
        return Container();
    }
  }
}

class _StyleAndColorSection extends StatelessWidget {
  final int styleCount;
  final int currentStyle;
  final Function(int) onStyleSelected;
  final List<String> labels;
  final String partType;
  final String directory;
  final List<Color> colors;
  final Color currentColor;
  final Function(Color) onColorSelected;

  const _StyleAndColorSection({
    required this.styleCount,
    required this.currentStyle,
    required this.onStyleSelected,
    required this.labels,
    required this.partType,
    required this.directory,
    required this.colors,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Kies een stijl:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        StylePicker(
          count: styleCount,
          currentStyle: currentStyle,
          onStyleSelected: onStyleSelected,
          labels: labels,
          partType: partType,
          directory: directory,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Kies een kleur:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ColorPickerGrid(
            colors: colors,
            currentColor: currentColor,
            onColorSelected: onColorSelected,
          ),
        ),
      ],
    );
  }
}
