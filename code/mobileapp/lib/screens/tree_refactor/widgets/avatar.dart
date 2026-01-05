import 'package:flutter/material.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapp/screens/tree_refactor/logic/avatar_tooltip_controller.dart';

class Avatar extends StatefulWidget {
  final Function() callback;
  const Avatar({super.key, required this.callback});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool hasSeenAvatarScreen = false;
  final AvatarTooltipController _controller = AvatarTooltipController();

  Future<void> _checkHasSeen() async {
    final shouldShow = await _controller.shouldShowTooltip();
    if (mounted) {
      setState(() {
        // if tooltip IS showing (shouldShow=true), then we haven't seen it (hasSeen=false)
        hasSeenAvatarScreen = !shouldShow;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkHasSeen();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(56, 56), shape: const CircleBorder(), padding: EdgeInsets.zero),
      onPressed: () {
        if (!hasSeenAvatarScreen) {
          _controller.markTooltipAsSeen();
        }

        context.push(AppRoutes.avatar).then((value) => widget.callback());
      },
      child: ClipOval(
        child: Transform.translate(
          offset: const Offset(0, 22),
          child: Transform.scale(
            scale: 2.5,
            child: Image.asset(
              'assets/avatar/bodies/body_0.png',
            ),
          ),
        ),
      ),
    );
  }
}
