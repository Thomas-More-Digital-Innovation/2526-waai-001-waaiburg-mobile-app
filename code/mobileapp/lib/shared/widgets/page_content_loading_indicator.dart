import 'package:flutter/material.dart';

class PageContentLoadingIndicator extends StatelessWidget {
  final Color? color;
  const PageContentLoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
          scale: 1.5,
          child: CircularProgressIndicator(
            color: color ?? Theme.of(context).colorScheme.primary,
          )),
    );
  }
}
