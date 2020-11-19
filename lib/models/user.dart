import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'property.dart';

import '../parse.dart' as parse;

class UserItem {
  final String username;
  final String email;

  UserItem({
    this.username,
    this.email,
  });
}

class User extends ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
  ]);

  UserItem _loggedInUser = new UserItem();

  GoogleSignInAccount _currentUser;
  ParseUser _parseUser;

  GoogleSignInAccount get account {
    return _currentUser;
  }

  ParseUser get loggedInAccountParse {
    // print('<user.dart> loggedInAccountParse - contactNumber' +
    //     _parseUser.get('contact_number').toString());
    return _parseUser;
  }

  void createParseUser(String username, String email) {
    _parseUser = ParseUser.createUser(username, 'abc123', email)
      ..set('contact_number', '0');
  }

  Future<void> handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication authentication =
          await _currentUser.authentication;
      _loggedInUser = UserItem(
          username: _currentUser.displayName, email: _currentUser.email);
      print(_currentUser);
      //115590538612848235272

      // var user = ParseUser.createUser(
      //   _currentUser.displayName,
      //   'abc123',
      //   _currentUser.email,
      // );

      createParseUser(
        _currentUser.displayName,
        _currentUser.email,
      );

      var response = await _parseUser.signUp();
      if (response.success)
        print(response.results);
      else if (!response.success) {
        //Check if username or email taken in Back4App
        if (response.error.code == 202 || response.error.code == 203) {
          var loginInResponse = await _parseUser.login();
          if (loginInResponse.success) {
            print("<loginInResponse>" + loginInResponse.results.toString());
            // Property().getUserProperties(_parseUser.get('objectId')).then((_) {
            //   notifyListeners();
            // }
            // );
          } else
            print("<loginInResponse>" + loginInResponse.error.toString());
        }
      }

      // var response = await ParseUser.loginWith(
      //     'google',
      //     google(
      //       _googleSignIn.currentUser.id,
      //       authentication.accessToken,
      //       authentication.idToken,
      //     ));

      // if (response.success)
      //   print(response.result);
      // else
      //   print(response.error);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> handleGoogleSignOut() async {
    try {
      _currentUser = await _googleSignIn.signOut();
      ParseResponse logoutResponse = await _parseUser.logout();
      if (logoutResponse.success) {
        _parseUser = null;
        print("<handleGoogleSignOut> " + logoutResponse.results.toString());
      } else
        print("<handleGoogleSignOut>" + logoutResponse.error.toString());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

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
