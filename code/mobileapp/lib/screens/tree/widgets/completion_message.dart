import 'package:flutter/material.dart';

class CompletionMessage extends StatelessWidget {
  const CompletionMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 85),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(140),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Proficiat!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Je hebt alle vragen ingevuld,\nje boom is nu volgroeid.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Scroll gerust terug om te kijken wat je \n antwoorden waren tijdens de groei van je boom",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
