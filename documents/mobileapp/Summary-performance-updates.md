# Waaiburg Mobile App Performance updates

**Focus areas**: performance/stability, UI/UX, architecture/best practices, functionality, testing/tooling.

## Highlights

- Rebuilt and shipped the refactored “Tree of Life” experience as the primary flow (new UI, editable answers, avatar tooltip/icon, keyboard-safe layout).
- Improved loading states, caching, and memory usage across news/info segments and video playback.
- Migrated navigation to `go_router`, restructured the project to Flutter best practices, and separated models from API DTOs.
- Enhanced home/login/user details screens and avatar/profile flows; fixed routing gaps and added tests/tooling hygiene.

## Performance & Stability

- Fixed video player memory leak in legacy tree screen (`lib/screens/tree/tree_home.dart`).
- Added caching and larger cache for info segments/news buttons; ensured images cache correctly (`lib/api/cache.dart`, `lib/shared/widgets/column_button.dart`, `main.dart`).
- Made loading indicators reliable in news/info pages and shared loaders (`lib/screens/news/news.dart`, `lib/shared/widgets/page_content_progress_indicator.dart`).
- Prevented stray animations and ensured layout resizes only the keyboard/Q&A region on mobile (`lib/screens/tree_refactor/tree_new.dart`).

## UI/UX Improvements

- **Tree of Life refactor**: new layout, chat bubbles, input container with states, editable answers, avatar tooltip (click-to-dismiss), dynamic avatar icon selection, shrunk home icon, keyboard-aware resizing (`lib/screens/tree_of_life/**`).
- Placed chat bubbles from the same growth stage on the same screen, replicating a real chat-app while providing better user experience.
- Home/login tweaks: logout button placement fix, login button layout update, button widgets, theme-driven colors (`lib/screens/home/home.dart`, `lib/screens/login/login_page.dart`).
- User details page restructure with dedicated widgets (`lib/screens/user_details/user_details.dart` and widgets folder).
- Loading/back-button UX: updated loaders and header back icon; clearer progress indicators.
- Avatar flows: fixed missing avatar customization route and base asset path; added profile/avatar button tooling (tooltip, dismiss tap, reset visibility changes).

## Architecture & Best Practices

- Migrated navigation to `go_router` and centralized routes/env config (`lib/config/routes.dart`, `lib/config/env.dart`).
- Restructured codebase into `screens/`, `shared/`, `config/`, `model/` per Flutter conventions; renamed/moved widgets accordingly.
- Abstracted models away from API DTOs (`lib/model/qna.dart`, `section.dart`, `user.dart`, `info_segment.dart`, etc.).
- Added analyzer rules/cleanup and formatting fixes (`analysis_options.yaml`, `pubspec.yaml`); removed unused imports.
- Consolidated base avatar path as `const`; removed legacy tree implementation once the refactor shipped.

## Functionality Improvements

- New Tree of Life implementation set as default; editable Q&A, avatar tooltip/profile interactions, dynamic avatar icon selection, video/player loading states.
- Info/news flows: reload support, caching, themed colors, larger/better progress indicators; fixed navigation buttons and visibility issues in Tree growth flow.
- Fixed login state refresh and avatar customization routing; ensured logout dialog and button placement; added shared-preference check for avatar view state.

## Testing & Tooling

- Added initial test suite (API and home widget tests) and pruned default widget test (`test/function/api_test.dart`, `test/widgets/home_not_logged_in_test.dart`).
- Sonar/project hygiene: updated `sonar-project.properties`, improved `.gitignore`, removed placeholder build step from CI workflow.
- Gradle/Flutter 3.35 migration and dependency housekeeping (`android/*`, `macos/GeneratedPluginRegistrant.swift`, `pubspec.yaml`).
