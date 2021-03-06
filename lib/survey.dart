import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/question_types/check_box_question.dart';
import 'package:flutterapp/models/question_types/free_response.dart';
import 'package:flutterapp/models/question_types/radio_question.dart';
import 'package:flutterapp/models/question_types/slider_question.dart';
import 'package:flutterapp/models/survey_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Survey extends StatelessWidget {
  final SurveyModel surveyModel;
  Survey(this.surveyModel);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(surveyModel);
  }
}

class SplashScreen extends StatefulWidget {
  final SurveyModel _surveyModel;

  SplashScreen(this._surveyModel);

  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  int curIndex = 0;

  final databaseReference = FirebaseDatabase.instance.reference();
  Map<String, String> results;
  FirebaseUser user;
  int numberOfQuestions;
  List<Widget> questions;
  AnimationController pulseAnimation;
  List<String> imageLinks;


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

  void surveySetUp() {
    numberOfQuestions = widget._surveyModel.getOptions().length;
    questions = new List();
    results = new Map();

    for(int i = 0; i < numberOfQuestions; i++) {
      String type = 'single';
      for(int j = 0; j < widget._surveyModel.getOptions()[i].length; j++) {
        if(widget._surveyModel.getOptions()[i][j].contains('type: ')) {
          type = widget._surveyModel.getOptions()[i][j];
        }
      }

      if(type.contains('single')) {
        questions.add(new RadioTypeQuestion(new Key(i.toString()), widget._surveyModel.getOptions()[i], i+1));
      } else if(type.contains('checkbox')){
        questions.add(new CheckboxTypeQuestion(new Key(i.toString()), widget._surveyModel.getOptions()[i], i+1));
      } else if(type.contains('slider')) {
        questions.add(new SliderTypeQuestion(new Key(i.toString()), widget._surveyModel.getOptions()[i], i+1));
      } else if(type.contains('free')) {
        questions.add(new FreeResponseQuestion(new Key(i.toString()), widget._surveyModel.getOptions()[i], i+1));
      }
    }
  }

  void saveResults() {
    databaseReference.child("Users").child(user.uid).child("Responses").child(widget._surveyModel.getTitle()).set(results);
    databaseReference.child("Results").child(widget._surveyModel.getTitle()).child(user.uid).set(results);

    String newKey = databaseReference.push().key;
    databaseReference.child("Users").child(user.uid).child("Keys").child(
        newKey).set("true");
    /*if(widget._surveyModel.getPrize() != 'none') {
      databaseReference.child("Users").child(user.uid).child("Keys").child(
          widget._surveyModel.getPrize()).set("true");
    }*/
  }

  Future<void> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  double animSize = 20;
  @override
  void initState() {
    super.initState();

    imageLinks = new List();
    pulseAnimation = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
      lowerBound: 0.5,
    );

