import 'package:flutter/material.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble.dart';

class ChatBubbleConstructor extends StatelessWidget {
  final Map<Question, Answer?> questionAnswerMap;
  final ScrollController scrollController; // Add this

  const ChatBubbleConstructor({
    super.key,
    required this.questionAnswerMap,
    required this.scrollController, // Pass it in
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController, // Attach the controller
      padding: const EdgeInsets.all(8.0),
      children: [
        for (var entry in questionAnswerMap.entries) ...[
          ChatBubble(text: entry.key.content, isUser: false),
          if (entry.value != null) ChatBubble(text: entry.value!.answer, isUser: true),
        ],
      ],
    );
  }
}
