import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';
import 'package:mobileapp/screens/avatar/widgets/avatar_widget.dart';
import 'package:mobileapp/screens/tree_refactor/tree_part.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble_constructor.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/completion_card.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/input.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/background.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/avatar.dart';
import 'package:mobileapp/screens/tree/tree_constants.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/tree_loading.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/avatar_tooltip.dart';
import 'package:mobileapp/screens/tree_refactor/logic/avatar_tooltip_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class TreeNew extends StatefulWidget {
  const TreeNew({super.key});

  @override
  State<TreeNew> createState() => _TreeNewState();
}

class _TreeNewState extends State<TreeNew> {
  List<TreePart>? treeParts;
  Map<int, List<Question>>? questionsMap;
  List<Answer>? answersList;
  int currentQuestionIndex = 0;
  int _currentState = 0;
  int? _targetState;
  bool _isPlayingTransition = false;
  bool _initialImageLoaded = false;
  VideoPlayerController? _activeTransitionController;
  bool allQuestionsAnswered = false;
  AvatarConfiguration _avatarConfig = const AvatarConfiguration();
  bool _showAvatarTooltip = false;
  final AvatarTooltipController _avatarController = AvatarTooltipController();

  final Map<int, VideoPlayerController> _videoControllers = {};

  final ScrollController _chatScrollController = ScrollController();

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

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

  /// Background sync that preserves optimistic updates
  /// Only updates answers that have been confirmed by the API (have real IDs)
  Future<void> syncWithApi() async {
    try {
      List<dynamic> apiData = await fetchQuestionList();
      List<TreePart> apiTreeParts = generateTreeParts(apiData[0], apiData[1]);

      if (!mounted) return;

      // Merge API data with local optimistic updates
      // Keep local answers with temporary IDs (-1), update with API answers
      for (int i = 0; i < treeParts!.length && i < apiTreeParts.length; i++) {
        final localPart = treeParts![i];
        final apiPart = apiTreeParts[i];

        Map<Question, Answer?> mergedMap = {};
        for (var entry in localPart.questionAnswerMap.entries) {
          final question = entry.key;
          final localAnswer = entry.value;

          // Find corresponding API answer
          Answer? apiAnswer;
          for (var apiEntry in apiPart.questionAnswerMap.entries) {
            if (apiEntry.key.id == question.id) {
              apiAnswer = apiEntry.value;
              break;
            }
          }

          // Prefer API answer if it exists, otherwise keep local optimistic answer
          if (apiAnswer != null) {
            mergedMap[question] = apiAnswer;
          } else if (localAnswer != null) {
            mergedMap[question] = localAnswer;
          } else {
            mergedMap[question] = null;
          }
        }

        treeParts![i] = TreePart(
          id: localPart.id,
          imagePath: localPart.imagePath,
          videoPath: localPart.videoPath,
          questionAnswerMap: mergedMap,
        );
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Silently fail background sync - optimistic update is still in place
      debugPrint('Background sync failed: $e');
    }
  }

  Future<void> initTree() async {
    int? unasweredTreePartIndex = getUnansweredTreePart(treeParts!);

    if (unasweredTreePartIndex == null) {
      setState(() {
        allQuestionsAnswered = true;
      });
      unasweredTreePartIndex = maxTreeState;
    }
    _currentState = unasweredTreePartIndex;

    // Precache the first background image before showing UI
    if (mounted && treeParts != null && treeParts!.isNotEmpty) {
      await precacheImage(AssetImage(treeParts![_currentState].imagePath), context);
      setState(() {
        _initialImageLoaded = true;
      });
    }
  }

  Future<void> _updateTreeState(int newState) async {
    if (_isPlayingTransition) return;
    if (newState < TreeConstants.minTreeState || newState > TreeConstants.maxTreeState) return;

    final controller = _videoControllers[newState];
    if (controller != null) {
      // Setup transition
      _activeTransitionController = controller;
      await controller.seekTo(Duration.zero);

      if (mounted) {
        setState(() {
          _isPlayingTransition = true;
          _targetState = newState;
        });
        if (newState > _currentState && !allQuestionsAnswered) {
          await controller.play();
          await Future.delayed(controller.value.duration);
        }

        if (mounted) {
          setState(() {
            _currentState = newState;
            _isPlayingTransition = false;
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
        });
      }
    }
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
            Avatar(
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
            if (!_isPlayingTransition) ...[
              Positioned(
                right: -50,
                bottom: 90,
                child: AvatarWidget(
                  config: _avatarConfig,
                  size: 250,
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ChatBubbleConstructor(
                    questionAnswerMap: treeParts![_currentState].questionAnswerMap,
                    scrollController: _chatScrollController,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: () {
                  Question? nextQuestion = getNextQuestion(treeParts![_currentState].questionAnswerMap);

                  if (allQuestionsAnswered) {
                    return const CompletionCard();
                  } else if (nextQuestion == null) {
                    return ElevatedButton(
                      onPressed: () => _updateTreeState(_currentState + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text('Volgende'),
                    );
                  } else {
                    return InputWidget(
                      question: nextQuestion,
                      reloadData: (Question answeredQuestion, String answerText) async {
                        // Optimistically update local state immediately
                        final optimisticAnswer = Answer(
                          id: -1, // Temporary ID, will be replaced on API sync
                          userId: -1,
                          questionId: answeredQuestion.id,
                          answer: answerText,
                        );
                        treeParts![_currentState] = treeParts![_currentState].copyWithAnswer(
                          answeredQuestion,
                          optimisticAnswer,
                        );

                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                        // Check if this was the last question overall
                        if (isTreeCompleted(treeParts!)) {
                          setState(() {
                            allQuestionsAnswered = true;
                          });
                          syncWithApi();
                          return;
                        }

                        // Show typing indicator before revealing next question
                        syncWithApi(); // Sync in background
                      },
                      updateKeyboardVisibility: (bool isVisible) {
                        setState(() {});
                      },
                    );
                  }
                }(),
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
              // TODO: debug
              if (!_showAvatarTooltip)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _avatarController.debugResetTooltip();
                      if (context.mounted) {
                        setState(() {
                          _showAvatarTooltip = true;
                        });
                      }
                    },
                    child: const Text('Reset tooltip'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
