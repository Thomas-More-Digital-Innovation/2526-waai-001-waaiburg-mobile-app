import 'package:flutter/material.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/bubble_clipper.dart';

enum ChatOrigin {
  left,
  right,
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool flipChatOrigin;
  final double maxWidth;
  final VoidCallback? onEdit;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.flipChatOrigin = false,
    this.maxWidth = 280,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    ChatOrigin chatOrigin = flipChatOrigin ? (isUser ? ChatOrigin.left : ChatOrigin.right) : (isUser ? ChatOrigin.right : ChatOrigin.left);
    return Align(
      alignment: chatOrigin == ChatOrigin.right ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          if (onEdit != null && isUser) {
            onEdit!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipPath(
            clipper: ChatBubbleClipper(chatOrigin: chatOrigin),
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: EdgeInsets.fromLTRB(
                chatOrigin == ChatOrigin.right ? 10 : 20,
                10,
                chatOrigin == ChatOrigin.right ? 20 : 10,
                10,
              ),
              color: isUser ? const Color(0xFFE7FFDB) : Colors.white, // WhatsApp-like colors
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null && isUser)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
