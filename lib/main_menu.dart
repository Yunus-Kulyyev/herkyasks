import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/custom_widgets/drawer.dart';
import 'package:flutterapp/custom_widgets/question_card.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/models/survey_model.dart';
import 'package:flutterapp/my_results.dart';
import 'package:flutterapp/survey.dart';
import 'package:flutterapp/user_authentication/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  FirebaseUser user;
  BaseAuth auth;

  MyHomePage(this.auth);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

final databaseReference = FirebaseDatabase.instance.reference();

class _MyHomePageState extends State<MyHomePage> {
  List<QuestionCard> _questionCardList;
  List<SurveyModel> _questions;
  bool areQuestionsLoaded = false;
  int randomNumber;
  Map<String, bool> completedMap;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    getUserAndData();

    _questionCardList = new List();
    Random random = new Random();
    randomNumber = random.nextInt(50);
    completedMap = new Map();
  }

  Future<void> getUserAndData() async {
    widget.user = await FirebaseAuth.instance.currentUser();
    getData();
  }

  void getData() {
    _questions = new List();
    _questionCardList = new List();

    //Check if user completed any of the surveys
    databaseReference.child('Users').child(widget.user.uid).child('Responses').once().then((DataSnapshot dataSnap) {
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

        _questionCardList.sort((a, b) => b.status.compareTo(a.status));
      });
    });
  }

  void startSurvey(SurveyModel currentQuestion) {
    if(currentQuestion.getAvailable() == 'false') {
      toast('The survey is closed');
      surveyPrecursor('The survey is already closed');
    } else if(completedMap[currentQuestion.getTitle()] == true) {
      toast('You already completed this survey');

      /*databaseReference.child('Users').child(widget.user.uid).child('Responses').once().then((DataSnapshot dataSnap) {
        Map<dynamic, dynamic> resultsMap = dataSnap.value;
        resultsMap.forEach((key, value) {
          if(key == currentQuestion.getTitle()) {
            Map<dynamic, dynamic> qMap = value;
            MyResults myResults = new MyResults(key, qMap);
            surveyPrecursor("You have already completed the survey!", myResults);
          }
        });
      });*/

      surveyPrecursor('You have already completed the survey!');
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Survey(currentQuestion)));
    }
    /*Navigator.push(context,
        MaterialPageRoute(builder: (context) => Survey(currentQuestion)));*/
  }

  Future<void> surveyPrecursor(String msg/*, MyResults myResults*/) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          /*content: myResults,*/
          title: Text(msg),
          actions: <Widget>[
            OutlineButton(
              child: Text('View survey results'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            OutlineButton(
              child: Text('Dismiss'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

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

  Future<void> alertDialog(int type) async {
    String getTitle() {
      if (type == 0) {
        return "Log Out";
      } else if (type == 1) {
        return "Delete Account";
      }

      return "";
    }

    String getMessage() {
      if (type == 0) {
        return "Are you sure you want to log out?";
      } else if (type == 1) {
        return "Are you sure you want to delete your account?";
      }

      return "";
    }

    FlatButton getBtn() {
      if (type == 0) {
        return FlatButton(
          child: Text('Yes, sign me out', style: TextStyle(color: Colors.redAccent),),
          onPressed: () async {
            widget.auth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false);
          },
        );
      } else if (type == 1) {
        return FlatButton(
          child: Text('Yes, delete my account', style: TextStyle(color: Colors.redAccent),),
          onPressed: () async {
            FirebaseUser user = await widget.auth.getCurrentUser();
            user.delete();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false);
          },
        );
      }

      return null;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTitle()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(getMessage())],
            ),
          ),
          actions: <Widget>[
            getBtn(),
            FlatButton(
              child: Text('No'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        drawer: CustomDrawer(alertDialog, widget.user),
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.green),
          title:
            Text(
              'Dashboard',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  color: Colors.green),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage('assets/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(blurRadius: 2.0, color: Colors.grey)
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 15.0, 5.0, 5.0),
                              child: Text(
                                'YOU HAVE',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 5.0),
                              child: Text(
                                randomNumber.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 15.0),
                              child: Text(
                                'Hornet Bucks',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 60.0),
                        Container(
                          height: 60.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent[100].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: InkWell(
                            child: Center(
                              child: Text('Get more',
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ),
                            onTap: () {
                              //getData();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Container(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(
                  'ALL SURVEYS',
                  style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
              SizedBox(height: 10.0),
              areQuestionsLoaded == true
                  ? ListView(
                primary: false,
                shrinkWrap: true,
                children: [...(_questionCardList)],
              )
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
