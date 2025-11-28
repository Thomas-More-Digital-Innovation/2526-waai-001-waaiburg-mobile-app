import 'package:flutter/material.dart';
import 'package:mobileapp/shared/widgets/column_button.dart';
import 'package:mobileapp/config/theme.dart';

class ColumnButtonListView extends StatelessWidget {
  final List list;
  final void Function(int id, String title) onItemTap;

  const ColumnButtonListView({
    super.key,
    required this.list,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: list.asMap().entries.map(
        (entry) {
          final int index = entry.key;
          final info = entry.value;

          if (info.titleImage != null) {
            return ColumnImageButton(
              color: Theme.of(context).colorScheme.surface,
              label: info.titleImage!,
              infoId: info.id,
              onTap: () => onItemTap(info.id, info.title),
            );
          } else {
            return ColumnTextButton(
              color: getColumnButtonColor(index),
              label: info.title,
              infoId: info.id,
              onTap: () => onItemTap(info.id, info.title),
            );
          }
        },
      ).toList(),
    );
  }
}
