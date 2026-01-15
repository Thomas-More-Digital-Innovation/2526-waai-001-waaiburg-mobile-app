import 'package:flutter/material.dart';

/// Reusable color picker grid widget
class ColorPickerGrid extends StatelessWidget {
  final List<Color> colors;
  final Color currentColor;
  final Function(Color) onColorSelected;

  const ColorPickerGrid({
    super.key,
    required this.colors,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        final isSelected = color.toARGB32() == currentColor.toARGB32();

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  )
                : null,
          ),
        );
      },
    );
  }
}
