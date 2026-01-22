class TreeConstants {
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

  static const String assetBasePath = 'assets/tree_of_life';

  static String getImagePath(int state) {
    return '$assetBasePath/${treeStates[state]}.png';
  }

  static String getVideoPath(int state) {
    return '$assetBasePath/${treeStates[state]}.mp4';
  }

  static const int maxTreeState = 6;

  static const int minTreeState = 0;
}
