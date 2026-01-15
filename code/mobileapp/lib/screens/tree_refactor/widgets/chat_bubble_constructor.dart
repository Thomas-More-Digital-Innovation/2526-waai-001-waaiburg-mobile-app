import 'package:flutter/material.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble.dart';

class ChatBubbleConstructor extends StatelessWidget {
  final Map<Question, Answer?> questionAnswerMap;
  final ScrollController scrollController;

  const ChatBubbleConstructor({
    super.key,
    required this.questionAnswerMap,
    required this.scrollController,
    this.onEditAnswer,
  });

  final Function(Question, Answer)? onEditAnswer;

  @override
  Widget build(BuildContext context) {
    return ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        children: () {
          List<Widget> children = [];

          for (var entry in questionAnswerMap.entries) {
            children.add(ChatBubble(text: entry.key.content, isUser: false));
            if (entry.value != null) {
              children.add(ChatBubble(
                text: entry.value!.answer,
                isUser: true,
                onEdit: onEditAnswer != null ? () => onEditAnswer!(entry.key, entry.value!) : null,
              ));
            } else {
              break;
            }
          }

          return children;
        }());
  }
}
