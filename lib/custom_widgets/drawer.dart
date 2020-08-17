import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutterapp/invite_friend.dart';
import 'package:flutterapp/user_authentication/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDrawer extends StatelessWidget {
  final Function alertDialogHandler;
  final FirebaseUser user;
  final BaseAuth auth;

  CustomDrawer(this.alertDialogHandler, this.user, this.auth);


  Future<void> inviteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: InviteFriend(),
          ),
        );
      },
    );
  }


  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('assets/background.png'),
                fit: BoxFit.fill,
              ),
          ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Image.asset(
                  'assets/sacstate.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ListTile(
              title: Text('User ID'),
              subtitle: SelectableText(user.uid),
            ),
            ListTile(
              title: Text('User email'),
              subtitle: SelectableText(user.email),
            ),
            ListTile(
              title: Text('Invite Friends'),
              onTap: () {
                inviteDialog(context);
                /*Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new InviteFriend()));*/
              },
            ),
            Spacer(), // use
            ListTile(
              title: Text('Terms & Conditions',
                style: TextStyle(
                    color: Colors.white
                ),),
            ),// this
            ListTile(
              title: Text('Sign Out',
              style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: () {
                alertDialogHandler(0);
              },
            ),
            ListTile(
              title: Text('Reset Password',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onTap: () {
                auth.resetPassword(user.email);
                toast("Check your email for password reset");
              },
            ),
            ListTile(
              title: Text('Delete Account',
                style: TextStyle(
                    color: Colors.redAccent
                ),
              ),
              onTap: () async {
                alertDialogHandler(1);
              },
            ),
          ],
        ),
      )
    );
  }

}
