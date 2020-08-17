import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutterapp/main_menu.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../survey.dart';
import 'authentication.dart';
import 'login.dart';

class Register extends StatefulWidget {
  //Register({this.auth, this.loginCallback});

  final BaseAuth auth = new Auth();
  //final VoidCallback loginCallback;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String userId = "";

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0
    );
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),
              child:Text("Registering..." )
          ),
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );

  }

  Future<void> validateEmailPassword(String email, String password) async {
    String result = '';
    showAlertDialog(context);

    if(email == null || password == null) {
      result = 'Please enter (@csus) email and password';
    } else {
      if(password.length >= 4) {
        if (EmailValidator.validate(email.trim())) {
          if (email.trim().split("@").contains("csus.edu")) {
            result = 'Valid CSUS email';


            try {
              userId = await widget.auth.signUp(email, password);
              result = 'Signed up user: $userId';

              if (userId.length > 0 && userId != null) {
                try {
                  await widget.auth.sendEmailVerification();
                  toast("Verification email was sent.");
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(widget.auth))
                  );
                } catch (e) {
                  print("An error occured while trying to send email verification");
                  print(e.message);
                }

                /*Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(widget.auth))
                );*/
              }
            } catch (e) {
              if (Platform.isAndroid) {
                toast(e.message);
              } else if (Platform.isIOS) {
                switch (e.code) {
                  case 'Error 17011':
                    toast("User not found");
                    break;
                  case 'Error 17009':
                    toast('Invalid Password');
                    break;
                  case 'Error 17020':
                    toast("Network error");
                    break;
                }
              }
              Navigator.of(context).pop();
            }

            /*Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage())
            );*/
          } else {
            result = 'Must be CSUS email';
            toast(result);
          }
        } else if (!email.isNotEmpty) {
          result = 'Please enter your CSUS email';
          toast(result);
        }
      } else {
        result = 'Password must be at least 4 characters long';
        toast(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    final _formKey = new GlobalKey<FormState>();
    String _email;
    String _password;

    Widget passwordInputField() {
      return new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          controller: passwordTextController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Password',
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors.white70
            ),
          ),
          style: TextStyle(fontSize: 16, color: Colors.white),
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
      );
    }

    Widget emailInputField() {
      return  new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        controller: emailTextController,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors.white70
            )
        ),
        style: TextStyle(fontSize: 16, color: Colors.white),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            //TODO update this
            'assets/background.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.1),
                      Colors.black.withOpacity(.1),
                    ])),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60),
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
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Register for Herky Asks!',
                  style: TextStyle(
                    fontFamily: "TrajanRegular",
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 22,
                              width: 22,
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: emailInputField(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 22,
                              width: 22,
                              child: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: passwordInputField()
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: InkWell(
                    child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
                        ),
                    ),
                    onTap: () {
                      validateEmailPassword(emailTextController.text, passwordTextController.text);
                    },
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
                        "Already have an account",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white),
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login(widget.auth)),
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
                          "Login",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}