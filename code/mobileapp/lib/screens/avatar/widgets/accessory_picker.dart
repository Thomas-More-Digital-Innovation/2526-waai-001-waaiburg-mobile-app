import 'package:flutter/material.dart';
import 'package:mobileapp/screens/avatar/models/avatar_customization_data.dart';

class AccessoryPicker extends StatelessWidget {
  final int? currentAccessoryId;
  final Function(int?) onAccessorySelected;

  const AccessoryPicker({
    super.key,
    required this.currentAccessoryId,
    required this.onAccessorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: AvatarCustomizationData.accessories.length,
      itemBuilder: (context, index) {
        final accessory = AvatarCustomizationData.accessories[index];
        final isSelected = currentAccessoryId == accessory.id;

        return GestureDetector(
          onTap: () => onAccessorySelected(accessory.id),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  accessory.icon,
                  size: 40,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 8),
                Text(
                  accessory.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