    pulseAnimation.forward();
    pulseAnimation.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          pulseAnimation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          pulseAnimation.forward();
        }
      });
    });
   /* pulseAnimation.addListener(() {
      setState(() {
        animSize = pulseAnimation.value * 250;
      });
    });*/

    getUser();
    surveySetUp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget finishedWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      height: 200.0,
      width:  300.0,
      child: Card(
        child: Container(
          margin: EdgeInsets.all(16.0),
            child: Center(
              child: Text('Thanks for taking the survey and helping us improve our services!',
                textAlign: TextAlign.center,
              ),
            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withAlpha(200))]),
        height: 50.0,
        child: navigationWidget(),
      )),
      body: Column(
        children: <Widget>[
          topProgressBar(_width),
          getQuestionWidget(),
        ],
      ),
    );
  }

  void manageResults() {
    List<String> temp;

    if(questions[curIndex] is RadioTypeQuestion) {
      temp = (questions[curIndex] as RadioTypeQuestion).getSelectedAnswer();

      if(temp.length > 1) {
        results[temp[0]] = temp.getRange(1, 2).toString();
      }
    } else if(questions[curIndex] is CheckboxTypeQuestion) {
      temp = (questions[curIndex] as CheckboxTypeQuestion).getSelectedAnswers();

      results[temp[0]] = temp.getRange(1, temp.length).toString();
    } else if(questions[curIndex] is SliderTypeQuestion) {
      temp = (questions[curIndex] as SliderTypeQuestion).getSelectedAnswer();

      results[temp[0]] = temp.getRange(1, 2).toString();
    } else if(questions[curIndex] is FreeResponseQuestion) {
      temp = (questions[curIndex] as FreeResponseQuestion).getSelectedAnswer();

      results[temp[0]] = temp.getRange(1, 2).toString();
    }

    if(temp.length > 1) {
      curIndex++;
    } else {
      toast(temp.toString());
      toast('Select one or more of the options');
    }
  }

  Widget navigationWidget() {
    Widget navWidget;

    if(curIndex == 0) {
      navWidget = new InkWell(
        onTap: ()=> setState((){
          manageResults();
          //curIndex++;
        }),
        child: Center(
            child: Text('Next',
              style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
            )),
      );
    } else if(curIndex == numberOfQuestions) {
      navWidget = new InkWell(
        onTap: ()=> setState((){
          saveResults();
          getImages();
          //Navigator.pop(context);
        }),
        child: Center(
            child: Text('Finish',
              style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
            )),
      );
    } else {
      navWidget = new Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: ()=> setState((){
                    curIndex--;

                  }),
                  child: Center(
                      child: Text('Previous',
                        style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: ()=> setState((){
                    manageResults();
                    //curIndex++;
                  }),
                  child: Center(
                      child: Text('Next',
                        style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                      )),
                ),
              ),
            ],
          ));
    }

    return navWidget;
  }

  Widget getQuestionWidget() {
    if(curIndex < numberOfQuestions) {
      return questions[curIndex];
    } else {
      return finishedWidget();
    }
  }

  //Progress BAR
  Widget topProgressBar(double _width) {
    return Container(
      //color: Colors.blue,               //Bar between each step in progress bar
      margin: EdgeInsets.only(top: 40.0, bottom: 30.0, left: 16.0, right: 16.0),
      height: 10.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(numberOfQuestions, (int index) {
          return Container(
            decoration: BoxDecoration(
//                    color: Colors.orangeAccent,
              color: index <= curIndex ? Colors.greenAccent : Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            height: 10.0,
            width: (_width - 32.0 - 16.0) / numberOfQuestions,
            margin: EdgeInsets.only(left: index == 0 ? 0.0 : 2.0),
          );
        }),
      ),
    );
  }

  Future<void> keyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: getKeyAnimation(),
          ),
        );
      },
    );
  }

  void getImages() {
    //toast(user.uid);
    databaseReference.child('Prizes').child('123456789').once().then((DataSnapshot dataSnap) {
      Map<dynamic, dynamic> resultsMap = dataSnap.value;
      resultsMap.forEach((key, value) {
        Map<dynamic, dynamic> responseMap = value;
        responseMap.forEach((key2, value2) {
          if(key2 == 'image') {
            imageLinks.add(value2.toString());
          }
        });
      });
      keyDialog();
    });
  }

  Widget getKeyAnimation() {
    return new Container(
      height: 500,
      width: 300,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text('You got a new key!',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "TrajanBold"
            ),
          ),
          Text('use the key to unlock the chest',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: "TrajanRegular"
            ),
          ),
          new AnimatedBuilder(
            animation: pulseAnimation,
            child: new Container(
              height: 150.0,
              width: 150.0,
              child: new Image.asset('assets/key.png',
                width: 100,
                height: 100,),
            ),
            builder: (BuildContext context, Widget _widget) {
              return new Transform.scale(
                scale: pulseAnimation.value,
                child: _widget,
              );
            },
          ),
          Text('Win one of the following items',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: "TrajanBold"
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 4, color: Colors.amber),
                borderRadius: BorderRadius.circular(10)
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1,
                autoPlayInterval: Duration(seconds: 1),
              ),
              items: imageLinks.map((item) => Container(
                child: Center(
                    child: Image.network(item, fit: BoxFit.contain, width: 750)
                ),
              )).toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
              pulseAnimation.dispose();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Center(
                  child: Text(
                    'Got it!',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

