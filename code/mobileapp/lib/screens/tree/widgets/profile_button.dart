import 'package:flutter/material.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:go_router/go_router.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: const CircleBorder(), padding: EdgeInsets.zero),
      onPressed: () {
        context.push(AppRoutes.avatar);
      },
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
