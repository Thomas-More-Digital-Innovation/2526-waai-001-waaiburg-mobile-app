class QuestionList {
  final int id;
  final String title;

  QuestionList({
    required this.id,
    required this.title,
  });

  factory QuestionList.fromJson(Map<String, dynamic> json) {
    return QuestionList(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Question {
  final int id;
  final int questionListId;
  final int treePartId;
  final String content;

  const Question({
    required this.id,
    required this.questionListId,
    required this.treePartId,
    required this.content,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionListId: json['question_list_id'],
      treePartId: json['tree_part_id'],
      content: json['content'],
    );
  }
}

class Answer {
  final int id;
  final int userId;
  final int questionId;
  late String answer;

  Answer({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      userId: json['user_id'],
      questionId: json['question_id'],
      answer: json['answer'],
    );
  }
}
