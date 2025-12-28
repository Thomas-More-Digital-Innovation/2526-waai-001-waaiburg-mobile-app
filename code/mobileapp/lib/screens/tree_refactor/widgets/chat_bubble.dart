import 'package:flutter/material.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/bubble_clipper.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipPath(
          clipper: ChatBubbleClipper(isUser: isUser),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: EdgeInsets.fromLTRB(
              isUser ? 10 : 20,
              10,
              isUser ? 20 : 10,
              10,
            ),
            color: isUser ? const Color(0xFFE7FFDB) : Colors.white, // WhatsApp-like colors
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
