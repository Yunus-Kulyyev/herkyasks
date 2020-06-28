import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/survey_model.dart';
import 'package:flutterapp/user_authentication/authentication.dart';

class ChartPage extends StatelessWidget {
  BaseAuth auth;
  SurveyModel surveyModel;
  final databaseReference = FirebaseDatabase.instance.reference();

  ChartPage(BaseAuth auth, SurveyModel surveyModel) {
    this.auth = auth;
    this.surveyModel = surveyModel;
  }

  /*void getData() {
    _questions = new List();
    _questionCardList = new List();

    //Check if user completed any of the surveys
    databaseReference.child('Results').child(surveyModel.getTitle()).once().then((DataSnapshot dataSnap) {
      Map<dynamic, dynamic> resultsMap = dataSnap.value;
      resultsMap.forEach((key, value) {
        completedMap[key] = true;
      });
    });

    databaseReference.child('Surveys').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> surveyMap = snapshot.value;
      surveyMap.forEach((key, value) {
        _questions.add(new SurveyModel(key, value));
      });

      areQuestionsLoaded = true;

      setState(() {
        for (int i = 0; i < _questions.length; i++) {
          _questionCardList.add(new QuestionCard(
            name: _questions[i].getTitle(),
            dueDate: _questions[i].getDate(),
            status: _questions[i].getAvailable(),
            questionIndex: i + 1,
            surveyHandler: () => startSurvey(_questions[i]),
          ));
        }
      });
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return null;
  }
}

