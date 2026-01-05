import 'package:flutter/material.dart';
import 'package:mobileapp/model/qna.dart';
import 'package:mobileapp/model/tree_part.dart';
import 'package:mobileapp/screens/tree_refactor/logic/input_logic.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/completion_card.dart';
import 'package:mobileapp/screens/tree_refactor/widgets/input.dart';

class InputContainer extends StatefulWidget {
  final ScrollController chatScrollController;
  final VoidCallback onContinue;
  final List<TreePart> treeParts;
  final int currentState;
  final Function(List<TreePart>) onTreeUpdate;
  final Function(bool) onAllQuestionsAnswered;
  final InputLogic inputLogic;

  const InputContainer({
    super.key,
    required this.chatScrollController,
    required this.onContinue,
    required this.treeParts,
    required this.currentState,
    required this.onTreeUpdate,
    required this.onAllQuestionsAnswered,
    required this.inputLogic,
  });

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  void _scrollToBottom() {
    if (widget.chatScrollController.hasClients) {
      widget.chatScrollController.animateTo(
        widget.chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleAnswer(Question answeredQuestion, String answerText) async {
    // Optimistically update local state immediately
    final optimisticAnswer = Answer(
      id: -1, // Temporary ID, will be replaced on API sync
      userId: -1,
      questionId: answeredQuestion.id,
      answer: answerText,
    );

    // Create a new list to avoid mutating the passed reference directly if it's reused elsewhere
    // though here we want to update the parent's state.
    List<TreePart> currentParts = List.from(widget.treeParts);

    currentParts[widget.currentState] = currentParts[widget.currentState].copyWithAnswer(
      answeredQuestion,
      optimisticAnswer,
    );

    widget.onTreeUpdate(currentParts);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Check if this was the last question overall
    if (widget.inputLogic.isTreeCompleted(currentParts)) {
      widget.onAllQuestionsAnswered(true);
      // Sync one last time
      final syncedParts = await widget.inputLogic.syncWithApi(currentParts);
      if (mounted) {
        widget.onTreeUpdate(syncedParts);
      }
      return;
    }

    // Show typing indicator before revealing next question (implied logic, but here we just sync)
    // Sync in background and update parent when done
    widget.inputLogic.syncWithApi(currentParts).then((syncedParts) {
      if (mounted) {
        widget.onTreeUpdate(syncedParts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure state is valid
    if (widget.currentState >= widget.treeParts.length) {
      return const SizedBox.shrink();
    }

    Question? nextQuestion = widget.inputLogic.getNextQuestionForState(widget.treeParts[widget.currentState]);
    bool allAnswered = widget.inputLogic.isTreeCompleted(widget.treeParts);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: () {
          if (allAnswered) {
            return const CompletionCard();
          } else if (nextQuestion == null) {
            return ElevatedButton(
              onPressed: widget.onContinue,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Volgende'),
            );
          } else {
            return InputWidget(
              question: nextQuestion,
              reloadData: _handleAnswer,
              updateKeyboardVisibility: (bool isVisible) {
                setState(() {});
              },
            );
          }
        }());
  }
}
