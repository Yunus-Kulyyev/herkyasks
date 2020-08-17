import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/custom_widgets/chest_dialog.dart';
import 'package:flutterapp/custom_widgets/drawer.dart';
import 'package:flutterapp/custom_widgets/my_response.dart';
import 'package:flutterapp/custom_widgets/question_card.dart';
import 'package:flutterapp/custom_widgets/question_card_list.dart';
import 'package:flutterapp/custom_widgets/shake_view.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/models/history_model.dart';
import 'package:flutterapp/models/survey_model.dart';
import 'package:flutterapp/survey.dart';
import 'package:flutterapp/user_authentication/authentication.dart';
import 'package:flutterapp/user_authentication/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  FirebaseUser user;
  BaseAuth auth;

  MyHomePage(this.auth);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

final databaseReference = FirebaseDatabase.instance.reference();

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  List<QuestionCard> _questionCardList;
  List<SurveyModel> _questions;
  bool areQuestionsLoaded = false;
  int keyNumber;
  Map<String, bool> completedMap;
  List<HistoryModel> historyList;

  String currentKeyCode;
  ShakeController _shakeController;
  AnimationController pulseAnimation;
  List<String> imageLinks;
  QuestionCardList questionCardListWidget;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _shakeController = ShakeController(vsync: this);
    getUserAndData();

    currentKeyCode = 'none';
    imageLinks = new List();
    keyNumber = 0;
    completedMap = new Map();


    initAnimations();
    super.initState();
  }

  Animation motionAnimation;
  double animSize = 20;
  void initAnimations() {
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
    pulseAnimation.addListener(() {
      setState(() {
        animSize = pulseAnimation.value * 250;
      });
    });
    motionAnimation = CurvedAnimation(
      parent: pulseAnimation,
      curve: Curves.ease,
    );
  }


  @override
  void dispose() {
    _shakeController.dispose();
    pulseAnimation.dispose();
    super.dispose();
  }

  Future<void> getUserAndData() async {
    widget.user = await FirebaseAuth.instance.currentUser();
    getData();
  }

  void getData() {
    keyNumber = 0;
    historyList = new List();
    _questions = new List();
    _questionCardList = new List();
    questionCardListWidget = new QuestionCardList(areQuestionsLoaded, _questionCardList);

    databaseReference.child('Users').child(widget.user.uid).once().then((DataSnapshot dataSnap) {
      Map<dynamic, dynamic> resultsMap = dataSnap.value;
      resultsMap.forEach((key, value) {
        if(key == 'Responses') {
          Map<dynamic, dynamic> responseMap = value;
          responseMap.forEach((key2, value2) {
            completedMap[key2] = true;
            Map<String, String> hist = new Map();
            Map<dynamic, dynamic> eachQMap = value2;
            eachQMap.forEach((key3, value3) {
              hist[key3] = value3.toString();
            });
            historyList.add(new HistoryModel(surveyName: key2, responses: hist));
          });
        } else if(key == 'Keys') {
          Map<dynamic, dynamic> responseMap = value;
          responseMap.forEach((key2, value2) {
            if(value2.toString() == 'true') {
              currentKeyCode = key2;
              keyNumber++;
            }
          });
        }
      });
    });

    databaseReference.child('Surveys').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> surveyMap = snapshot.value;
      surveyMap.forEach((key, value) {
       _questions.add(new SurveyModel(key, value));
      });

      areQuestionsLoaded = true;
      loadCards();
    });
  }

  void countKeys() {
    keyNumber = 0;
    databaseReference.child('Users').child(widget.user.uid).once().then((DataSnapshot dataSnap) {
      dataSnap.value.forEach((key, value) {
        if(key == 'Keys') {
          value.forEach((key2, value2) {
            if(value2.toString() == 'true') {
              currentKeyCode = key2;
              keyNumber++;
            }
          });
        }
      });
    });
  }

  void loadCards() {
    Future.delayed(const Duration(milliseconds: 1000), ()  {
      for (int i = 0; i < _questions.length; i++) {
        bool completed = false;
        if(completedMap[_questions[i].getTitle()] == true) {
          completed = true;
        }
        _questionCardList.add(new QuestionCard(
          name: _questions[i].getTitle(),
          dueDate: _questions[i].getDate(),
          status: _questions[i].getAvailable(),
          questionIndex: i + 1,
          prizeKey: _questions[i].getPrize(),
          surveyHandler: () => startSurvey(_questions[i]),
          isCompleted: completed,
        ));
      }

      _questionCardList.sort((a, b) => b.status.compareTo(a.status));

      //questionCardListWidget = null;
      Future.delayed(const Duration(seconds: 4), () {
        if(!areQuestionsLoaded) {
          getUserAndData();
        }
      });

      questionCardListWidget = new QuestionCardList(areQuestionsLoaded, _questionCardList);
    });
  }

  void startSurvey(SurveyModel currentQuestion) {
    if(currentQuestion.getAvailable() == 'false') {
      toast('The survey is closed');
      surveyPrecursor('The survey is already closed');
    } else if(completedMap[currentQuestion.getTitle()] == true) {
      toast('You already completed this survey');
      //surveyPrecursor('You have already completed the survey!');
      for(HistoryModel model in historyList) {
        if(currentQuestion.getTitle() == model.surveyName) {
          //toast(model.responses.length.toString());
          showMyResultsDialog(model);
        }
      }
      //getImages();
    } else {
     /* Navigator.push(context,
          MaterialPageRoute(builder: (context) => Survey(currentQuestion)));*/
      Navigator
          .push(
        context,
        new MaterialPageRoute(builder: (context) => new Survey(currentQuestion))).then((value) {
          setState(() {
            areQuestionsLoaded = false;
            _questionCardList = new List();
            getData();
          });
      });
    }
  }

  Future<void> showMyResultsDialog(HistoryModel hist) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          /*content: myResults,*/
          content: Container(
            width: 300,
            height: 500,
            child: Center(child: new MyResponseWidget(hist)),
          ),
        );
      },
    );
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
                MaterialPageRoute(builder: (context) => Login(widget.auth)),
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
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
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
        drawer: CustomDrawer(alertDialog, widget.user, widget.auth),
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
                                keyNumber.toString(),
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
                                'Treasure Key',
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
                        Column(
                          children: [
                            ShakeView(
                              controller: _shakeController,
                              child: Container(
                                height: 75.0,
                                width: 75.0,
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: new ExactAssetImage('assets/treasure.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    //getData();
                                    if(keyNumber == 0) {
                                      _shakeController.shake();
                                      toast("You need key to unlock!");
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => new ChestDialog(currentKeyCode, databaseReference))).whenComplete((){
                                            countKeys();
                                            setState(() {
                                            });
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Text("Click to open chest",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
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
              questionCardListWidget != null ? questionCardListWidget.getCardsListWidget() : SizedBox(height: 10),
            ],
          ),
        ),
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
    databaseReference.child('Prizes').child(currentKeyCode).once().then((DataSnapshot dataSnap) {
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
                //Navigator.pop(context);
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
