import 'dart:async';
import 'package:mobileapp/api/cache.dart';
import 'package:mobileapp/api/info.dart';
import 'package:mobileapp/api/section.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/widgets/header.dart';
import 'package:mobileapp/screens/news/widgets/news_card.dart';
import 'package:mobileapp/widgets/page_content_progress_indicator.dart';
import 'package:mobileapp/model/info_content.dart';
import 'package:mobileapp/model/info_segment.dart';
import 'package:mobileapp/model/section.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<List<InfoSegment>> futureInfoSegments;
  late Future<List<InfoContent>> futureInfoContent;
  late Future<List<dynamic>> futureNews;

  Future<List> fetchNews(sectionId) async {
    List test = await futureInfoSegments;
    List content = await futureInfoContent;
    List newsItems = [];
    for (var i in test.where((i) => i.sectionId == sectionId).toList()) {
      for (var j in content.where((j) => j.infoId == i.id).toList()) {
        newsItems.add(j);
      }
    }
    return newsItems;
  }

  Future<void> _refreshNews() async {
    setState(() {
      sections = fetchSections();
      futureInfoSegments = fetchInfoSegments();
      futureInfoContent = fetchInfoContents();
      futureNews = fetchNews(3);
    });
  }

  @override
  void initState() {
    super.initState();
    futureInfoSegments = fetchInfoSegments();
    futureInfoContent = fetchInfoContents();
    futureNews = fetchNews(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: Header(
        bgColor: Colors.transparent,
        titleColor: Theme.of(context).colorScheme.onPrimary,
        title: FutureBuilder<List<Section>>(
          future: sections,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data!.firstWhere((i) => i.id == 3).name);
            }
            // show a loading spinner
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: RefreshIndicator(
          onRefresh: _refreshNews,
          child: FutureBuilder<List<dynamic>>(
            future: futureNews,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: snapshot.data!.asMap().entries.map((info) {
                    return NewsCard(
                      infoId: info.value.id,
                      title: info.value.title.toUpperCase(),
                      subText: info.value.shortContent,
                      date: DateTime.parse(info.value.updatedAt),
                    );
                  }).toList(),
                );
              }
              // show a loading spinner
              else {
                return const PageContentProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
