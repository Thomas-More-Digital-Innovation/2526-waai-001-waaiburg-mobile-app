import 'package:mobileapp/api/info.dart';
import 'package:mobileapp/api/section.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/shared/widgets/column_button_list_view.dart';
import 'package:mobileapp/shared/widgets/header.dart';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/shared/widgets/page_content_progress_indicator.dart';
import 'package:mobileapp/model/info_segment.dart';
import 'package:mobileapp/model/section.dart';

class InfoSegments extends StatefulWidget {
  const InfoSegments({super.key});

  @override
  State<InfoSegments> createState() => _InfoSegmentsState();
}

class _InfoSegmentsState extends State<InfoSegments> {
  Future<void> _refreshSegments() async {
    setState(() {
      sections = fetchSections();
      infoSegments = fetchInfoSegments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(
        title: FutureBuilder<List<Section>>(
          future: sections,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data!.firstWhere((i) => i.id == arg["sectionId"]).name);
            }
            // show a loading spinner
            else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSegments,
        child: FutureBuilder<List<InfoSegment>>(
          future: infoSegments,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return ColumnButtonListView(list: snapshot.data!.where((i) => i.sectionId == arg["sectionId"]).toList(), route: '/infocontent');
            }
            // show a loading spinner
            else {
              return const PageContentProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
