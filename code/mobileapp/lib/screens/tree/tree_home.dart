import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/avatar_configuration.dart';
import 'package:mobileapp/screens/tree/tree_constants.dart';
import 'package:mobileapp/screens/tree/widgets/chat_bubble.dart';
import 'package:mobileapp/screens/tree/widgets/completion_message.dart';
import 'package:mobileapp/screens/tree/widgets/input_bubble.dart';
import 'package:mobileapp/screens/avatar/widgets/avatar_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TreeHome extends StatefulWidget {
  const TreeHome({super.key});

  @override
  State<TreeHome> createState() => _TreeHomeState();
}

class _TreeHomeState extends State<TreeHome> with TickerProviderStateMixin {
  late Future<List<dynamic>> futureQuestionAnswerList;

  List<Question>? questionsList;
  List<Answer>? answersList;
  int currentQuestionIndex = 0;
  int currentTreePartIndex = 0;
  bool isInputVisible = false;
  Answer? answer;
  bool treeStateChanged = false;
  final GlobalKey _speechBubbleKey = GlobalKey();
  double _answerTopPosition = 0;
  bool isKeyboardVisible = false;
  bool allQuestionsFilledIn = false;

  int _state = 0;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  
  AvatarConfiguration _avatarConfig = const AvatarConfiguration();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadAvatarConfig();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _loadAvatarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString('avatar_config');

