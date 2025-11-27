import 'package:flutter/material.dart';

class PageContentProgressIndicator extends StatelessWidget {
  const PageContentProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(scale: 1.5, child: const CircularProgressIndicator()),
    );
  }
}
