import 'package:flutter/material.dart';
import 'package:flutterapp/models/history_model.dart';

class MyResponseWidget extends StatelessWidget {
  final HistoryModel model;
  List<Widget> widgest;

  MyResponseWidget(this.model) {
    widgest = new List();
    model.responses.forEach((key, value) {
      widgest.add(getCard(key, value.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView(
        children: [
          Center(child: Text(model.surveyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
          SizedBox(height: 16,),
          ...widgest,
        ],
      ),
    );
  }

  Widget getCard(String title, String ans) {
    return Container(
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18),),
          SizedBox(height: 4,),
          Text(ans),
          SizedBox(height: 16,)
        ],
      ),
    );
  }
}
