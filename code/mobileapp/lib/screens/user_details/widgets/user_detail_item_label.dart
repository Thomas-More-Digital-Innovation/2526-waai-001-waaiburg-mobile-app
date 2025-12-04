import 'package:flutter/material.dart';

class UserDetailItemLabel extends StatelessWidget {
  final String label;
  final String value;

  const UserDetailItemLabel(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
