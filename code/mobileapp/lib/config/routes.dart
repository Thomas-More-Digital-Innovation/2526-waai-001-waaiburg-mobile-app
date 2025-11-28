import 'package:flutter/material.dart';
import 'package:mobileapp/screens/home/home.dart';
import 'package:mobileapp/screens/login/login_page.dart';
import 'package:mobileapp/screens/info_content_select.dart';
import 'package:mobileapp/screens/info_segments.dart';
import 'package:mobileapp/screens/info_contents.dart';
import 'package:mobileapp/screens/news/news.dart';
import 'package:mobileapp/screens/tree/tree_home.dart';
import 'package:mobileapp/screens/user_details.dart';

/// Route names as constants to avoid typos and enable autocomplete
abstract class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String infoSegment = '/infosegment';
  static const String infoContent = '/infocontent';
  static const String infoContentSelect = '/infocontentselect';
  static const String news = '/news';
  static const String treeHome = '/treehome';
  static const String userDetails = '/userdetails';
}

const String initialRoute = AppRoutes.home;

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.login: (context) => const LoginPage(),
  AppRoutes.infoSegment: (context) => const InfoSegments(),
  AppRoutes.infoContent: (context) => const InfoContents(),
  AppRoutes.infoContentSelect: (context) => const InfoContentSelected(),
  AppRoutes.home: (context) => const Home(),
  AppRoutes.news: (context) => const News(),
  AppRoutes.treeHome: (context) => const TreeHome(),
  AppRoutes.userDetails: (context) => const UserDetails(),
};
