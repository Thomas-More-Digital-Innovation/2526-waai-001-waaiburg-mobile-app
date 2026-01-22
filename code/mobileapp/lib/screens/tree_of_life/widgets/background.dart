import 'package:flutter/material.dart';
import 'package:mobileapp/screens/tree_of_life/tree_constants.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class TreeBackground extends StatefulWidget {
  final VideoPlayerController? activeTransitionController;
  final Map<int, VideoPlayerController> videoControllers;
  final int currentState;
  final int? targetState;
  final bool isPlayingTransition;

  const TreeBackground({
    super.key,
    required this.activeTransitionController,
    required this.videoControllers,
    required this.currentState,
    this.targetState,
    required this.isPlayingTransition,
  });

  @override
  State<TreeBackground> createState() => _TreeBackgroundState();
}

class _TreeBackgroundState extends State<TreeBackground> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadVideos();
      _preloadImages();
    });
  }

  @override
  void dispose() {
    for (var controller in widget.videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _preloadVideos() async {
    for (var i = TreeConstants.minTreeState; i <= TreeConstants.maxTreeState; i++) {
      try {
        final controller = VideoPlayerController.asset(TreeConstants.getVideoPath(i));
        await controller.initialize();
        widget.videoControllers[i] = controller;
      } catch (e) {
        debugPrint("Error preloading video for state $i: $e");
      }
    }
  }

  Future<void> _preloadImages() async {
    for (var i = TreeConstants.minTreeState; i <= TreeConstants.maxTreeState; i++) {
      try {
        await precacheImage(AssetImage(TreeConstants.getImagePath(i)), context);
      } catch (e) {
        debugPrint("Error preloading image for state $i: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1 (Bottom): Target Image (Pre-render destination)
        if (widget.targetState != null)
          Positioned.fill(
            child: Image.asset(
              TreeConstants.getImagePath(widget.targetState!),
              fit: BoxFit.cover,
            ),
          ),

        // Layer 2 (Middle): Current Image (ALWAYS visible to prevent holes)
        Positioned.fill(
          child: Image.asset(
            TreeConstants.getImagePath(widget.currentState),
            fit: BoxFit.cover,
          ),
        ),

        // Layer 3 (Top): Video Transition
        if (widget.isPlayingTransition && widget.activeTransitionController != null)
          Positioned.fill(
            child: VideoPlayerWidget(controller: widget.activeTransitionController!),
          ),
      ],
    );
  }
}
