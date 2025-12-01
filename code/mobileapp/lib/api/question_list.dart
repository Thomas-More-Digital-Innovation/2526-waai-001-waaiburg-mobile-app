import 'package:http/http.dart' as http;
import 'package:mobileapp/config/env.dart';
import 'package:mobileapp/model/qna.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchQuestionList() async {
  const String apiEndpoint = '$apiUrl/activeList'; // API URL
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.get('userToken');
  final userId = prefs.get('userId');

  try {
    final response = await http.get(Uri.parse(apiEndpoint), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // Fetch the questions
      Iterable questions = jsonDecode(response.body)['questions'][0];
      // Fetch the answers
      Iterable answers = jsonDecode(response.body)['answers'][0];

      List<Question> questionsList = questions.map((model) => Question.fromJson(model)).toList();

      List<Answer> answersList = answers.map((model) => Answer.fromJson(model)).where((answer) => answer.userId == userId).toList();

      return Future.value([questionsList, answersList]);
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Request failed with exception: $e");
    throw Exception('Failed to load data');
  }
}
