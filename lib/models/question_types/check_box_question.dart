import 'package:flutter/material.dart';

List<String> results;
List<CheckBoxModel> answers;

class CheckboxTypeQuestion extends StatefulWidget {
  final CheckboxTypeQuestionState checkboxTypeQuestionState = new CheckboxTypeQuestionState();
  final List<String> surveyModel;
  final int questionIndex;
  final Key key;

  CheckboxTypeQuestion(this.key, this.surveyModel, this.questionIndex) : super(key: key);

  List<String> getSelectedAnswers() {
    for(int i = 0; i < answers.length; i++) {
      if(answers[i].isSelected) {
        results.add(answers[i].displayContent);
      } else {
        results.removeWhere((item) => item == answers[i].displayContent);
      }
    }
    return results;
  }

  @override
  CheckboxTypeQuestionState createState() => CheckboxTypeQuestionState();
}

class CheckBoxModel {
  final String displayContent;
  bool isSelected;

  CheckBoxModel(this.displayContent, this.isSelected);
}

class CheckboxTypeQuestionState extends State<CheckboxTypeQuestion> {

  String currentQuestionNumber = "Question 2";
  String questionItself;

  void constructQuestion() {
    results = new List();
    answers = new List();
    currentQuestionNumber = 'Question ' + widget.questionIndex.toString();

    for (String each in widget.surveyModel) {
      if (each.contains('question: ')) {
        questionItself = each.substring(10);
      } else if (!each.contains('type: ') && !each.contains('question: ')) {
        answers.add(CheckBoxModel(each, false));
      }
    }

    results.add(questionItself);
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
                    margin: EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: Text(questionItself, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)),
                Center(
                    child: Container(
                      child: Card(
                        child: Column(
                          children: List.generate(answers.length,
                                  (int index) {
                                CheckBoxModel question = answers[index];
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTapUp: (detail) {
                                        setState(() {
                                          question.isSelected =
                                          !question.isSelected;
                                        });
                                      },
                                      child: Container(
                                        height: 50.0,
                                        color: question.isSelected
                                            ? Colors.orangeAccent.withAlpha(100)
                                            : Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Checkbox(
                                                activeColor: Colors.orangeAccent,
                                                value: question.isSelected,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    question.isSelected = value;
                                                    /*if(question.isSelected) {
                                                      results.add(question.displayContent);
                                                    } else {
                                                      results.removeWhere((item) => item == question.displayContent);
                                                    }*/
                                                  });
                                                }),
                                            Text(question.displayContent)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: index < answers.length
                                          ? 1.0
                                          : 0.0,
                                    ),
                                  ],
                                );
                              }),
                        ),
                    ),
                  ),
                )
              ],
        ),
      ),
    );
  }
}
