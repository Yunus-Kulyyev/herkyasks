import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/user_authentication/register.dart';
import '../main_menu.dart';
import 'authentication.dart';
import 'login.dart';

class SignInOrRegister extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}


class _SignInOrRegisterState extends State<SignInOrRegister> {

  Widget screen;
  bool isLoggedIn;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    screen = splashScreen(context);
    isLoggedIn = false;

    FirebaseAuth.instance.currentUser().then((user) {
      if(user != null) {
        print("IS EMAIL VERIFIED: " + user.isEmailVerified.toString());
        changePage();
      } else {
        thisPage();
      }
    });

    super.initState();
  }

  void thisPage() {
    Future.delayed(const Duration(milliseconds: 1500), ()  {
      setState(() {
        screen = mainScreen(context);
      });
    });
  }

  void changePage() {
    Future.delayed(const Duration(milliseconds: 1500), ()  {
      setState(() {
        isLoggedIn = true;
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage(widget.auth))
        );
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return screen;
  }

  Widget splashScreen(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Image.asset(
        'assets/sacstate.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget mainScreen(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            //TODO update background image according to your brand
            'assets/background.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.1),
                      Colors.black.withOpacity(.1),
                    ])),
          ),
          Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/sacstate.png',
                        fit: BoxFit.contain,
                        height: 250,
                        width: 200,
                      ),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 27.0,
                          fontFamily: "TrajanBold",
                          color: Colors.black54,
                          //color: Color(0xFF63513d),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        //TODO update this
                        'Join Herky Asks!',
                        style: TextStyle(
                          fontFamily: "TrajanRegular",
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login(widget.auth)),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Center(
                            child: Text(
                              "Don't have an account",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );

                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                                "Create account",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}