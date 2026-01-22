import 'package:go_router/go_router.dart';
import 'package:mobileapp/screens/avatar/avatar_customization_screen.dart';
import 'package:mobileapp/screens/home/home.dart';
import 'package:mobileapp/screens/login/login_page.dart';
import 'package:mobileapp/screens/info_content_select.dart';
import 'package:mobileapp/screens/info_segments.dart';
import 'package:mobileapp/screens/info_contents.dart';
import 'package:mobileapp/screens/news/news.dart';
import 'package:mobileapp/screens/user_details/user_details.dart';
import 'package:mobileapp/screens/tree_of_life/tree_of_life.dart';

/// Route paths as constants to avoid typos and enable autocomplete
abstract class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String news = '/news';
  static const String treeOfLife = '/treeOfLife';
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
      path: AppRoutes.treeOfLife,
      builder: (context, state) => const TreeOfLife(),
    ),
    GoRoute(
      path: AppRoutes.userDetails,
      builder: (context, state) => const UserDetails(),
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
      path: AppRoutes.avatar,
      builder: (context, state) => const AvatarCustomizationScreen(),
    )
  ],
);
