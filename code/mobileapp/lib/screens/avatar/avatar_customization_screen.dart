import 'package:flutter/material.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/screens/avatar/widgets/avatar_widget.dart';
import 'package:mobileapp/screens/avatar/widgets/color_picker_grid.dart';
import 'package:mobileapp/screens/avatar/widgets/style_picker.dart';
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

  void _updateBodyType(int type) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(bodyType: type);
    });
  }

  void _updateGender(String gender) {
    setState(() {
      // When gender changes, reset bodyType to first option for that gender
      final newBodyType = AvatarCustomizationData.genderBodyMap[gender]![0];
      _currentConfig = _currentConfig.copyWith(
        gender: gender,
        bodyType: newBodyType,
      );
    });
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

  void _updateShoesStyle(int style) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(shoesId: style);
    });
  }

  void _updateShoesColor(Color color) {
    setState(() {
      _currentConfig =
          _currentConfig.copyWith(shoesColor: ColorUtils.colorToHex(color));
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
              onGenderUpdate: _updateGender,
              onBodyTypeUpdate: _updateBodyType,
              onSkinColorUpdate: _updateSkinColor,
              onShirtStyleUpdate: _updateShirtStyle,
              onShirtColorUpdate: _updateShirtColor,
              onPantsStyleUpdate: _updatePantsStyle,
              onPantsColorUpdate: _updatePantsColor,
              onShoesStyleUpdate: _updateShoesStyle,
              onShoesColorUpdate: _updateShoesColor,
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
  final Function(String) onGenderUpdate;
  final Function(int) onBodyTypeUpdate;
  final Function(Color) onSkinColorUpdate;
  final Function(int) onShirtStyleUpdate;
  final Function(Color) onShirtColorUpdate;
  final Function(int) onPantsStyleUpdate;
  final Function(Color) onPantsColorUpdate;
  final Function(int) onShoesStyleUpdate;
  final Function(Color) onShoesColorUpdate;

  const AvatarOptionsGrid({
    super.key,
    required this.selectedCategory,
    required this.currentConfig,
    required this.onGenderUpdate,
    required this.onBodyTypeUpdate,
    required this.onSkinColorUpdate,
    required this.onShirtStyleUpdate,
    required this.onShirtColorUpdate,
    required this.onPantsStyleUpdate,
    required this.onPantsColorUpdate,
    required this.onShoesStyleUpdate,
    required this.onShoesColorUpdate,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedCategory) {
      case 0:
        // Gender selection
        return _GenderSelection(
          currentGender: currentConfig.gender,
          onGenderSelected: onGenderUpdate,
        );

      case 1:
        // Body type selection (gender-specific)
        final bodyOptions = AvatarCustomizationData.genderBodyMap[currentConfig.gender]!;
        final bodyLabels = AvatarCustomizationData.genderBodyLabels[currentConfig.gender]!;
        final currentBodyIndex = bodyOptions.indexOf(currentConfig.bodyType);
        
        return _StyleAndColorSection(
          styleCount: bodyOptions.length,
          currentStyle: currentBodyIndex >= 0 ? currentBodyIndex : 0,
          onStyleSelected: (index) => onBodyTypeUpdate(bodyOptions[index]),
          labels: bodyLabels,
          partType: 'body',
          directory: 'bodies',
          colors: AvatarCustomizationData.skinColors,
          currentColor: ColorUtils.hexToColor(currentConfig.skinColor),
          onColorSelected: onSkinColorUpdate,
          bodyIds: bodyOptions,
        );

      case 2:
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
          customFileNames: AvatarCustomizationData.genderShirtFiles[currentConfig.gender]!,
        );

      case 3:
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
          customFileNames: AvatarCustomizationData.genderPantsFiles[currentConfig.gender]!,
        );

      case 4:
        return _StyleAndColorSection(
          styleCount: AvatarCustomizationData.shoesStyleCount,
          currentStyle: currentConfig.shoesId ?? 0,
          onStyleSelected: onShoesStyleUpdate,
          labels: AvatarCustomizationData.shoesLabels,
          partType: 'shoes',
          directory: 'shoes',
          colors: AvatarCustomizationData.shoesColors,
          currentColor: ColorUtils.hexToColor(currentConfig.shoesColor),
          onColorSelected: onShoesColorUpdate,
        );

      default:
        return Container();
    }
  }
}

class _GenderSelection extends StatelessWidget {
  final String currentGender;
  final Function(String) onGenderSelected;

  const _GenderSelection({
    required this.currentGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kies je geslacht:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GenderCard(
                  label: 'Man',
                  icon: Icons.person,
                  isSelected: currentGender == 'male',
                  onTap: () => onGenderSelected('male'),
                ),
                _GenderCard(
                  label: 'Vrouw',
                  icon: Icons.person_outline,
                  isSelected: currentGender == 'female',
                  onTap: () => onGenderSelected('female'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[300]!,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
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
  final List<int>? bodyIds;
  final List<String>? customFileNames;

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
    this.bodyIds,
    this.customFileNames,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ValueKey('${partType}_scroll'), // Reset scroll position when category changes
      child: Column(
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
            bodyIds: bodyIds,
            customFileNames: customFileNames,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Kies een kleur:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 400, // Fixed height for color grid
            child: ColorPickerGrid(
              colors: colors,
              currentColor: currentColor,
              onColorSelected: onColorSelected,
            ),
          ),
        ],
      ),
    );
  }
}
