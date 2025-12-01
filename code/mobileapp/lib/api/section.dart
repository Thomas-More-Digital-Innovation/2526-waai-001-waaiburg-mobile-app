import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobileapp/config/env.dart';
import 'package:mobileapp/model/section.dart';

Future<List<Section>> fetchSections() async {
  final response = await http.get(Uri.parse('$apiUrl/section'));

  if (response.statusCode == 200) {
    Iterable sections = jsonDecode(response.body)["sections"][0];
    List<Section> sectionsList = List<Section>.from(sections.map((model) => Section.fromJson(model)));
    return sectionsList;
  } else {
    throw Exception(response.reasonPhrase);
  }
}
