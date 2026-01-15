import 'package:flutter/material.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/chat_bubble.dart';

class ChatBubbleClipper extends CustomClipper<Path> {
  final ChatOrigin chatOrigin;

  ChatBubbleClipper({required this.chatOrigin});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (chatOrigin == ChatOrigin.right) {
      path.moveTo(size.width - 22, size.height);
      path.lineTo(17, size.height);
      path.cubicTo(7.6, size.height, 0, size.height - 7.6, 0, size.height - 17);
      path.lineTo(0, 17);
      path.cubicTo(0, 7.6, 7.6, 0, 17, 0);
      path.lineTo(size.width - 27, 0);
      path.cubicTo(size.width - 17.6, 0, size.width - 10, 7.6, size.width - 10, 17);
      path.lineTo(size.width - 10, size.height - 29);
      path.cubicTo(size.width - 10, size.height - 13, size.width, size.height, size.width, size.height);
      path.cubicTo(size.width, size.height, size.width - 20, size.height, size.width - 22, size.height);
    } else {
      path.moveTo(22, size.height);
      path.lineTo(size.width - 17, size.height);
      path.cubicTo(size.width - 7.6, size.height, size.width, size.height - 7.6, size.width, size.height - 17);
      path.lineTo(size.width, 17);
      path.cubicTo(size.width, 7.6, size.width - 7.6, 0, size.width - 17, 0);
      path.lineTo(27, 0);
      path.cubicTo(17.6, 0, 10, 7.6, 10, 17);
      path.lineTo(10, size.height - 29);
      path.cubicTo(10, size.height - 13, 0, size.height, 0, size.height);
      path.cubicTo(0, size.height, 20, size.height, 22, size.height);
    }
    return path;
  }

  @override
  bool shouldReclip(ChatBubbleClipper oldClipper) => oldClipper.chatOrigin != chatOrigin;
}
