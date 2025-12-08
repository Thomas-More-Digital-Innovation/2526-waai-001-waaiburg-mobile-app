/// Constants for the Tree of Life feature
class TreeConstants {
  /// Tree state names mapped to asset file names
  static const Map<int, String> treeStates = {
    0: 'begin',
    1: 'zaadje',
    2: 'stam',
    3: 'takken',
    4: 'bladeren',
    5: 'appels',
    6: 'vogels',
    7: 'last',
  };

  /// Base path for tree assets
  static const String assetBasePath = 'assets/tree_of_life';

  /// Get the image path for a given state
  static String getImagePath(int state) {
    return '$assetBasePath/${treeStates[state]}.png';
  }

  /// Get the video path for a given state
  static String getVideoPath(int state) {
    return '$assetBasePath/${treeStates[state]}.mp4';
  }

  /// Maximum tree state index
  static const int maxTreeState = 6;

  /// Minimum tree state index
  static const int minTreeState = 0;
}
