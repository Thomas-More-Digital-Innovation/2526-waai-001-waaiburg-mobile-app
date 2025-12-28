import 'package:go_router/go_router.dart';
import 'package:mobileapp/screens/home/home.dart';
import 'package:mobileapp/screens/login/login_page.dart';
import 'package:mobileapp/screens/info_content_select.dart';
import 'package:mobileapp/screens/info_segments.dart';
import 'package:mobileapp/screens/info_contents.dart';
import 'package:mobileapp/screens/news/news.dart';
import 'package:mobileapp/screens/tree/tree_home.dart';
import 'package:mobileapp/screens/tree_refactor/tree_new.dart';
import 'package:mobileapp/screens/user_details.dart';
import 'package:mobileapp/screens/avatar/avatar_customization_screen.dart';

/// Route paths as constants to avoid typos and enable autocomplete
abstract class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String news = '/news';
  static const String treeHome = '/tree';
  static const String treeNew = '/tree_new'; // TODO: remove after refactoring
  static const String userDetails = '/user';
  static const String avatar = '/avatar';

  // Info routes with parameters
  static const String infoSegments = '/info/:sectionId';
  static const String infoContents = '/info/:sectionId/contents/:infoId';
  static const String infoContentSelect = '/content/:infoId';

  static String infoSegmentsPath(int sectionId) => '/info/$sectionId';
  static String infoContentsPath(int sectionId, int infoId, {String? title}) {
    final base = '/info/$sectionId/contents/$infoId';
    if (title != null) {
      return Uri(path: base, queryParameters: {'title': title}).toString();
    }
    return base;
  }

  static String infoContentSelectPath(int infoId, {String? title}) {
    final base = '/content/$infoId';
    if (title != null) {
      return Uri(path: base, queryParameters: {'title': title}).toString();
    }
    return base;
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.news,
      builder: (context, state) => const News(),
    ),
    GoRoute(
      path: AppRoutes.treeHome,
      builder: (context, state) => const TreeHome(),
    ),
    GoRoute(
      path: AppRoutes.userDetails,
      builder: (context, state) => const UserDetails(),
    ),
    GoRoute(
      path: AppRoutes.avatar,
      builder: (context, state) => const AvatarCustomizationScreen(),
    ),
    GoRoute(
      path: '/info/:sectionId',
      builder: (context, state) {
        final sectionId = int.parse(state.pathParameters['sectionId']!);
        return InfoSegments(sectionId: sectionId);
      },
      routes: [
        GoRoute(
          path: 'contents/:infoId',
          builder: (context, state) {
            final infoId = int.parse(state.pathParameters['infoId']!);
            final title = state.uri.queryParameters['title'];
            return InfoContents(infoId: infoId, title: title);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/content/:infoId',
      builder: (context, state) {
        final infoId = int.parse(state.pathParameters['infoId']!);
        final title = state.uri.queryParameters['title'];
        return InfoContentSelected(infoId: infoId, title: title);
      },
    ),
    GoRoute(
      // TODO: rename after refactoring
      path: AppRoutes.treeNew,
      builder: (context, state) => const TreeNew(),
    ),
  ],
);
