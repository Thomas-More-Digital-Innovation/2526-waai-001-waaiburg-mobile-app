import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/api/info.dart';
import 'package:mobileapp/api/section.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/info_segment.dart';
import 'package:mobileapp/model/section.dart';

void main() {
  group('Cache Tests', () {
    test('cacheData assigns futures correctly', () {
      // Initially, futures should be null or unassigned
      expect(sections, isNull);
      expect(infoSegments, isNull);
      expect(infoContents, isNull);

      // Call cacheData
      cacheData();

      // After cacheData, futures should be assigned
      expect(sections, isNotNull);
      expect(infoSegments, isNotNull);
      expect(infoContents, isNotNull);
    });
  });
  group('API Tests', () {
    test('fetchSections returns a list of Section', () async {
      final sections = await fetchSections();
      expect(sections, isA<List<Section>>());
    });
    test('fetchInfoSegments returns a list of InfoSegment', () async {
      final infoSegments = await fetchInfoSegments();
      expect(infoSegments, isA<List<InfoSegment>>());
    });
    test('fetchInfoContents returns a list of InfoContent', () async {
      final infoContents = await fetchInfoContents();
      expect(infoContents, isA<List<InfoContent>>());
    });
  });
}
