import 'package:flutter/material.dart';
import 'package:ribbon/ribbon.dart';

class QuestionCard extends StatelessWidget {
  final String name;
  final String status;
  final String dueDate;
  final bool isCompleted;
  final int questionIndex;
  final Function surveyHandler;
  final String prizeKey;

  QuestionCard(
      {this.name,
      this.prizeKey,
      this.status,
      this.dueDate,
      this.questionIndex,
      this.surveyHandler,
      this.isCompleted});

  String getState() {
    String state = 'Available';
    if(status == 'false') {
      state = "Not Available";
    }
    if(isCompleted) {
      state = 'Completed';
    }
    return state;
  }

  Color getColor() {
    Color color = Colors.green;
    if(status == 'false') {
      color = Colors.grey;
    }
    if(isCompleted) {
      color = Color(0xffc6671d);
    }
    return color;
  }

  Widget getNoRibbon() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 12.0),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            dueDate,
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.grey),
          ),
          SizedBox(height: 15.0),
          Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Center(
                child: Text(
                  getState(),
                  style:
                  TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  Widget getRibbon() {
    return Ribbon(
      nearLength: 50,
      farLength: 80,
      title: 'KEY!',
      titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      color: Color(0xfffac606),
      location: RibbonLocation.bottomEnd,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.0),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              dueDate,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey),
            ),
            SizedBox(height: 15.0),
            Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: getColor(),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Center(
                  child: Text(
                    getState(),
                    style:
                    TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget getWidget() {
    /*if(isCompleted || prizeKey == 'none' || status == 'false') {
      return getNoRibbon();
    }*/
    if(isCompleted || status == 'false') {
      return getNoRibbon();
    }

    return getRibbon();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 7.0,
      child: InkWell(
        onTap: surveyHandler,
        child: getWidget(),
      ),
    );
  }
}
