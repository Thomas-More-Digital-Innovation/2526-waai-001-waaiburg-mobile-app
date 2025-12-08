import 'package:flutter/material.dart';

class CompletionMessage extends StatelessWidget {
  const CompletionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 85),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Proficiat!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3855a2),
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    "Je hebt alle vragen ingevuld,\nje boom is nu volgroeid.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3855a2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
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
