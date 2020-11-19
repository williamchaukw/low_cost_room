import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/property.dart';
import '../widgets/property_card.dart';
import '../screens/property_details_screen.dart';
import '../screens/search_screen.dart';

class PropertyListScreen extends StatefulWidget {
  static final route = '/property-list';
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<Property>(context);
    final deviceSize = MediaQuery.of(context).size;

    if (_isLoading) {
      propertyProvider.getProperties().then((_) {
        setState(() {
          _isLoading = !_isLoading;
        });
      });
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Murah Stay',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(SearchScreen.route);
              },
            )
          ],
        ),
        // drawer: Drawer(),
        body: RefreshIndicator(
          onRefresh: () async {
            await propertyProvider.getProperties();
          },
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : propertyProvider.properties.length > 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/homepage-image-1.png')),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            height: 200,
                            margin: EdgeInsets.all(10),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //     horizontal: 10,
                          //     vertical: 15,
                          //   ),
                          //   alignment: Alignment.centerLeft,
                          //   // child: Text(
                          //   //   'Our Top Pick',
                          //   //   style: TextStyle(fontSize: 30),
                          //   // ),
                          //   // child: RaisedButton(
                          //   //   child: Text('Test Button'),
                          //   //   onPressed: () async {
                          //   //     await propertyProvider.getDownloadImageFiles();
                          //   //   },
                          //   // ),
                          // ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: propertyProvider.properties.length,
                            itemBuilder: (ctx, length) {
                              return propertyCard(
                                propertyProvider.properties[length],
                                context,
                                false,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('No property found'),
                          SizedBox(height: 10),
                          RaisedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh),
                                  SizedBox(width: 10),
                                  Text('Refresh')
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                // await propertyProvider.getPropertyOwnerName('');
                                await propertyProvider
                                    .getProperties()
                                    .then((_) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              })
                        ],
                      ),
                    ),
        ));
  }
}
