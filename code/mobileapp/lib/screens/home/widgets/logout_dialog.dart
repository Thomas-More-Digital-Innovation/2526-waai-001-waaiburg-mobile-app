import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('Uitloggen', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text('Weet je zeker dat je wilt uitloggen?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Annuleren', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Uitloggen', style: TextStyle(color: Theme.of(context).colorScheme.onError)),
            ),
          ],
        ),
      ) ??
      false;
}
