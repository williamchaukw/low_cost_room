import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();
  FocusNode _nameFocusNode = new FocusNode();

  TextEditingController _contactNumberController = new TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _isUpdating = false;
  bool _isLoggingIn = false;
  bool _isLoggingOut = false;
  bool _isSignUp = false;
  bool _isSigningUpAndLogging = false;

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

  Widget signInForm(double screenHeight, Function login, Function signup) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            height: screenHeight / 3,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/login-vector-art.jpg'),
                    fit: BoxFit.cover)),
            // child: Image.asset('assets/images/login-vector-art.jpg',
            //     fit: BoxFit.cover),
          ),
          _isSignUp
              ? TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == "") return "Name is required";
                    return null;
                  },
                )
              : Container(),
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == "") return "Email address is required";
              if (!value.contains("@")) return "Incorrect email format";
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
            validator: (value) {
              if (value == "") return "Password is required";
              return null;
            },
          ),
          _isSignUp
              ? TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  validator: (value) {
                    if (value == "") return "Confirm password is required";
                    if (_passwordController.text != "" &&
                        _passwordController.text != value)
                      return "Password is different. Please enter again";
                    return null;
                  },
                )
              : Container(),
          _isSignUp
              ? TextFormField(
                  controller: _contactNumberController,
                  focusNode: _contactNumberFocusNode,
                  decoration: InputDecoration(labelText: "Contact Number"),
                  validator: (value) {
                    if (value == "") return "Contact number is required";
                    // if (_passwordController.text != "" &&
                    //     _passwordController.text != value)
                    //   return "Password is different. Please enter again";
                    return null;
                  },
                )
              : Container(),
          SizedBox(height: 10),
          _isSignUp
              ? Container()
              : _isLoggingIn
                  ? Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [CircularProgressIndicator()],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        color: Colors.blue,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                        elevation: 2,
                        onPressed: () {
                          login();
                        },
                      ),
                    ),
          _isSignUp
              ? _isSigningUpAndLogging
                  ? Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [CircularProgressIndicator()],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      child: RaisedButton(
                        splashColor: Colors.white,
                        color: Colors.green,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                        elevation: 2,
                        onPressed: () {
                          signup();
                        },
                      ),
                    )
              : Container(
                  width: double.infinity,
                  child: RaisedButton(
                    splashColor: Colors.white,
                    color: Colors.blue,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red),
                    ),
                    elevation: 2,
                    onPressed: () {
                      _passwordController.text = "";
                      setState(() {
                        _isSignUp = true;
                      });
                    },
                  ),
                ),
          _isSignUp
              ? Container(
                  width: double.infinity,
                  child: RaisedButton(
                    splashColor: Colors.white,
                    color: Colors.blue,
                    child: Text(
                      'Back to login',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red),
                    ),
                    elevation: 2,
                    onPressed: () {
                      _nameController.text = "";
                      _confirmPasswordController.text = "";
                      _passwordController.text = "";
                      setState(() {
                        _isSignUp = false;
                      });
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    // GoogleSignInAccount account = userProvider.account;
    ParseUser loggedInUser = userProvider.loggedInAccountParse;

    final deviceSize = MediaQuery.of(context).size;

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

    Future<void> login() async {
      if (_formKey.currentState.validate()) {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();

        setState(() {
          _isLoggingIn = true;
        });

        String returnMessage = await userProvider.userLogin(
            _emailController.text, _passwordController.text);

        if (returnMessage != null) {
          setState(() {
            _isLoggingIn = false;
          });
          Fluttertoast.showToast(
              msg: returnMessage,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        } else {
          setState(() {
            _isLoggingIn = false;
          });
          Fluttertoast.showToast(
            msg: 'Login success',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      }
    }

    Future<void> signup() async {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isSigningUpAndLogging = true;
        });
        String message = await userProvider.createUser(
          _nameController.text,
          _passwordController.text,
          _emailController.text,
          _contactNumberController.text,
        );
        if (message != null) {
          setState(() {
            _isSigningUpAndLogging = false;
          });
          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          setState(() {
            _isSigningUpAndLogging = false;
          });
          Fluttertoast.showToast(
            msg: "Account created success! Logging in now ... ",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      }
    }

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: loggedInUser != null ? Text('User Profile') : Text('Login'),
      ),
      body: SingleChildScrollView(
          child: loggedInUser != null
              ? Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 30),
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
                            image:
                                // NetworkImage('http://placekitten.com/200/300'),
                                AssetImage('assets/images/mobile_user.png'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(height: 20),
                      displayRow('Name', loggedInUser.username),
                      SizedBox(height: 10),
                      displayRow('Email', loggedInUser.emailAddress),
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
                                keyboardType: TextInputType.number,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.red,
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoggingOut = true;
                                    });
                                    userProvider.userLogout().then((_) {
                                      _contactNumberController.clear();
                                      setState(() {
                                        _isLoggingOut = false;
                                      });
                                    });
                                    // userProvider
                                    //     .handleGoogleSignOut()
                                    //     .then((_) {
                                    //   setState(() {
                                    //     _isLoggingOut = false;
                                    //   });
                                    // });
                                  }),
                            )
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  // height: 50,
                  alignment: Alignment.center,
                  child: signInForm(
                    deviceSize.height,
                    login,
                    signup,
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _isLoggingIn
                  //         ? Container(child: CircularProgressIndicator())
                  //         : SignInButton(
                  //             Buttons.Google,
                  //             elevation: 1,
                  //             text: 'Sign in with Google',
                  //             onPressed: () {
                  //               setState(() {
                  //                 _isLoggingIn = true;
                  //               });
                  //               userProvider.handleGoogleSignIn().then((_) {
                  //                 Fluttertoast.showToast(
                  //                     msg: 'You have signed in!');
                  //                 setState(() {
                  //                   _isLoggingIn = false;
                  //                 });
                  //               });
                  //             },
                  //           )
                  //   ],
                  // ),
                )),
    );
  }
}
