import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';

class UserScreen extends StatefulWidget {
  static final String route = '/user';
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FocusNode _contactNumberFocusNode = new FocusNode();

  TextEditingController _contactNumberController = new TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isUpdating = false;
  bool _isLoggingIn = false;
  bool _isLoggingOut = false;

  Widget displayRow(String title, String content) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: Text(
            title,
            softWrap: true,
            style: TextStyle(fontSize: 15),
          )),
          Expanded(
              child: Text(
            content,
            softWrap: true,
            style: TextStyle(fontSize: 15),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    GoogleSignInAccount account = userProvider.account;
    ParseUser loggedInUser = userProvider.loggedInAccountParse;

    // if (loggedInUser != null)
    //   print('<user_screen.dart> user contact number: ' +
    //           loggedInUser.get('contact_number') ??
    //       "");

    Future<void> updateContactNumber() async {
      _contactNumberFocusNode.unfocus();

      setState(() {
        _isUpdating = true;
      });

      if (_contactNumberController.text != "") {
        bool status = await userProvider
            .updateContactNumber(_contactNumberController.text);
        setState(() {
          _isUpdating = false;
        });
        if (status) {
          Fluttertoast.showToast(msg: 'Contact Number updated successfully');
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to update contact number. Please try again!',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        setState(() {
          _isUpdating = false;
        });
        Fluttertoast.showToast(
          msg: 'Contact Number is empty!',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
          child: account != null
              ? Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // User reminder to input contact number
                      loggedInUser.get('contact_number').toString() == "0"
                          ? Container(
                              height: 30,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Please input your contact number',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: new BoxDecoration(
                          color: Colors.orange,
                          image: DecorationImage(
                            image: NetworkImage(account.photoUrl ??
                                'http://placekitten.com/200/300'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(height: 20),
                      displayRow('Name', account.displayName),
                      SizedBox(height: 10),
                      displayRow('Email', account.email),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(child: Text('Contact Number')),
                            Expanded(
                              child: TextField(
                                controller: _contactNumberController
                                  ..text =
                                      loggedInUser.get('contact_number') == '0'
                                          ? ""
                                          : loggedInUser.get('contact_number'),
                                focusNode: _contactNumberFocusNode,
                                keyboardType: TextInputType.phone,
                                decoration:
                                    InputDecoration(hintText: 'Contact Number'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: _isUpdating
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                child: Text('Update'),
                                onPressed: () async => updateContactNumber(),
                              ),
                      ),
                      SizedBox(height: 5),
                      _isLoggingOut
                          ? Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              child: RaisedButton(
                                  color: Colors.red,
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoggingOut = true;
                                    });
                                    userProvider
                                        .handleGoogleSignOut()
                                        .then((_) {
                                      setState(() {
                                        _isLoggingOut = false;
                                      });
                                    });
                                  }),
                            )
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  height: 50,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoggingIn
                          ? Container(child: CircularProgressIndicator())
                          : SignInButton(
                              Buttons.Google,
                              elevation: 1,
                              text: 'Sign in with Google',
                              onPressed: () {
                                setState(() {
                                  _isLoggingIn = true;
                                });
                                userProvider.handleGoogleSignIn().then((_) {
                                  Fluttertoast.showToast(
                                      msg: 'You have signed in!');
                                  setState(() {
                                    _isLoggingIn = false;
                                  });
                                });
                              },
                            )
                    ],
                  ))),
    );
  }
}
