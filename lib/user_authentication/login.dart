import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/main_menu.dart';
import 'package:flutterapp/user_authentication/authentication.dart';
import 'package:flutterapp/user_authentication/register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  final BaseAuth auth;

  Login(this.auth);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    TextEditingController resetEmailController = TextEditingController();

    String userId = "";

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();

      super.dispose();
    }

    void toast(String msg) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
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
                child:Text("Loading..." )
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

    showResetDialog(BuildContext context){
      AlertDialog alert = AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.only(bottom: 100, top: 100),
        content: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: -150,
              child:  Image.asset(
                'assets/herky.png',
                fit: BoxFit.contain,
                height: 180,
                width: 180,
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text("Forgot Password?",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.left
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        controller: resetEmailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          icon: Icon(Icons.email),
                          hintText: 'Must be CSUS email',
                          labelText: 'Enter email',
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return !value.contains('@csus.edu') ? 'Must be CSUS email' : null;
                        },
                      ),
                      OutlineButton(child: Text("Reset passsword"), onPressed: () {

                      },),
                    ],
                  ),
                ],
              )
            ),
          ],
        )
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
      email = email.trim();
      if(email == null || password == null) {
        result = 'Please enter (@csus) email and password';
      } else {
        if(password.length >= 4) {
          if (EmailValidator.validate(email.trim())) {
            if (email.trim().split("@").contains("csus.edu")) {
              result = 'Valid CSUS email';

              try {
                userId = await widget.auth.signIn(email, password);

                /*userId = await widget.auth.signUp(email, password);
              //widget.auth.sendEmailVerification();
              //_showVerifyEmailSentDialog();
              result = 'Signed up user: $userId';*/

                if (userId.length > 0 && userId != null) {
                  result = 'Logged in successfully!';
                  //Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(widget.auth))
                  );
                }
              } catch(e) {
                Navigator.of(context, rootNavigator: true).pop();
                result = "Incorrect password or email.";
              }
            } else {
              result = 'Must be CSUS email';
            }
          } else if (!email.isNotEmpty) {
            result = 'Please enter your CSUS email';
          }
        } else {
          result = 'Password must be at least 4 characters long';
        }
      }

      toast(result);
    }


    Widget emailInputField() {
      return  new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        controller: emailController,
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
      );
    }

    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.1),
                      Colors.black.withOpacity(.1),
                    ])),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
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
                              child: emailInputField()
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
                              child: TextField(
                                controller: passwordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white70
                                  ),
                                ),
                                style: TextStyle(fontSize: 16,
                                    color: Colors.white),
                              )),
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
                        child: Center(
                            child: InkWell(
                              onTap: ()=> validateEmailPassword(emailController.text, passwordController.text),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            )),
                      ),
                     /* SizedBox(height: 16,),
                      InkWell(
                        onTap: () {
                          showResetDialog(context);
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                                "Forgot password? Recover here",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),*/
                      SizedBox(
                        height: 30,
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
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}