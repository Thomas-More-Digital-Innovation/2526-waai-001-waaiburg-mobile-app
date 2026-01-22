import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobileapp/api/answer.dart';
import 'package:mobileapp/model/qna.dart';

class InputWidget extends StatefulWidget {
  final Answer? answer;
  final Question question;
  final Function(Question question, String answerText) reloadData;
  final Function(bool) updateKeyboardVisibility;
  final bool isEditing;

  const InputWidget({
    super.key,
    this.answer,
    required this.question,
    required this.reloadData,
    required this.updateKeyboardVisibility,
    required this.isEditing,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _textController = TextEditingController();
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.answer != null) {
      _textController.text = widget.answer!.answer;
    }

    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(InputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.answer != oldWidget.answer) {
      if (widget.answer != null) {
        _textController.text = widget.answer!.answer;
      } else {
        _textController.clear();
      }
    }

    // Auto-focus when entering edit mode or changing the answer being edited
    if (widget.isEditing && (!oldWidget.isEditing || widget.answer != oldWidget.answer)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // widget.updateKeyboardVisibility(_focusNode.hasFocus);
  }

  Future<void> _handleSendAnswer() async {
    final newAnswer = _textController.text;
    if (newAnswer.isEmpty) return;

    try {
      if (widget.answer != null) {
        await AnswerApi.updateAnswer(
          answerId: widget.answer!.id,
          questionId: widget.answer!.questionId,
          answer: newAnswer,
        );
      } else {
        await AnswerApi.createAnswer(
          questionId: widget.question.id,
          answer: newAnswer,
        );
      }
      setState(() {
        _textController.clear();
      });
      widget.reloadData(widget.question, newAnswer);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij het opslaan van antwoord: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible && _focusNode.hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.unfocus();
          });
        }

        return SizedBox(
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.isEditing ? 0.0 : 12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _textController,
                    onChanged: (value) => setState(() {}),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Typ je antwoord...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(widget.isEditing ? Icons.save : Icons.send),
                  onPressed: _handleSendAnswer,
                  color: _textController.text.isEmpty
                      ? Colors.grey
                      : widget.isEditing
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
