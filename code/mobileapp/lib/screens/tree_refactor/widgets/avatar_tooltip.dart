import 'package:flutter/material.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble.dart';

class AvatarTooltip extends StatelessWidget {
  const AvatarTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width / 2;
    return Positioned(
      bottom: 240,
      right: 120,
      child: GestureDetector(
        onTap: () {},
        child: ChatBubble(
          flipChatOrigin: true,
          maxWidth: maxWidth,
          isUser: false,
          text: 'Wist je dat je mij kunt aanpassen? Klik rechtsboven aan het scherm om mijn stijl aan te passen.',
        ),
      ),
    );
  }
}
