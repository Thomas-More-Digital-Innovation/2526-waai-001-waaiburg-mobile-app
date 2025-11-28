import 'dart:async';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/api/info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:mobileapp/shared/widgets/column_button_list_view.dart';
import 'package:mobileapp/shared/widgets/header.dart';
import 'package:mobileapp/shared/widgets/page_content_loading_indicator.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/info_segment.dart';

class InfoContents extends StatefulWidget {
  const InfoContents({super.key, required this.infoId, this.title});

  final int infoId;
  final String? title;

  @override
  State<InfoContents> createState() => _InfoContentsState();
}

class _InfoContentsState extends State<InfoContents> {
  Future<void> _refreshSegments() async {
    setState(() {
      infoContents = fetchInfoContents();
      infoSegments = fetchInfoSegments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(
        title: widget.title != null
            ? Text(widget.title!)
            : FutureBuilder<List<InfoSegment>>(
                future: infoSegments,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data!.firstWhere((i) => i.id == widget.infoId).title);
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
        child: FutureBuilder<List<InfoContent>>(
          future: infoContents,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return ColumnButtonListView(
                list: snapshot.data!.where((i) => i.infoId == widget.infoId).toList(),
                onItemTap: (contentId, title) {
                  // Navigate to InfoContentSelected (final page)
                  context.push(AppRoutes.infoContentSelectPath(contentId, title: title));
                },
              );
            }
            // show a loading spinner
            else {
              return const PageContentLoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
