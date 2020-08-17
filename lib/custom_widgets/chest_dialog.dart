import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ChestDialog extends StatefulWidget {
  String keyId;
  FirebaseUser user;
  DatabaseReference databaseReference;

  ChestDialog(this.keyId, this.databaseReference);

  @override
  ChestDialogState createState() => ChestDialogState();
}

class PrizeItem {
  String name;
  String link;
  int probability;
  int quantity;
  int initQuantity;
  Widget widget;

  Widget getItemWidget() {
    return widget;
  }

  PrizeItem(this.name, this.link, this.probability, this.quantity,
      this.initQuantity) {
    widget = Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
          ),
          SizedBox(height: 16,),
          Container(
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: (probability/100.0),
              center: Text("Probability: " + probability.toString() + "%", style: TextStyle(color: Colors.black),),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
          ),
          SizedBox(height: 16,),
          Container(
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: (quantity.toDouble()/initQuantity.toDouble()),
              center: Text("Available: " + quantity.toString() + " out of " + initQuantity.toString(), style: TextStyle(color: Colors.black),),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
          ),
          SizedBox(height: 16,),
          Expanded(
            child: Container(
              child: Image.network(link, fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChestDialogState extends State<ChestDialog> with TickerProviderStateMixin{
  List<PrizeItem> prizeItems;
  List<Widget> itemWidgetsList;
  AnimationController animationController;
  AnimationController prizeAnimationController;
  Animation prizeAnimation;
  Animation<double> animation;
  List<String> keys;
  final databaseReference = FirebaseDatabase.instance.reference();

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

  @override
  void initState() {
    getImages();

    super.initState();
  }

  @override
  void dispose() {
    if(animationController != null) {
      animationController.dispose();
    }
    if(prizeAnimationController != null) {
      prizeAnimationController.dispose();
    }
    super.dispose();
  }

  Future<void> getImages() async {
    keys = new List();
    itemWidgetsList = new List();
    prizeItems = new List();

    widget.user = await FirebaseAuth.instance.currentUser();
    widget.databaseReference.child('Users').child(widget.user.uid).child('Keys').once().then((DataSnapshot dataSnap) {
      Map<dynamic, dynamic> keysMap = dataSnap.value;
      keysMap.forEach((key, value) {
        if(value.toString() == 'true') {
          keys.add(key);
        }
      });
    });

    widget.databaseReference
        .child('Prizes')
        .child('123456789')
        .once()
        .then((DataSnapshot dataSnap) {
      String link;
      String name;
      int probability;
      int quantity;
      int initQuantity;
      Map<dynamic, dynamic> resultsMap = dataSnap.value;
      resultsMap.forEach((key, value) {
        name = key;
        Map<dynamic, dynamic> responseMap = value;
        responseMap.forEach((key2, value2) {
          if (key2 == 'image') {
            link = value2.toString();
          } else if (key2 == 'probability') {
            probability = int.parse(value2.toString());
          } else if (key2 == 'quantity') {
            quantity = int.parse(value2.toString());
          } else if (key2 == 'initQuantity') {
            initQuantity = int.parse(value2.toString());
          }
        });
        PrizeItem prize =
            new PrizeItem(name, link, probability, quantity, initQuantity);
        prizeItems.add(prize);
        itemWidgetsList.add(prize.getItemWidget());
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.green),
        title:
        Text(
          'Herky Asks',
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
          decoration: BoxDecoration(
            color: Colors.white,
            image: new DecorationImage(
              image: new ExactAssetImage('assets/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 50,),
             // getStack(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(blurRadius: 2.0, color: Colors.grey)
                ]),
                child: Column(
                  children: [
                    Container(
                      height: 200.0,
                      width: 200.0,
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
                          if(keys.length == 0) {
                            toast("You have no available keys left. Answer more surveys to get keys.");
                            Navigator.pop(context);
                          } else {
                            keyConfirmation();
                          }
                        },
                      ),
                    ),
                    Text("Click to open chest",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 0.6,
                        autoPlayInterval: Duration(seconds: 2),
                        enlargeCenterPage: true,
                        height: 280
                      ),
                      items: itemWidgetsList),
                ),
              )
            ],
          )),
    );
  }

  Future<void> keyConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          /*content: myResults,*/
          title: Text('Remaining Keys: ' + keys.length.toString()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text(
                'Are you sure you want to open the chest?',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16,),
            Column(
                children: <Widget>[
                  CupertinoButton(
                    padding: EdgeInsets.all(16),
                    color: Colors.greenAccent,
                    child: Text('Yes, use my key now.'),
                    onPressed: () async {
                      Navigator.pop(context);

                      /**Implement Key Validation and Invalidation system through Firebase Database**/
                      databaseReference.child("Users").child(widget.user.uid).child("Keys").child(keys[0]).set("false");
                      keys = new List();
                      widget.databaseReference.child('Users').child(widget.user.uid).child('Keys').once().then((DataSnapshot dataSnap) {
                        Map<dynamic, dynamic> keysMap = dataSnap.value;
                        keysMap.forEach((key, value) {
                          if(value.toString() == 'true') {
                            keys.add(key);
                          }
                        });
                      });

                      keyDialog();
                    },
                  ),
                  SizedBox(height: 8,),
                  CupertinoButton(
                    padding: EdgeInsets.all(16),
                    color: Colors.redAccent,
                    child: Text('No, some other time.'),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ])
          ],
        ),
        );
      },
    );
  }


  Future<void> keyDialog() {
    Random random = new Random.secure();
    List<String> prizePool = new List();
    int quantitySum = 0;
    for(int i = 0; i < prizeItems.length; i++) {
      for(int j = 0; j < prizeItems[i].quantity; j++) {
        prizePool.add(prizeItems[i].name);
      }
      quantitySum = quantitySum + prizeItems[i].quantity;
    }

    int itemChosen = random.nextInt(quantitySum);
    int winNumber = random.nextInt(100);
    int itemPos;
    int type = 0;
    bool winOrNot = false;
    for(int i = 0; i < prizeItems.length; i++) {
      if(prizePool[itemChosen] == prizeItems[i].name) {
        if(winNumber <= prizeItems[i].probability) {
          itemPos = i;
          winOrNot = true;
        }
      }
    }

    StateSetter _stateSetter;
    prizeAnimationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    prizeAnimation = Tween<double>(begin: 0, end: -90).animate(prizeAnimationController)
      ..addListener(() {
        _stateSetter(() {});
      })..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          if(winOrNot) {
            type = 2;
          } else {
            type = 1;
          }
        }
      });

    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: -80).animate(animationController)
      ..addListener(() {
        if(_stateSetter != null) {
          _stateSetter(() {});
        }
      })
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          prizeAnimationController.forward();
        }
      });
    animationController.forward();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(  // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              _stateSetter = setState;
              return  Column(
                children: [
                  SizedBox(height: 100,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, animation.value),
                        child: Image.asset(
                          'assets/chest_top_inner.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Transform.scale(
                        scale: prizeAnimation == null ? 0 : prizeAnimation.value/-70,
                        child: Transform.translate(
                          offset: Offset(0, prizeAnimation == null ? 0 : prizeAnimation.value),
                          child: AvatarGlow(
                            glowColor: Colors.amberAccent,
                            endRadius: 100.0,
                            duration: Duration(milliseconds: 1000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 50),
                            child: Material(
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.amberAccent,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: winOrNot ? Image.network(prizeItems[itemPos].link, fit: BoxFit.contain,) : Image.asset(
                                    'assets/sad.png',
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                radius: 60.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/chest_bottom.png',
                        height: 250,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  AnimatedSwitcher(
                    switchInCurve: Curves.decelerate,
                    duration: Duration(seconds: 4),
                    child: getMessage(type),
                  ),
                  SizedBox(height: 16,),
                  getButton(type, itemPos),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget getButton(int type, int itemPos) {
    if(type == 0) {
      return SizedBox(height: 1,);
    } else if(type == 1) {
      return CupertinoButton(
        padding: EdgeInsets.all(16),
        color: Colors.redAccent,
        child: Text('Dismiss!'),
        onPressed: () async {
          Navigator.pop(context);
        },
      );
    } else {
      return CupertinoButton(
        padding: EdgeInsets.all(16),
        color: Colors.greenAccent,
        child: Text('Claim Prize!'),
        onPressed: () async {
          final Email email = Email(
            body: 'Hey, I won a ' + prizeItems[itemPos].name + "/nMy app ID: " + widget.user.uid + "\nStudent ID: Please enter your student ID here",
            subject: 'Prize Claim',
            recipients: ['graspery@gmail.com'],
            //cc: ['cc@example.com'],
            //bcc: ['bcc@example.com'],
            //attachmentPaths: ['/path/to/attachment.zip'],
            isHTML: false,
          );

          await FlutterEmailSender.send(email);
          Navigator.pop(context);
        },
      );
    }

    setState(() {
    });
  }

  Widget getMessage(int type) {
    if(type == 0) {
      return Container(
        key: UniqueKey(),
        child: Text('🙏🙏🙏',textAlign: TextAlign.center, style: TextStyle(fontSize: 50, color: Colors.white),),
      );
    } else if(type == 1) {
      return Container(
        key: UniqueKey(),
        child: Text('Sorry, but the chest is empty.',textAlign: TextAlign.center, style: TextStyle(fontSize: 30, color: Colors.white),),
      );
    } else {
      return Container(
        key: UniqueKey(),
        child: Text('Congratulations!',textAlign: TextAlign.center ,style: TextStyle(fontSize: 30, color: Colors.white),),
      );
    }
  }


}
