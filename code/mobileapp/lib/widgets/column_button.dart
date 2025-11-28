import 'package:flutter/material.dart';

class ColumnButton extends StatelessWidget {
  final Color color;
  final String label;
  final int infoId;
  final String pageRoute;
  final Widget child;

  const ColumnButton({
    super.key,
    required this.color,
    required this.label,
    required this.infoId,
    required this.pageRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          pageRoute,
          arguments: <String, dynamic>{
            'infoId': infoId,
            'route': pageRoute,
          },
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 18.0),
          padding: EdgeInsets.symmetric(horizontal: width * 0.022),
          height: width / 4,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.08),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600]!,
                offset: const Offset(
                  0.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: -1.5,
              ),
            ],
          ),
          child: child),
    );
  }
}

class ColumnTextButton extends StatelessWidget {
  final Color color;
  final String label;
  final int infoId;
  final String pageRoute;

  const ColumnTextButton({
    super.key,
    required this.color,
    required this.label,
    required this.infoId,
    required this.pageRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnButton(
      color: color,
      label: label,
      infoId: infoId,
      pageRoute: pageRoute,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class ColumnImageButton extends StatelessWidget {
  final Color color;
  final String label;
  final int infoId;
  final String pageRoute;

  const ColumnImageButton({
    super.key,
    required this.color,
    required this.label,
    required this.infoId,
    required this.pageRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnButton(
      color: color,
      label: label,
      infoId: infoId,
      pageRoute: pageRoute,
      child: Image.network(label),
    );
  }
}
