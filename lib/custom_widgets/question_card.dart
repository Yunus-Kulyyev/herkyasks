import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String name;
  final String status;
  final String dueDate;
  final bool isCompleted;
  final int questionIndex;
  final Function surveyHandler;

  QuestionCard(
      {this.name,
      this.status,
      this.dueDate,
      this.questionIndex,
      this.surveyHandler,
      this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 7.0,
      child: InkWell(
        onTap: surveyHandler,
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
                  color: status == 'false' ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Center(
                  child: Text(
                    status == 'false' ? 'Not Available' : 'Available',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
