import 'package:flutter/material.dart';

/// Reusable style picker widget for clothing and hair
class StylePicker extends StatelessWidget {
  final int count;
  final int currentStyle;
  final Function(int) onStyleSelected;
  final List<String> labels;
  final String partType;
  final String directory;
  final List<int>? bodyIds;
  final List<String>? customFileNames;

  const StylePicker({
    super.key,
    required this.count,
    required this.currentStyle,
    required this.onStyleSelected,
    required this.labels,
    required this.partType,
    required this.directory,
    this.bodyIds,
    this.customFileNames,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        itemBuilder: (context, index) {
          final isSelected = currentStyle == index;
          
          String assetPath;
          if (customFileNames != null) {
            // Use custom file name (e.g., "pants_2_male")
            assetPath = 'assets/avatar/$directory/${customFileNames![index]}.png';
          } else if (bodyIds != null) {
            // Use body ID mapping
            final actualId = bodyIds![index];
            assetPath = 'assets/avatar/$directory/${partType}_$actualId.png';
          } else {
            // Default: use index
            assetPath = 'assets/avatar/$directory/${partType}_$index.png';
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => onStyleSelected(index),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PNG Preview
                    SizedBox(
                      height: 80,
                      child: Image.asset(
                        assetPath,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        colorBlendMode: BlendMode.modulate,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.checkroom,
                            size: 40,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