    if (mounted && configJson != null) {
      setState(() {
        _avatarConfig = AvatarConfiguration.fromJson(jsonDecode(configJson));
      });
    }
  }

  Future<void> _initializeData() async {
    futureQuestionAnswerList = fetchQuestionList();

    // Using `await` to wait for the future to complete before accessing its value
    List<dynamic> questionAnswerList = await futureQuestionAnswerList;

    // Now you can access the elements of the list
    questionsList = questionAnswerList[0];
    answersList = questionAnswerList[1];

    // Find the index of the first unanswered question
    int indexOfFirstUnansweredQuestion = questionsList!.indexWhere((question) => answersList!.every((answer) => answer.questionId != question.id));

    //go to the last filled in question because nicer user experience
    if (indexOfFirstUnansweredQuestion > 0) {
      indexOfFirstUnansweredQuestion -= 1;
    }

    // Set all state in one batch to avoid multiple rebuilds
    if (mounted) {
      setState(() {
        currentQuestionIndex = indexOfFirstUnansweredQuestion >= 0 ? indexOfFirstUnansweredQuestion : questionsList!.length - 1;
        currentTreePartIndex = questionsList![currentQuestionIndex].treePartId;
        _state = currentTreePartIndex - 1;
        answer = _getAnswerValue(currentQuestionIndex);
      });
    }
  }

  void _goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      if (!allQuestionsFilledIn) {
        setState(() {
          currentQuestionIndex--;
          isInputVisible = false;
          answer = _getAnswerValue(currentQuestionIndex);
        });
      } else {
        setState(() {
          allQuestionsFilledIn = false;
        });
      }
    }
  }

  void _goToNextQuestion() {
    if (questionsList != null && currentQuestionIndex < questionsList!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isInputVisible = false;
        answer = _getAnswerValue(currentQuestionIndex);
      });
    } else if (currentQuestionIndex == questionsList!.length - 1) {
      setState(() {
        allQuestionsFilledIn = true;
      });
    }
  }

  Answer? _getAnswerValue(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= (questionsList?.length ?? 0)) {
      return null;
    }
    
    final currentQuestionId = questionsList![questionIndex].id;
    try {
      return answersList?.firstWhere(
        (answer) => answer.questionId == currentQuestionId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> reloadAllData() async {
    await _initializeData();
    if (mounted) {
      setState(() {
        isInputVisible = false;
      });
    }
  }

  Future<void> _updateTreeState(String direction) async {
    setState(() {
      if (direction == "Forward") {
        if (_state < TreeConstants.maxTreeState) {
          _state += 1;
        }
      } else if (direction == "Backward") {
        if (_state > TreeConstants.minTreeState) {
          _state -= 1;
        }
      }
    });

    if (treeStateChanged) {
      // Load the images asynchronously
      await _loadImages();

      if (mounted) {
        setState(() {
          currentTreePartIndex = questionsList![currentQuestionIndex].treePartId;
        });
      }

      try {
        // Dispose old controller before creating new one
        if (_videoPlayerController.value.isInitialized) {
          await _videoPlayerController.pause();
        }
        await _loadVideo();
        if (mounted) {
          _initializeChewieController();
        }
      } catch (e) {
        debugPrint("Error loading video: $e");
      }
    }
  }

  Future<void> _loadVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(
        TreeConstants.getVideoPath(_state),
      );

      await _videoPlayerController.initialize();
    } catch (error) {
      debugPrint('Error initializing video player: $error');
    }
  }

  void _initializeChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      allowPlaybackSpeedChanging: false,
      showControlsOnInitialize: false,
      allowFullScreen: true,
      showControls: false,
      showOptions: false,
    );
  }

  Future<void> _loadImages() async {
    final precacheTasks = <Future>[];
    for (var i = 1; i <= TreeConstants.maxTreeState; i++) {
      precacheTasks.add(
        precacheImage(
          AssetImage(TreeConstants.getImagePath(i)),
          context,
        ),
      );
    }
    await Future.wait(precacheTasks);
  }

  Widget buildChewieWidget() {
    // Schedule state change after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && treeStateChanged) {
        setState(() {
          treeStateChanged = false;
        });
      }
    });
    return FutureBuilder<void>(
      future: _loadVideo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AbsorbPointer(
            absorbing: true,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint("Error loading video: ${snapshot.error}");
          return AspectRatio(
            aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
            child: Image.asset(
              TreeConstants.getImagePath(_state),
              fit: BoxFit.fill,
            ),
          );
        } else {
          // Loading state, you can return a loading indicator if needed
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  double _calculateAnswerTopPosition() {
    if (questionsList != null && questionsList!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Get the RenderBox for the speech bubble widget using the GlobalKey
        final RenderBox renderBox = _speechBubbleKey.currentContext!.findRenderObject() as RenderBox;

        // Calculate the top position by adding the height of the speech bubble
        setState(() {
          _answerTopPosition = renderBox.size.height + 120;
        });
      });

      // Return the last calculated top position
      return _answerTopPosition;
    }
    return 0; // Default top position if questionsList is null or empty
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Background image (tree)
              AspectRatio(
                aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                child: Image.asset(
                  TreeConstants.getImagePath(_state > 0 ? _state - 1 : _state),
                  fit: BoxFit.fill,
                ),
              ),
              // Show the video player when _state is not 0.

              treeStateChanged
                  ? buildChewieWidget()
                  : AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                      child: Image.asset(
                        TreeConstants.getImagePath(_state),
                        fit: BoxFit.fill,
                      ),
                    ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.home_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    weight: 0.9,
                  ),
                  iconSize: 55,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              if (allQuestionsFilledIn) const CompletionMessage(),

              // Speech Bubble
              if (!allQuestionsFilledIn)
                Positioned(
                  key: _speechBubbleKey,
                  top: 100,
                  left: 30,
                  child: questionsList == null
                      ? const CircularProgressIndicator() // TODO: Replace with loading indicator
                      : questionsList!.isEmpty
                          ? const Text("Geen actieve vragenlijst gevonden!")
                          : ChatBubble(
                              message: questionsList![currentQuestionIndex].content,
                              horizontalPadding: 40,
                              verticalPadding: 20,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            ),
                ),
              if (!allQuestionsFilledIn)
                if (answer != null)
                  // Answer Bubble
                  if (questionsList != null && questionsList!.isNotEmpty)
                    Positioned(
                      top: _calculateAnswerTopPosition(),
                      right: 30,
                      child: ChatBubble(
                        message: answer!.answer,
                        horizontalPadding: 40,
                        verticalPadding: 20,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
              // Input bubble
              if (isInputVisible)
                Positioned(
                  bottom: isKeyboardVisible ? 350 : 90, // Adjust the position as needed
                  left: MediaQuery.of(context).size.width / 2 - 150,
                  child: InputBubble(
                    answer: answer,
                    questionId: questionsList![currentQuestionIndex].id,
                    reloadData: reloadAllData,
                    updateKeyboardVisibility: (bool isVisible) {
                      setState(() {
                        isKeyboardVisible = isVisible;
                      });
                    },
                  ),
                ),

              // Pijltje Links
              Positioned(
                bottom: 20,
                left: 10,
                child: IconButton(
                  icon: Transform.rotate(
                    angle: 45,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      weight: 0.9,
                    ),
                  ),
                  iconSize: 55,
                  onPressed: () {
                    _goToPreviousQuestion();
                    if (questionsList != null && questionsList!.isNotEmpty) {
                      if (currentTreePartIndex < questionsList![currentQuestionIndex].treePartId) {
                        setState(() {
                          treeStateChanged = true;
                        });
                        _updateTreeState("Backward");
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              if (!allQuestionsFilledIn)
                // Antwoord
                Positioned(
                  bottom: 30,
                  left: MediaQuery.of(context).size.width / 2 - 50, // Center Horizontally
                  right: null,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      if (questionsList?.isNotEmpty ?? false) {
                        setState(() {
                          isInputVisible = !isInputVisible;
                        });
                      }
                    },
                    child: const Text(
                      'Antwoorden',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(
                width: 5,
              ),
              // Pijltje Rechts
              if (!allQuestionsFilledIn)
                if (answer != null)
                  Positioned(
                    bottom: 20, // Adjust the position as needed
                    right: 10, // Adjust the position as needed
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        weight: 0.9,
                      ),
                      iconSize: 55,
                      onPressed: () {
                        _goToNextQuestion();
                        if (questionsList != null && questionsList!.isNotEmpty) {
                          if (currentTreePartIndex < questionsList![currentQuestionIndex].treePartId) {
                            setState(() {
                              treeStateChanged = true;
                            });
                            _updateTreeState("Forward");
                          }
                        }
                      },
                    ),
                  ),
              
              // Avatar character (het mannetje)
              Positioned(
                bottom: 120,
                right: -30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/avatar').then((_) {
                      // Reload avatar config when returning from customization
                      _loadAvatarConfig();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: AvatarWidget(
                      config: _avatarConfig,
                      size: 250,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
