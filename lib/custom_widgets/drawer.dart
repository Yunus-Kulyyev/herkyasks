import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class CustomDrawer extends StatelessWidget {
  final Function alertDialogHandler;
  final FirebaseUser user;

  CustomDrawer(this.alertDialogHandler, this.user);

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
            Spacer(), // use this
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
              title: Text('Delete Account',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onTap: () async {
                alertDialogHandler(1);
              },
            ),
          ],
        ),
        /*child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                height: 60.0,
                width: 60.0,
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
            Divider(
              endIndent: 8.0,
              indent: 8.0,
              color: Colors.grey,
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                alertDialogHandler(0);
              },
            ),
            ListTile(
              title: Text('Delete Account'),
              onTap: () async {
                alertDialogHandler(1);
              },
            ),
          ],
        ),*/
      )
    );
  }
}
