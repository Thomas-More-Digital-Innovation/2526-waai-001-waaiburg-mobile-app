import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapp/config/routes.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({required this.infoId, required this.title, required this.subText, required this.date, super.key});

  final int infoId;
  final String title;
  final String subText;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.infoContentSelectPath(infoId, title: title));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 18.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${date.day}/${date.month}/${date.year}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
