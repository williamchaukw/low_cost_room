import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/property.dart';
import '../screens/user_add_property_screen.dart';
import '../screens/user_property_edit_screen.dart';

class UserPropertyListScreen extends StatefulWidget {
  static final String route = '/user-property-list';
  _UserPropertyListScreenState createState() => _UserPropertyListScreenState();
}

class _UserPropertyListScreenState extends State<UserPropertyListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isInitialized = false;

  Widget propertyListTile(PropertyItem propertyItem) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(UserPropertyEditScreen.route, arguments: {
            'property_id': propertyItem.id,
          }).then((_) {
            setState(() {
              _isInitialized = false;
            });
          });
        },
        child: Card(
          child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(propertyItem.downloadImageUrl[0]),
              ),
              title: Text(propertyItem.name),
              subtitle: Text(
                propertyItem.location,
                softWrap: true,
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.keyboard_arrow_right)),
        ));
  }

  Widget _userAlert(String alertMessage) {
    return AlertDialog(
      title: Icon(Icons.warning_rounded, color: Colors.red),
      content: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 20,
        child: FittedBox(child: Text(alertMessage)),
      ),
      actions: [
        FlatButton(
            child: Text('OK'), onPressed: () => Navigator.of(context).pop())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);
    final propertyData = Provider.of<Property>(context);
    final deviceSize = MediaQuery.of(context).size;

    print('<user_property_list_screen.dart> start');

    if (userData.loggedInAccountParse != null) {
      if (!_isInitialized) {
        propertyData
            .getUserProperties(userData.loggedInAccountParse.objectId)
            .then((_) {
          setState(() {
            _isInitialized = true;
          });
        });
      }
    }

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Your Property List'),
        actions: [
          userData.loggedInAccountParse == null
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print(
                        '<user_property_list_screen.dart> loggedInAccountParse contact number: ' +
                            userData.loggedInAccountParse
                                .get('contact_number')
                                .toString());
                    if (userData.loggedInAccountParse.get('contact_number') ==
                        '0') {
                      showDialog(
                          context: context,
                          builder: (ctx) =>
                              _userAlert('Please update your contact number'));
                    } else {
                      Navigator.of(context)
                          .pushNamed(UserAddPropertyScreen.route)
                          .then((_) {
                        setState(() {
                          _isInitialized = false;
                        });
                        // propertyData
                        //     .getUserProperties(
                        //         userData.loggedInAccountParse.objectId)
                        //     .then((_) {
                        //   setState(() {
                        //     _isInitialized = true;
                        //   });
                        // });
                      });
                    }
                  },
                ),
        ],
      ),
      body: userData.loggedInAccountParse == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Please login to view your property'),
                  // SizedBox(height: 10),
                  // RaisedButton(
                  //     child: Text('Test Button'),
                  //     onPressed: () async {
                  //       propertyData.getUserProperties('Hy54bjQ0ev');
                  //     }),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _isInitialized
                      ? propertyData.userProperty.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: propertyData.userProperty.length,
                              itemBuilder: (ctx, cnt) {
                                print(
                                    '<user_property_list_screen.dart> userProperty length: ' +
                                        propertyData.userProperty.length
                                            .toString());
                                return propertyListTile(
                                    propertyData.userProperty[cnt]);
                              })
                          : Container(
                              margin: EdgeInsets.only(top: 30),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 50,
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            'Add your property now',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      SizedBox(width: 15),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                              'assets/images/right-up-arrow.png')),
                                    ],
                                  )
                                ],
                              ),
                            )
                      : Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(),
                          ),
                        )
                ],
                // child: RaisedButton(
                //   child: Text('Test Button'),
                //   onPressed: () {
                //     print(
                //         '<user_property_list_screen.dart> userProperty length:' +
                //             propertyData.userProperty.length.toString());
                //   },
                // )
              ),
            ),
    );
  }
}
