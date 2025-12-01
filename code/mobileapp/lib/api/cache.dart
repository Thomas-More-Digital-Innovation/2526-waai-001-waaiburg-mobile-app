import 'package:mobileapp/api/info.dart';
import 'package:mobileapp/api/section.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/info_segment.dart';
import 'package:mobileapp/model/section.dart';

Future<List<Section>>? sections;
Future<List<InfoSegment>>? infoSegments;
Future<List<InfoContent>>? infoContents;

void cacheData() {
  sections = fetchSections();
  infoSegments = fetchInfoSegments();
  infoContents = fetchInfoContents();
}
