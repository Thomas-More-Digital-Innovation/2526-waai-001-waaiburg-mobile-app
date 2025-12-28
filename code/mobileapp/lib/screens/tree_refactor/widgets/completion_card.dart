import 'package:flutter/material.dart';

class CompletionCard extends StatelessWidget {
  const CompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Je hebt alle vragen ingevuld, je boom is nu volgroeid!\nKijk gerust terug naar je antwoorden",
          style: TextStyle(color: Theme.of(context).colorScheme.onTertiary, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
