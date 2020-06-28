import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<String> results;

class RadioTypeQuestion extends StatefulWidget {
  final List<String> surveyModel;
  final int questionIndex;
  final Key key;

  RadioTypeQuestion(this.key, this.surveyModel, this.questionIndex) : super(key: key);

  @override
  RadioTypeQuestionState createState() => RadioTypeQuestionState();

  List<String> getSelectedAnswer() {
    return results;
  }
}

class RadioTypeQuestionState extends State<RadioTypeQuestion> {
  String _selectedAnswer;
  String currentQuestionNumber = "Question 2";
  String questionItself = "How often do you dine at SacState cafeterias?";

  List<String> answers;

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  void constructQuestion() {
    results = new List();
    currentQuestionNumber = 'Question ' + widget.questionIndex.toString();

    answers = new List();
    for (String each in widget.surveyModel) {
      if (each.contains('question: ')) {
        questionItself = each.substring(10);
      } else if (!each.contains('type: ') && !each.contains('question: ')) {
        answers.add(each);
      }
    }

    results.add(questionItself);
    //results.add(answers[0]);
  }

  @override
  void initState() {
    super.initState();

    constructQuestion();
  }

  /*@override
  void dispose() {
    toast('TEST');
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 40.0, bottom: 20.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(currentQuestionNumber),
            Container(
                margin: EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Text(questionItself, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)),
            Center(
                child: Container(
                  child: Card(
                    child: Column(
                      children: List.generate(answers.length, (int index) {
                        final using = answers[index];
                        return GestureDetector(
                          onTapUp: (detail) {
                            setState(() {
                              _selectedAnswer = using;
                              results.clear();
                              results.add(questionItself);
                              results.add(_selectedAnswer);
                            });
                          },
                          child: Container(
                            height: 50.0,
                            color: _selectedAnswer == using
                                ? Colors.orangeAccent.withAlpha(100)
                                : Colors.white,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Radio(
                                        activeColor: Colors.orangeAccent,
                                        value: using,
                                        groupValue: _selectedAnswer,
                                        onChanged: (String value) {
                                          setState(() {
                                            _selectedAnswer = value;
                                          });
                                        }),
                                    Text(using)
                                  ],
                                ),
                                Divider(
                                  height: index < answers.length ? 1.0 : 0.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
