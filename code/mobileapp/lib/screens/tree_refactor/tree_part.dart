import 'package:mobileapp/config/env.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';

const Map<int, String> treeStates = {
  0: 'begin',
  1: 'zaadje',
  2: 'stam',
  3: 'takken',
  4: 'bladeren',
  5: 'appels',
  6: 'vogels',
};

String getImagePath(int state) {
  return '$assetBasePath/${treeStates[state]}.png';
}

String getVideoPath(int state) {
  return '$assetBasePath/${treeStates[state]}.mp4';
}

final int maxTreeState = treeStates.length - 1;
const int minTreeState = 0;

Map<Question, Answer?> parseQnaToMap(List<Question> questions, List<Answer> answers, int treePartId) {
  Map<Question, Answer?> map = {};
  for (Question question in questions) {
    if (question.treePartId != treePartId) continue;
    map[question] = null;
    for (Answer answer in answers) {
      if (answer.questionId == question.id) {
        map[question] = answer;
        break;
      }
    }
  }
  return map;
}

List<TreePart> generateTreeParts(List<Question> questions, List<Answer> answers) {
  List<TreePart> treeParts = [];
  for (int i = minTreeState; i <= maxTreeState; i++) {
    treeParts.add(TreePart(id: i, imagePath: getImagePath(i), videoPath: getVideoPath(i), questionAnswerMap: parseQnaToMap(questions, answers, i + 1)));
  }
  return treeParts;
}

Question? getNextQuestion(Map<Question, Answer?> questionAnswerMap) {
  for (Question question in questionAnswerMap.keys) {
    if (questionAnswerMap[question] == null) return question;
  }
  return null;
}

int? getUnansweredTreePart(List<TreePart> treeParts) {
  for (TreePart treePart in treeParts) {
    if (!treePart.allQuestionsAnswered) return treePart.id;
  }
  return null;
}
