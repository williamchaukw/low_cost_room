import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/property.dart';

import '../screens/property_details_screen.dart';

Widget propertyCard(
  PropertyItem propertyItem,
  BuildContext context,
  bool isSearchResult,
) {
  return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: GestureDetector(
          onTap: () async {
            Navigator.of(context)
                .pushNamed(PropertyDetailsScreen.route, arguments: {
              "isSearchResult": isSearchResult,
              "property_id": propertyItem.id,
            });
          },
          child: Card(
              child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  propertyItem.image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          propertyItem.type,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'RM ' + propertyItem.price.toStringAsFixed(0),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          propertyItem.name,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          propertyItem.location,
                          softWrap: true,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Created date: ' +
                              DateFormat('yyyy-MM-dd')
                                  .format(propertyItem.createdDate),
                          softWrap: true,
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    ],
                  )),
            ],
          ))));
}
