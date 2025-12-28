import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';
import 'package:mobileapp/screens/tree_refactor/tree_part.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/chat_bubble_constructor.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/completion_card.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/input.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/background.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/profile_button.dart';
import 'package:mobileapp/screens/tree/tree_constants.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/tree_loading.dart';
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
  bool _isWaitingForNextQuestionInTreePart = false;
  bool _initialImageLoaded = false;
  VideoPlayerController? _activeTransitionController;
  bool allQuestionsAnswered = false;

  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    loadTreeParts().then((_) => initTree());
  }

  Future<void> loadTreeParts() async {
    List<dynamic> futureQuestionAnswerList = await fetchQuestionList();

    treeParts = generateTreeParts(futureQuestionAnswerList[0], futureQuestionAnswerList[1]);
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

    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
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
            ProfileButton(),
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
              SafeArea(
                child: ChatBubbleConstructor(
                  questionAnswerMap: treeParts![_currentState].questionAnswerMap,
                  loadingNextQuestion: _isWaitingForNextQuestionInTreePart,
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
                      reloadData: (Question answeredQuestion, String answerText) {
                        bool canGoToNextTreePart = treeParts![_currentState].unasweredQuestions == 1;

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

                        // Check if this was the last question overall
                        if (getUnansweredTreePart(treeParts!) == null) {
                          setState(() {
                            allQuestionsAnswered = true;
                          });
                          syncWithApi(); // Sync with API in background
                          return;
                        }

                        /// We differentiate a next tree part update & a normal update because
                        /// a tree state update needs to load & set the video (and uses that video as load time)
                        /// while the normal update updates only after the newest tree part state is loaded
                        if (canGoToNextTreePart) {
                          setState(() {}); // Update UI before transition
                          _updateTreeState(_currentState + 1);
                          syncWithApi(); // Sync with API in background
                        } else {
                          setState(() {}); // Trigger UI update with optimistic data
                          syncWithApi(); // Sync with API in background
                        }
                      },
                      updateKeyboardVisibility: (bool isVisible) {
                        setState(() {});
                      },
                    );
                  }
                }(),
              )
            ]
          ],
        ),
      ),
    );
  }
}
