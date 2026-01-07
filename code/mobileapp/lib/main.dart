import 'package:flutter/material.dart';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/config/env.dart' as tree_constants;
import 'package:mobileapp/config/routes.dart';
import 'package:mobileapp/config/theme.dart';

void main() {
  cacheData();
  final app = MaterialApp.router(
    debugShowCheckedModeBanner: false,
    theme: theme,
    routerConfig: appRouter,
    builder: (context, child) {
      // Precache the tree loading image (non-blocking)
      precacheImage(AssetImage(tree_constants.treeLoadingPath), context);
      return child ?? const SizedBox.shrink();
    },
  );

  runApp(app);
}
