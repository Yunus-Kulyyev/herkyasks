import 'package:flutter/material.dart';

List<String> results;

class SliderTypeQuestion extends StatefulWidget {
  final List<String> surveyModel;
  final int questionIndex;
  final Key key;

  SliderTypeQuestion(this.key, this.surveyModel, this.questionIndex) : super(key: key);

  @override
  SliderTypeQuestionState createState() => SliderTypeQuestionState();

  List<String> getSelectedAnswer() {
    return results;
  }
}

class SliderTypeQuestionState extends State<SliderTypeQuestion> {
  double defaultQuestionPosition = 1.0;
  String defaultChoice = "Good";
  String currentQuestionNumber = "Question 1";
  String currentQuestionItself = "Are you satisfied with SacState cafeteria quality?";
  List<String> answers;

  void constructQuestion() {
    results = new List();
    currentQuestionNumber = 'Question ' + widget.questionIndex.toString();

    answers = new List();
    for (String each in widget.surveyModel) {
      if (each.contains('question: ')) {
        currentQuestionItself = each.substring(10);
      } else if (!each.contains('type: ') && !each.contains('question: ')) {
        answers.add(each);
      }
    }

    defaultChoice = answers[0];
    defaultQuestionPosition = answers.length.floor().toDouble();
    results.add(currentQuestionItself);
    //results.add(answers[0]);
  }

  @override
  void initState() {
    super.initState();

    constructQuestion();
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
              margin: EdgeInsets.only(top: 16.0),
              child: Text(currentQuestionItself, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                defaultChoice,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Slider(
                  value: defaultQuestionPosition,
                  onChanged: (value) {
                    setState(() {
                      defaultQuestionPosition = value.round().toDouble();
                      _getAnswerAtPosition(defaultQuestionPosition);
                      results.clear();
                      results.add(currentQuestionItself);
                      results.add(answers[defaultQuestionPosition.toInt()-1]);
                    });
                  },
                  label: '${defaultQuestionPosition.toInt()}',
                  divisions: 30,
                  min: 1.0,
                  max: answers.length.toDouble(),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  _getAnswerAtPosition(double position) {
    defaultChoice = answers[position.toInt()-1];
  }

}