import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/survey.dart';
import 'package:flutterapp/user_authentication/authentication.dart';
import 'package:flutterapp/user_authentication/signin_or_register.dart';
import 'package:flutterapp/utility/connection.dart';

void main() => runApp(MyApp());
/*
void main() {
  */
/*ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();*//*

  runApp(MyApp());

}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInOrRegister(),
      //home: SignInOrRegister(auth: new Auth()),
    );
  }
}