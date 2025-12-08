import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API service for handling answer operations
class AnswerApi {
  static const String _endpoint = 'https://dewaaiburgapp.eu/api/answer';

  /// Creates a new answer for a question
  static Future<void> createAnswer({
    required int questionId,
    required String answer,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'question_id': questionId,
        'answer': answer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create answer: ${response.statusCode}');
    }
  }

  /// Updates an existing answer
  static Future<void> updateAnswer({
    required int answerId,
    required int questionId,
    required String answer,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_endpoint/$answerId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'question_id': questionId,
        'answer': answer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update answer: ${response.statusCode}');
    }
  }
}
