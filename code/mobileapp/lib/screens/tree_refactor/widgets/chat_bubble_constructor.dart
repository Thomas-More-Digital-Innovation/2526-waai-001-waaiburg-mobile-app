import 'package:flutter/material.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble.dart';

class ChatBubbleConstructor extends StatelessWidget {
  final Map<Question, Answer?> questionAnswerMap;
  final bool loadingNextQuestion;
  const ChatBubbleConstructor({super.key, required this.questionAnswerMap, required this.loadingNextQuestion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: () {
          List<Widget> children = [];
          for (var entry in questionAnswerMap.entries) {
            children.add(ChatBubble(text: entry.key.content, isUser: false));
            if (entry.value == null) {
              break;
            }
            children.add(ChatBubble(text: entry.value!.answer, isUser: true));
          }
          if (loadingNextQuestion) {
            children.add(ChatBubble(text: '...', isUser: false));
          }
          return children;
        }(),
      ),
    );
  }
}
