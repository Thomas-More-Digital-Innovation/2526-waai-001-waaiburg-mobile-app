import 'package:mobileapp/model/qna.dart';

class TreePart {
  final int id;
  final String imagePath;
  final String videoPath;
  final Map<Question, Answer?> questionAnswerMap;

  TreePart({
    required this.id,
    required this.imagePath,
    required this.videoPath,
    required this.questionAnswerMap,
  });

  bool get allQuestionsAnswered => questionAnswerMap.values.every((answer) => answer != null);

  int get unasweredQuestions => questionAnswerMap.values.where((answer) => answer == null).length;

  /// Creates a copy of this TreePart with the given question answered
  TreePart copyWithAnswer(Question question, Answer answer) {
    final newMap = Map<Question, Answer?>.from(questionAnswerMap);
    newMap[question] = answer;
    return TreePart(
      id: id,
      imagePath: imagePath,
      videoPath: videoPath,
      questionAnswerMap: newMap,
    );
  }

  @override
  String toString() {
    return 'TreePart(id: $id, imagePath: $imagePath, videoPath: $videoPath, questionAnswerMap: $questionAnswerMap)';
  }
}
