import 'package:flutter/foundation.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';
import 'package:mobileapp/screens/tree_of_life/tree_part.dart';

class InputLogic {
  /// Background sync that preserves optimistic updates
  /// Only updates answers that have been confirmed by the API (have real IDs)
  Future<List<TreePart>> syncWithApi(List<TreePart> currentParts) async {
    try {
      List<dynamic> apiData = await fetchQuestionList();
      List<TreePart> apiTreeParts = generateTreeParts(apiData[0], apiData[1]);

      List<TreePart> mergedParts = List.from(currentParts);

      // Merge API data with local optimistic updates
      // Keep local answers with temporary IDs (-1), update with API answers
      for (int i = 0; i < mergedParts.length && i < apiTreeParts.length; i++) {
        final localPart = mergedParts[i];
        final apiPart = apiTreeParts[i];

        Map<Question, Answer?> mergedMap = {};
        for (var entry in localPart.questionAnswerMap.entries) {
          final question = entry.key;
          final localAnswer = entry.value;

          Answer? apiAnswer;
          for (var apiEntry in apiPart.questionAnswerMap.entries) {
            if (apiEntry.key.id == question.id) {
              apiAnswer = apiEntry.value;
              break;
            }
          }

          if (apiAnswer != null) {
            mergedMap[question] = apiAnswer;
          } else if (localAnswer != null) {
            mergedMap[question] = localAnswer;
          } else {
            mergedMap[question] = null;
          }
        }

        mergedParts[i] = TreePart(
          id: localPart.id,
          imagePath: localPart.imagePath,
          videoPath: localPart.videoPath,
          questionAnswerMap: mergedMap,
        );
      }

      return mergedParts;
    } catch (e) {
      debugPrint('Background sync failed: $e');
      return currentParts;
    }
  }

  /// Determines if all questions in the entire tree are answered
  bool isTreeCompleted(List<TreePart> parts) {
    for (var part in parts) {
      for (var entry in part.questionAnswerMap.entries) {
        if (entry.value == null) return false;
      }
    }
    return true;
  }

  /// Helper to get the next unanswered question for the current state
  Question? getNextQuestionForState(TreePart part) {
    return getNextQuestion(part.questionAnswerMap);
  }
}
