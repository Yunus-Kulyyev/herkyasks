import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RadioTypeQuestion extends StatefulWidget {
  final List<String> surveyModel;
  final int questionIndex;
  final Key key;
  List<String> results;

  RadioTypeQuestion(this.key, this.surveyModel, this.questionIndex) : super(key: key);

  @override
  RadioTypeQuestionState createState() => RadioTypeQuestionState();

  List<String> getSelectedAnswer() {
    print("YUNUS:  " + results.toString());
    return results;
  }
}

class RadioTypeQuestionState extends State<RadioTypeQuestion> {
  String _groupValue = "";
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
    widget.results = new List();
    currentQuestionNumber = 'Question ' + widget.questionIndex.toString();

    answers = new List();
    for (String each in widget.surveyModel) {
      if (each.contains('question: ')) {
        questionItself = each.substring(10);
      } else if (!each.contains('type: ') && !each.contains('question: ')) {
        answers.add(each);
      }
    }

    widget.results.add(questionItself);
    //widget.results.add(answers[0]);
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

  Widget _myRadioButton({String ans, int index}) {
    return Container(
      color: _selectedAnswer == ans
          ? Colors.greenAccent.withAlpha(100)
          : Colors.white,
      child: Column(
        children: [
          RadioListTile(
            value: ans,
            activeColor: Colors.greenAccent,
            groupValue: _groupValue,
            onChanged: (String value) {
              widget.results = new List();
              widget.results.add(questionItself);
              widget.results.add(value);
              print("Value: " + value);
              setState(() {
                _groupValue = value;
                _selectedAnswer = value;
              });
            },
            title: Text(ans),
          ),
          Divider(
            height: index < answers.length ? 1.0 : 0.0,
          ),
        ],
      ),
    );
  }

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
                        return _myRadioButton(ans: using, index: index);
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
