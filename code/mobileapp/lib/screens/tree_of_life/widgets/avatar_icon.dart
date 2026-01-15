import 'package:flutter/material.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/screens/tree_of_life/logic/avatar_tooltip_controller.dart';

class AvatarIcon extends StatefulWidget {
  final AvatarConfiguration avatarConfiguration;
  final Function() callback;
  const AvatarIcon({super.key, required this.callback, required this.avatarConfiguration});

  @override
  State<AvatarIcon> createState() => _AvatarIconState();
}

class _AvatarIconState extends State<AvatarIcon> {
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
    final avatarPath = 'assets/avatar/bodies/body_${widget.avatarConfiguration.bodyType}.png';
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
              avatarPath,
            ),
          ),
        ),
      ),
    );
  }
}
