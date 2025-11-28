import 'dart:async';
import 'package:mobileapp/api/info.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/components/column_button_list_view.dart';
import 'package:mobileapp/components/header.dart';
import 'package:mobileapp/components/page_content_progress_indicator.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/info_segment.dart';

class InfoContents extends StatefulWidget {
  const InfoContents({super.key});

  @override
  State<InfoContents> createState() => _InfoContentsState();
}

class _InfoContentsState extends State<InfoContents> {
  late Future<List<InfoContent>> infoContents;
  late Future<List<InfoSegment>> infoSegments;

  @override
  void initState() {
    super.initState();
    infoContents = fetchInfoContents();
    infoSegments = fetchInfoSegments();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(
        title: arg['title'] != null
            ? Text(arg['title'])
            : FutureBuilder<List<InfoSegment>>(
                future: infoSegments,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data!.firstWhere((i) => i.id == arg['infoId']).title);
                  }
                  // show a loading spinner
                  else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
      ),
      body: FutureBuilder<List<InfoContent>>(
        future: infoContents,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return ColumnButtonListView(list: snapshot.data!.where((i) => i.infoId == arg['infoId']).toList(), route: '/infocontentselect');
          }
          // show a loading spinner
          else {
            return const PageContentProgressIndicator();
          }
        },
      ),
    );
  }
}
