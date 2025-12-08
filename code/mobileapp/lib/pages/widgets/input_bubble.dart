import 'package:flutter/material.dart';
import 'package:mobileapp/api/answer.dart';
import 'package:mobileapp/api/question_list.dart';
import 'package:mobileapp/pages/widgets/bubble_clipper.dart';

class InputBubble extends StatefulWidget {
  final Answer? answer;
  final int questionId;
  final Function reloadData;
  final Function(bool) updateKeyboardVisibility;

  const InputBubble({
    Key? key,
    this.answer,
    required this.questionId,
    required this.reloadData,
    required this.updateKeyboardVisibility,
  }) : super(key: key);

  @override
  State<InputBubble> createState() => _InputBubbleState();
}

class _InputBubbleState extends State<InputBubble> {
  final TextEditingController _textController = TextEditingController();
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.answer != null) {
      _textController.text = widget.answer!.answer;
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
    widget.updateKeyboardVisibility(_focusNode.hasFocus);
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
          questionId: widget.questionId,
          answer: newAnswer,
        );
        widget.reloadData();
      }
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
    return SizedBox(
      width: 300,
      height: 50,
      child: ClipPath(
        clipper: BubbleClipper(),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textController,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Typ je antwoord...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _handleSendAnswer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
