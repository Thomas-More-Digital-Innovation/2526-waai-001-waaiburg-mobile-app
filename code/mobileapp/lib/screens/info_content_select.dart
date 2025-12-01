import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/api/info.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/shared/widgets/header.dart';
import 'package:mobileapp/shared/widgets/page_content_loading_indicator.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoContentSelected extends StatefulWidget {
  const InfoContentSelected({super.key, required this.infoId, this.title});

  final int infoId;
  final String? title;

  @override
  State<InfoContentSelected> createState() => _InfoContentSelectedState();
}

class _InfoContentSelectedState extends State<InfoContentSelected> {
  Future<void> _refreshContents() async {
    setState(() {
      infoContents = fetchInfoContents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: widget.title != null
            ? Text(widget.title!)
            : FutureBuilder<List<InfoContent>>(
                future: infoContents,
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
        onRefresh: _refreshContents,
        child: SingleChildScrollView(
          child: FutureBuilder<List<InfoContent>>(
            future: infoContents,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Html(
                        data: snapshot.data!.firstWhere((i) => i.id == widget.infoId).content ?? '<h1>No content</h1>',
                        onLinkTap: (url, attributes, element) {
                          launchUrl(Uri.parse(url ?? ''));
                        },
                      ),
                      Visibility(
                        visible: snapshot.data!.firstWhere((i) => i.id == widget.infoId).url != null,
                        child: InkWell(
                          child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Text('Meer Info',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ))),
                          onTap: () => launchUrl(Uri.parse(snapshot.data!.firstWhere((i) => i.id == widget.infoId).url ?? '')),
                        ),
                      ),
                    ],
                  ),
                );
              }
              // show a loading spinner
              else {
                return const PageContentLoadingIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
