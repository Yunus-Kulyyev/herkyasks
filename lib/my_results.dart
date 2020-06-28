import 'package:flutter/material.dart';

class MyResults extends StatelessWidget {
  String title;
  Map<String, String> qa;
  List<Widget> widgets;

  MyResults(String title, Map<dynamic, dynamic> qMap) {
    widgets = new List();

    qMap.forEach((key1, value1) {
      widgets.add(new Text(key1 + ": " + value1.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...(widgets),
      ],
    );
  }
}