import 'package:flutter/material.dart';
import 'package:flutterapp/last_page.dart';


class ImageStyleQuestion extends StatefulWidget {
  @override
  ImageStyleQuestionState createState() => ImageStyleQuestionState();
}

class ImageStyleQuestionState extends State<ImageStyleQuestion>
    with TickerProviderStateMixin {

  AnimationController _fourStepController;
  AnimationController _longPressController;
  Animation<double> longPressAnimation;
  Animation<double> fourTranformAnimation;

  @override
  void initState() {
    super.initState();

    _fourStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _longPressController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    fourTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _fourStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    longPressAnimation =
        Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
            parent: _longPressController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    _startFourStepAnimation();
  }

  @override
  void dispose() {
    _fourStepController.dispose();
    _longPressController.dispose();
    super.dispose();
  }

  Future _startLongPressAnimation() async {
    try {
      await _longPressController.forward().orCancel;
    } on TickerCanceled {}
  }

  Future _startFourStepAnimation() async {
    try {
      await _fourStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - fourTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: fourTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Question 4'),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                        'When you need help or has concerns related with our product, how satisfied are you with our customer support\'s performance?')),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 213.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 150.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
//                              onTapU
//                        onLongPress: () {
//                          _startLongPressAnimation();
//                          },
//                                onTapUp: (detail) {
//                          print(detail);
//                         _longPressController.reset();
//                      },
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    LastPage(
                                                      statusType: 'Unhappy',
                                                    )));
                                      },
                                      child: Transform.scale(
                                          scale: longPressAnimation.value,
                                          child: Hero(
                                            tag: 'Unhappy',
                                            child: Image.asset(
                                              'images/angry.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Unhappy'),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
//                              onTapU
//                        onLongPress: () {
//                          _startLongPressAnimation();
//                          },
//                                onTapUp: (detail) {
//                          print(detail);
//                         _longPressController.reset();
//                      },
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    LastPage(
                                                      statusType: 'Neutral',
                                                    )));
                                      },
                                      child: Hero(
                                        tag: 'Neutral',
                                        child: Transform.scale(
                                            scale: longPressAnimation.value,
                                            child: Image.asset(
                                              'images/mmm.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Neutral'),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
//                              onTapU
//                        onLongPress: () {
//                          _startLongPressAnimation();
//                          },
//                                onTapUp: (detail) {
//                          print(detail);
//                         _longPressController.reset();
//                      },
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    LastPage(
                                                      statusType:
                                                      'Satisfied',
                                                    )));
                                      },
                                      child: Transform.scale(
                                          scale: longPressAnimation.value,
                                          child: Hero(
                                            tag: 'Satisfied',
                                            child: Image.asset(
                                              'images/hearteyes.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Satisfied'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}