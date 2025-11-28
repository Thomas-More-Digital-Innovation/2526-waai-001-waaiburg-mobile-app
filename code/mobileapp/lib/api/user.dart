import 'package:http/http.dart' as http;
import 'package:mobileapp/api/api.dart';
import 'package:mobileapp/model/user.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchUserDetails() async {
  const String apiEndpoint = '$apiUrl/user'; // API URL
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.get('userToken');

  try {
    final response = await http.get(Uri.parse(apiEndpoint), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // Decode the entire JSON response
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Convert 'user' and 'mentor' fields into User instances
      User user = User.fromJson(jsonResponse['user']);
      User? mentor = jsonResponse['mentor'].isNotEmpty ? User.fromJson(jsonResponse['mentor']) : null;
      return [user, mentor];
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Request failed with exception: $e");
    throw Exception('Failed to load data');
  }
}
