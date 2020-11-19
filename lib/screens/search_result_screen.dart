import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../widgets/property_card.dart';

class SearchResultScreen extends StatefulWidget {
  static final route = '/search-screen';
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<Property>(context);
    List<PropertyItem> searchProperty = propertyProvider.searchedProperty;

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title: Text('Search Result')),
      body: searchProperty.length > 0
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'Total ' +
                          searchProperty.length.toString() +
                          ' search result(s)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchProperty.length,
                      itemBuilder: (ctx, cnt) {
                        return propertyCard(
                          searchProperty[cnt],
                          context,
                          true,
                        );
                      })
                ]),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('No search result', textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text('Please input new search criteria',
                      textAlign: TextAlign.center)
                ],
              ),
            ),
    );
  }
}
