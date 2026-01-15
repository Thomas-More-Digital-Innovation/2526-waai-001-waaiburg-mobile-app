import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';
import 'package:mobileapp/screens/avatar/widgets/avatar_widget.dart';
import 'package:mobileapp/screens/tree_of_life/tree_part.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/avatar_icon.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/chat_bubble_constructor.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/background.dart';
import 'package:mobileapp/screens/tree_of_life/tree_constants.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/input_container.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/tree_loading.dart';
import 'package:mobileapp/screens/tree_of_life/widgets/avatar_tooltip.dart';
import 'package:mobileapp/screens/tree_of_life/logic/avatar_tooltip_controller.dart';
import 'package:mobileapp/screens/tree_of_life/logic/input_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class TreeOfLife extends StatefulWidget {
  const TreeOfLife({super.key});

  @override
  State<TreeOfLife> createState() => _TreeOfLifeState();
}

class _TreeOfLifeState extends State<TreeOfLife> {
  List<TreePart>? treeParts;
  Map<int, List<Question>>? questionsMap;
  List<Answer>? answersList;
  int _nextTransitionalState = 0;
  int _currentState = 0;
  int? _targetState;
  bool _isPlayingTransition = false;
  bool _initialImageLoaded = false;

  VideoPlayerController? _activeTransitionController;
  bool allQuestionsAnswered = false;

  // Edit State
  Question? _editingQuestion;
  Answer? _editingAnswer;
  AvatarConfiguration _avatarConfig = const AvatarConfiguration();
  bool _showAvatarTooltip = false;
  final AvatarTooltipController _avatarController = AvatarTooltipController();
  final InputLogic _inputLogic = InputLogic();

  final Map<int, VideoPlayerController> _videoControllers = {};

  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadTreeParts().then((_) => initTree());
    loadAvatarConfig();
    _checkAvatarTooltip();
  }

  Future<void> _checkAvatarTooltip() async {
    final shouldShow = await _avatarController.shouldShowTooltip();
    if (mounted) {
      setState(() {
        _showAvatarTooltip = shouldShow;
      });
    }
  }

  Future<void> loadTreeParts() async {
    List<dynamic> futureQuestionAnswerList = await fetchQuestionList();

    treeParts = generateTreeParts(futureQuestionAnswerList[0], futureQuestionAnswerList[1]);
  }

  Future<void> loadAvatarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString('avatar_config');

    if (mounted && configJson != null) {
      setState(() {
        _avatarConfig = AvatarConfiguration.fromJson(jsonDecode(configJson));
      });
    }
  }

  Future<void> initTree() async {
    int? unansweredTreePartIndex = getUnansweredTreePart(treeParts!);

    if (unansweredTreePartIndex == null) {
      setState(() {
        allQuestionsAnswered = true;
      });
      unansweredTreePartIndex = maxTreeState;
    }
    _currentState = unansweredTreePartIndex;
    _nextTransitionalState = unansweredTreePartIndex + 1;

    // Precache the first background image before showing UI
    if (mounted && treeParts != null && treeParts!.isNotEmpty) {
      await precacheImage(AssetImage(treeParts![_currentState].imagePath), context);
      setState(() {
        _initialImageLoaded = true;
      });
    }
  }

  Future<void> _updateTreeState(int newState) async {
    if (_editingQuestion != null) {
      _cancelEdit();
    }
    if (_isPlayingTransition) return;
    if (newState < TreeConstants.minTreeState || newState > TreeConstants.maxTreeState) return;

    final controller = _videoControllers[newState];
    if (controller != null) {
      if (mounted) {
        final bool shouldPlayAnimation = newState >= _nextTransitionalState && !allQuestionsAnswered;

        setState(() {
          _isPlayingTransition = shouldPlayAnimation;
          _targetState = newState;
        });

        if (shouldPlayAnimation) {
          _activeTransitionController = controller;
          await controller.seekTo(Duration.zero);
          await controller.play();
          await Future.delayed(controller.value.duration);
        }

        if (mounted) {
          setState(() {
            _currentState = newState;
            _isPlayingTransition = false;
            if (newState + 1 > _nextTransitionalState) {
              _nextTransitionalState = newState + 1;
            }
            _targetState = null;
            _activeTransitionController = null;
          });
        }
      }
    } else {
      // Fallback if video missing
      if (mounted) {
        setState(() {
          _currentState = newState;
          if (newState + 1 > _nextTransitionalState) {
            _nextTransitionalState = newState + 1;
          }
        });
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _editingQuestion = null;
      _editingAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading until BOTH data AND first image are ready
    if (treeParts == null || !_initialImageLoaded) return const TreeLoadingWidget();

    int? unansweredTreePartIndex = getUnansweredTreePart(treeParts!);
    bool isUnansweredTreePart = (!allQuestionsAnswered && unansweredTreePartIndex != null && unansweredTreePartIndex <= _currentState);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 64,
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: CircleBorder(),
            ),
            padding: EdgeInsets.zero,
            icon: Icon(
              color: Theme.of(context).colorScheme.secondary,
              Icons.home_rounded,
              weight: 0.9,
            ),
            iconSize: 56,
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            AvatarIcon(
              avatarConfiguration: _avatarConfig,
              callback: () {
                setState(() {
                  _checkAvatarTooltip();
                  loadAvatarConfig();
                });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            TreeBackground(
              activeTransitionController: _activeTransitionController,
              videoControllers: _videoControllers,
              currentState: _currentState,
              targetState: _targetState,
              isPlayingTransition: _isPlayingTransition,
            ),
            Positioned(
              right: -50,
              bottom: 90,
              child: AvatarWidget(
                config: _avatarConfig,
                size: 250,
              ),
            ),
            if (!_isPlayingTransition) ...[
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      Expanded(
                        child: SafeArea(
                          child: ChatBubbleConstructor(
                            questionAnswerMap: treeParts![_currentState].questionAnswerMap,
                            scrollController: _chatScrollController,
                            onEditAnswer: (question, answer) {
                              setState(() {
                                _editingQuestion = question;
                                _editingAnswer = answer;
                              });
                            },
                          ),
                        ),
                      ),
                      InputContainer(
                        chatScrollController: _chatScrollController,
                        onContinue: () => _updateTreeState(_currentState + 1),
                        treeParts: treeParts!,
                        currentState: _currentState,
                        inputLogic: _inputLogic,
                        editingQuestion: _editingQuestion,
                        editingAnswer: _editingAnswer,
                        onCancelEdit: _cancelEdit,
                        onTreeUpdate: (newParts) {
                          setState(() {
                            treeParts = newParts;
                          });
                        },
                        onAllQuestionsAnswered: (isAllAnswered) {
                          setState(() {
                            allQuestionsAnswered = isAllAnswered;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // next button
              if (!isUnansweredTreePart && _currentState != maxTreeState)
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () => _updateTreeState(_currentState + 1),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              // previous button
              if (_currentState != 0)
                Positioned(
                  bottom: 100,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: () => _updateTreeState(_currentState - 1),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              if (_showAvatarTooltip)
                AvatarTooltip(
                  onDismissTooltip: () async {
                    await _avatarController.markTooltipAsSeen();
                    setState(() {
                      _showAvatarTooltip = false;
                    });
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
