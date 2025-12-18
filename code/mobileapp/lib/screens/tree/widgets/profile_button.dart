import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: const CircleBorder(), padding: EdgeInsets.zero),
      onPressed: () {},
      child: ClipOval(
        child: Transform.translate(
          offset: const Offset(0, 20),
          child: Transform.scale(
            scale: 2.5,
            child: Image.asset(
              'assets/avatar/bodies/body_0.png',
            ),
          ),
        ),
      ),
    );
  }
}
