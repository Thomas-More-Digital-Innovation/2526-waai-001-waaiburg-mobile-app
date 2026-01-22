import 'package:flutter/material.dart';
import 'package:mobileapp/config/env.dart' as tree_constants;
import 'package:mobileapp/shared/widgets/page_content_loading_indicator.dart';

class TreeLoadingWidget extends StatelessWidget {
  const TreeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            tree_constants.treeLoadingPath,
            fit: BoxFit.cover,
          ),
        ),
        PageContentLoadingIndicator(color: Theme.of(context).colorScheme.secondary)
      ],
    );
  }
}
