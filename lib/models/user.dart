import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'property.dart';

import '../parse.dart' as parse;

class UserItem {
  final String username;
  final String email;
  final String password;
  final String contactNumber;

  UserItem({
    @required this.username,
    @required this.email,
    this.password,
    @required this.contactNumber,
  });
}

class User extends ChangeNotifier {
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //     scopes: <String>[
  //       'email',
  //     ],
  //     clientId:
  //         "918812775186-lkhs4jdnas7rusvbbbpm505g1979vitf.apps.googleusercontent.com");

  // List<UserItem> _loggedInUser = [];

  // GoogleSignInAccount _currentUser;
  ParseUser _parseUser;

  // GoogleSignInAccount get account {
  //   return _currentUser;
  // }

  ParseUser get loggedInAccountParse {
    return _parseUser;
  }

  // void createParseUser(String username, String email) {
  //   _parseUser = ParseUser.createUser(username, 'abc123', email)
  //     ..set('contact_number', '0');
  // }

  Future<void> userLoad() async {
    try {
      ParseUser currentUser = await ParseUser.currentUser();
      if (currentUser == null) {
        print('<user.dart> userLoad - user not exist. login required.');
        return null;
      } else {
        print('<user.dart> userLoad - user exist');
        _parseUser = currentUser;
        var userResult = currentUser.login();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createUser(
    String username,
    String password,
    String email,
    String contactNumber,
  ) async {
    try {
      // username = "test";
      // password = "test";
      // email = "compassionprop@gmail.com";
      QueryBuilder<ParseUser> userQuery =
          QueryBuilder<ParseUser>(ParseUser.forQuery())
            ..whereEqualTo('email', email);

      var queryResponse = await userQuery.query();

      if (queryResponse.success) {
        if (queryResponse.results != null) {
          for (var result in queryResponse.results) {
            return false;
          }
        } else {
          print("<user.dart> createUser - queryResponse success but no result");
          var _user = ParseUser.createUser(username, password, email)
            ..set('contact_number', contactNumber)
            ..signUp();
          print("<user.dart> _parseUser response - " + _parseUser.toString());
          print("<user.dart> createUser - User created successfully");
          // _loggedInUser.add(new UserItem(
          //   username: username,
          //   email: email,
          //   contactNumber: contactNumber,
          // ));
          _parseUser = _user;
          notifyListeners();
          return true;
        }
      }
      // print("<user.dart> userQuery Response - " +
      //     queryResponse.results.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<String> userLogin(String email, String password) async {
    try {
      String username = "";

      QueryBuilder<ParseUser> userQuery =
          QueryBuilder<ParseUser>(ParseUser.forQuery())
            ..whereEqualTo('email', email);

      var userResponse = await userQuery.query();

      if (userResponse.success) {
        if (userResponse.results != null) {
          for (var result in userResponse.results) {
            username = result['username'];
          }
        }
      } else {
        return 'Email not exist';
      }

      if (username != "") {
        ParseUser _loginUser = ParseUser.createUser(username, password, email);

        var queryResponse = await _loginUser.login();

        if (queryResponse.success) {
          if (queryResponse.results != null) {
            for (var userResult in queryResponse.results) {
              // _loggedInUser.add(new UserItem(
              //     username: userResult["username"],
              //     email: userResult["email"],
              //     contactNumber: userResult["contact_number"]));
              _parseUser = _loginUser;
            }
            notifyListeners();
          }
        } else {
          return queryResponse.error.message;
        }

        print("<user.dart> userLogin - " + queryResponse.success.toString());
        print("<user.dart> userLogin - " + queryResponse.results.toString());
        print("<user.dart> userLogin - " + queryResponse.error.toString());
      }

      // if (queryResponse.success) {
      //   if (queryResponse.results != null) {
      //     // print("<user.dart> userLogin - " + queryResponse.results.toString());
      //   }
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> userLogout() async {
    try {
      _parseUser.logout();
      _parseUser = null;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> handleGoogleSignIn() async {
  //   try {
  //     _currentUser = await _googleSignIn.signIn();
  //     GoogleSignInAuthentication authentication =
  //         await _currentUser.authentication;
  //     _loggedInUser = UserItem(
  //         username: _currentUser.displayName, email: _currentUser.email);
  //     print(_currentUser);
  //     //115590538612848235272

  //     // var user = ParseUser.createUser(
  //     //   _currentUser.displayName,
  //     //   'abc123',
  //     //   _currentUser.email,
  //     // );

  //     createParseUser(
  //       _currentUser.displayName,
  //       _currentUser.email,
  //     );

  //     var response = await _parseUser.signUp();
  //     if (response.success)
  //       print(response.results);
  //     else if (!response.success) {
  //       //Check if username or email taken in Back4App
  //       if (response.error.code == 202 || response.error.code == 203) {
  //         var loginInResponse = await _parseUser.login();
  //         if (loginInResponse.success) {
  //           print("<loginInResponse>" + loginInResponse.results.toString());
  //           // Property().getUserProperties(_parseUser.get('objectId')).then((_) {
  //           //   notifyListeners();
  //           // }
  //           // );
  //         } else
  //           print("<loginInResponse>" + loginInResponse.error.toString());
  //       }
  //     }

  //     // var response = await ParseUser.loginWith(
  //     //     'google',
  //     //     google(
  //     //       _googleSignIn.currentUser.id,
  //     //       authentication.accessToken,
  //     //       authentication.idToken,
  //     //     ));

  //     // if (response.success)
  //     //   print(response.result);
  //     // else
  //     //   print(response.error);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> handleGoogleSignOut() async {
  //   try {
  //     _currentUser = await _googleSignIn.signOut();
  //     ParseResponse logoutResponse = await _parseUser.logout();
  //     if (logoutResponse.success) {
  //       _parseUser = null;
  //       print("<handleGoogleSignOut> " + logoutResponse.results.toString());
  //     } else
  //       print("<handleGoogleSignOut>" + logoutResponse.error.toString());
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<bool> updateContactNumber(String contactNumber) async {
    if (_parseUser != null) {
      _parseUser.set('contact_number', contactNumber);
      // _parseUser =
      //     ParseUser(_currentUser.displayName, 'abc123', _currentUser.email)
      //       ..set('contact_number', contactNumber);
      var response = await _parseUser.update();
      if (response.success) {
        print(
            '<user.dart> updateContactNumber - user contact number has been updated');
        notifyListeners();
        return true;
      } else {
        print(
            '<user.dart> updateContactNumber - failed to update contact number');
        notifyListeners();
        return false;
      }
    } else {
      print('<user.dart> updateContactNumber - user is not logged in.');
      notifyListeners();
      return false;
    }
  }
}
