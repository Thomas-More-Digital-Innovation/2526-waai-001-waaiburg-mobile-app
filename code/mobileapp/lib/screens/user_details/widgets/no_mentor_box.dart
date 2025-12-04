import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoMentorBox extends StatelessWidget {
  const NoMentorBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(
                FontAwesomeIcons.user,
                color: Theme.of(context).colorScheme.secondary,
                size: 17,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                "Begeleider",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Geen begeleider gekoppeld!",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
