import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);

  final Widget title;
  final Color? bgColor;
  final Color? titleColor;
  const Header({required this.title, this.bgColor, this.titleColor, super.key});

  @override
  Widget build(BuildContext context) {
    final titleColor = this.titleColor ?? Theme.of(context).colorScheme.secondary;
    return AppBar(
      title: title,
      centerTitle: true,
      elevation: 0,
      backgroundColor: bgColor ?? Colors.grey[50],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: titleColor,
          weight: 0.9,
        ),
        iconSize: 32,
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 32),
    );
  }
}
