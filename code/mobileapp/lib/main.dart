import 'package:flutter/material.dart';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:mobileapp/config/theme.dart';

void main() {
  cacheData();
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: appRouter,
    ),
  );
}
