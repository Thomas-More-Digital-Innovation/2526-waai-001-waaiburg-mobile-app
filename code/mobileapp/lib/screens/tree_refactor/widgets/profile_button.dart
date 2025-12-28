import 'package:flutter/material.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool hasSeenAvatarScreen = false;

  Future<bool> getHasSeenAvatarScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasSeenAvatarScreen") ?? false;
  }

  void setHasSeenAvatarScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasSeenAvatarScreen", true);
  }

  @override
  void initState() {
    super.initState();
    getHasSeenAvatarScreen().then((value) => setState(() => hasSeenAvatarScreen = value));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(56, 56), shape: const CircleBorder(), padding: EdgeInsets.zero),
      onPressed: () {
        if (!hasSeenAvatarScreen) {
          setHasSeenAvatarScreen();
        }

        context.push(AppRoutes.avatar);
      },
      child: ClipOval(
        child: Transform.translate(
          offset: const Offset(0, 22),
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
