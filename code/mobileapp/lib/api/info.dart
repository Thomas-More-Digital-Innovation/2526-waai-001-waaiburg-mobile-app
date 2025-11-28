import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobileapp/api/api.dart';
import 'package:mobileapp/model/info_segment.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/sortable.dart';

Future<List<T>> _fetchList<T extends Sortable>({
  required String endpoint,
  required String jsonKey,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  final response = await http.get(Uri.parse('$apiUrl/$endpoint'));

  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }

  final decoded = jsonDecode(response.body);

  if (!decoded.containsKey(jsonKey)) {
    throw Exception("JSON key '$jsonKey' not found.");
  }

  final Iterable rawList = decoded[jsonKey][0];

  final List<T> models = rawList.map((item) => fromJson(item as Map<String, dynamic>)).toList().cast<T>();

  models.sort(
    (a, b) => (a.orderNumber ?? 0).compareTo(b.orderNumber ?? 0),
  );

  return models;
}

Future<List<InfoSegment>> fetchInfoSegments() {
  return _fetchList<InfoSegment>(
    endpoint: 'info',
    jsonKey: "info's",
    fromJson: InfoSegment.fromJson,
  );
}

Future<List<InfoContent>> fetchInfoContents() {
  return _fetchList<InfoContent>(
    endpoint: 'infoContent',
    jsonKey: 'infoContents',
    fromJson: InfoContent.fromJson,
  );
}
