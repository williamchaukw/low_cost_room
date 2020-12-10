import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:path/path.dart';
// import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:intl/intl.dart';

import '../parse.dart' as parse;

class PropertyItem {
  final String id;
  final String name;
  final String location;
  final String image;
  final double price;
  final String type;
  // final List<File> uploadImageFiles;
  final List<String> downloadImageUrl;
  final List<File> downloadImageFiles;
  final String createdUserId;
  final String createdUser;
  final String contactNumber;
  final DateTime createdDate;
  final File uploadImageFile_1;
  final File uploadImageFile_2;
  final File uploadImageFile_3;
  final File uploadImageFile_4;
  final File uploadImageFile_5;
  final File uploadImageFile_6;
  final File uploadImageFile_7;
  final File uploadImageFile_8;
  final int viewCount;

  PropertyItem({
    @required this.id,
    @required this.name,
    @required this.location,
    this.image,
    @required this.price,
    @required this.type,
    // this.uploadImageFiles,
    this.downloadImageUrl,
    this.downloadImageFiles,
    @required this.createdUserId,
    @required this.createdUser,
    @required this.contactNumber,
    this.createdDate,
    this.uploadImageFile_1,
    this.uploadImageFile_2,
    this.uploadImageFile_3,
    this.uploadImageFile_4,
    this.uploadImageFile_5,
    this.uploadImageFile_6,
    this.uploadImageFile_7,
    this.uploadImageFile_8,
    this.viewCount,
  });

  // factory PropertyItem.fromJson(Map<String, dynamic> json) {
  //   return PropertyItem(
  //       id: json["objectId"],
  //       name: json["name"],
  //       location: json["location"] ?? 'Internet',
  //       image: json["image"] != null
  //           ? json["image"]["url"]
  //           : "https://pixabay.com/images/id-3061864/",
  //       price: json["rental_rate"].toDouble(),
  //       type: json["type"] ?? 'Online',
  //       createdUserId: json["user_id"] ?? 'ABC123',
  //       createdUser: json["username"] ?? 'Unknown',
  //       contactNumber: json["contact_number"] ?? "0");
  // }

  // Map<String, dynamic> toJson() => {
  //       "name": name,
  //       "location": location,
  //       "image": image,
  //       "rental_rate": price,
  //       "type": type,
  //     };
}

class Property with ChangeNotifier {
  List<PropertyItem> _properties = [
    // PropertyItem(
    //   name: 'Condo A',
    //   location: 'Sri Petaling',
    //   image: null,
    //   price: 500,
    //   type: 'Room',
    // ),
    // PropertyItem(
    //   name: 'Condo B',
    //   location: 'Bukit Jalil',
    //   image: null,
    //   price: 800,
    //   type: 'Whole Unit',
    // ),
    // PropertyItem(
    //   name: 'Condo C',
    //   location: 'Sri Kembangan',
    //   image: null,
    //   price: 1000,
    //   type: 'Bed',
    // ),
  ];

  List<PropertyItem> _userProperty = [];

  List<PropertyItem> _searchedProperty = [];

  List<PropertyItem> get properties {
    return _properties;
  }

  List<PropertyItem> get userProperty {
    // print('<property.dart> userProperty length: ' +
    //     _userProperty.length.toString());
    return _userProperty;
  }

  List<PropertyItem> get searchedProperty {
    return _searchedProperty;
  }

  // List<PropertyItem> propertyItemFromJson(String str) {
  //   return List<PropertyItem>.from(
  //       json.decode(str).map((x) => PropertyItem.fromJson(x)));
  // }

  // String propertyItemToJson(List<PropertyItem> properties) {
  //   return json.encode(List<dynamic>.from(properties.map((x) => x.toJson())));
  // }

  PropertyItem getPropertyItem(String id) {
    return _properties.firstWhere((item) => item.id == id);
  }

  PropertyItem getSearchedPropertyItem(String id) {
    return _searchedProperty.firstWhere((item) => item.id == id);
  }

  PropertyItem getUserPropertyItem(String id) {
    return _userProperty.firstWhere((item) => item.id == id);
  }

  Future<void> increasePropertyView(String propertyId) async {
    try {
      ParseObject object = ParseObject('Property')
        ..objectId = propertyId
        ..setIncrement('view', 1);

      var response = await object.save();

      if (response.success) {
        print(response.results);
      } else {
        print(response.error);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSearchedProperties(
      String location, String type, String rate) async {
    if (type == '0')
      type = 'Room';
    else
      type = 'Whole Unit';

    double _convertedRate = double.parse(rate);

    print('<property.dart> getSearchedProperties - location: ' + location);
    print('<property.dart> getSearchedProperties - type: ' + type);
    print('<property.dart> getSearchedProperties - rate: ' + rate);

    _searchedProperty.clear();

    QueryBuilder query = QueryBuilder(ParseObject('Property'))
      ..whereContains('location', location.trim() ?? '%')
      ..whereContains('type', type ?? '%')
      // ..whereContains('rental_rate', rate ?? '%')
      ..whereLessThanOrEqualTo('rental_rate', _convertedRate);

    var queryResponse = await query.query();
    if (queryResponse.success) {
      if (queryResponse.results != null) {
        print(queryResponse.results);
        print(
            '<property.dart> getSearchedProperties - query success response length: ' +
                queryResponse.results.length.toString());
        for (var property in queryResponse.results) {
          List<String> _propertyImages = new List<String>();
          _propertyImages.add(
              property["image_1"] != null ? property["image_1"]["url"] : "");
          if (property["image_2"] != null) {
            _propertyImages.add(property["image_2"]["url"]);
            if (property["image_3"] != null) {
              _propertyImages.add(property["image_3"]["url"]);
              if (property["image_4"] != null) {
                _propertyImages.add(property["image_4"]["url"]);
                if (property["image_5"] != null) {
                  _propertyImages.add(property["image_5"]["url"]);
                  if (property["image_6"] != null) {
                    _propertyImages.add(property["image_6"]["url"]);
                    if (property["image_7"] != null) {
                      _propertyImages.add(property["image_7"]["url"]);
                      if (property["image_8"] != null) {
                        _propertyImages.add(property["image_8"]["url"]);
                      }
                    }
                  }
                }
              }
            }
          }

          PropertyItem propertyItem = new PropertyItem(
            id: property["objectId"] ?? "",
            name: property["name"] ?? "",
            location: property["location"] ?? "",
            image:
                property["image_1"] != null ? property["image_1"]["url"] : "",
            price: property["rental_rate"].toDouble(),
            type: property["type"] ?? "",
            downloadImageUrl: _propertyImages,
            createdUserId: property["user_id"],
            createdUser: property["username"],
            contactNumber: property["contact_number"],
            createdDate: property["createdAt"],
            viewCount: property["view"],
          );
          _searchedProperty.add(propertyItem);
        }
        if (_searchedProperty.length > 0) {
          _searchedProperty
              .sort((a, b) => b.createdDate.compareTo(a.createdDate));
        }
      }
    } else
      print(queryResponse.error);

    notifyListeners();
  }

  Future<void> getUserProperties(String userId) async {
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject('Property'))
            ..whereEqualTo('user_id', userId);
      // Clear user property list before insert new user property
      _userProperty.clear();

      var queryResponse = await query.query();
      if (queryResponse.success) {
        if (queryResponse.results != null) {
          for (ParseObject property in queryResponse.results) {
            List<String> _propertyImages = new List<String>();
            _propertyImages.add(
                property["image_1"] != null ? property["image_1"]["url"] : "");
            // ParseFile tempImage = await property["image"] as ParseFile
            //   ..download();
            // _propertyImageFiles.add(tempImage.file);
            // // _propertyImageFiles.add((property["image"] as ParseFile).file);
            // print('<property.dart> getUserProperties - image file: ' +
            //     (tempImage.file.toString()));
            if (property["image_2"] != null) {
              _propertyImages.add(property["image_2"]["url"]);
              if (property["image_3"] != null) {
                _propertyImages.add(property["image_3"]["url"]);

                if (property["image_4"] != null) {
                  _propertyImages.add(property["image_4"]["url"]);

                  if (property["image_5"] != null) {
                    _propertyImages.add(property["image_5"]["url"]);

                    if (property["image_6"] != null) {
                      _propertyImages.add(property["image_6"]["url"]);

                      if (property["image_7"] != null) {
                        _propertyImages.add(property["image_7"]["url"]);

                        if (property["image_8"] != null) {
                          _propertyImages.add(property["image_8"]["url"]);
                        }
                      }
                    }
                  }
                }
              }
            }

            PropertyItem propertyItem = new PropertyItem(
              id: property["objectId"] ?? "",
              name: property["name"] ?? "",
              location: property["location"] ?? "",
              image:
                  property["image_1"] != null ? property["image_1"]["url"] : "",
              price: property["rental_rate"].toDouble(),
              type: property["type"] ?? "",
              downloadImageUrl: _propertyImages,
              createdUserId: property["user_id"],
              createdUser: property["username"],
              contactNumber: property["contact_number"],
              createdDate: property["createdAt"],
              viewCount: property["view"],
            );
            _userProperty.add(propertyItem);
          }
        }
      }
      notifyListeners();

      print('<getUserProperties> success -' + queryResponse.results.toString());
      print('<getUserProperties> user properties length - ' +
          _userProperty.length.toString());
      print('<getUserProperties> error - ' + queryResponse.error.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDownloadImageFiles() async {
    try {
      QueryBuilder<ParseObject> objectQuery =
          QueryBuilder<ParseObject>(ParseObject('Property'))
            ..whereEqualTo('objectId', 'RPmmR7Ezyl');

      var queryResponse = await objectQuery.query();
      if (queryResponse.success) {
        if (queryResponse.results != null) {
          for (ParseFileBase property in queryResponse.results) {
            print(
                '<property.dart> getDownloadImageFiles - looping query response results ...');
            if (property['image'] != null) {
              print(
                  '<property.dart> getDownloadImageFiles - getting image ...');
              ParseFile image = property['image'];
              print('<property.dart> getDownloadImageFiles - image: ' +
                  image.toString());
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getProperties() async {
    // final String _baseUrl = 'https://parseapi.back4app.com/classes/Property';

    // http.Response response = await http.get(_baseUrl, headers: {
    //   'X-Parse-Application-Id': parse.applicationId,
    //   'X-Parse-REST-API-Key': parse.restApiKey,
    // });

    // print(json.decode(response.body));

    // if (response.statusCode == 200) {
    //   _properties.clear();

    //   Map<String, dynamic> responseMap = json.decode(response.body);
    //   var result = responseMap["results"];

    //   for (var property in result) {
    //     _properties.add(PropertyItem.fromJson(property));
    //   }
    // }

    // notifyListeners();

    // await Parse().initialize(
    //   parse.applicationId,
    //   'https://parseapi.back4app.com',
    //   masterKey: parse.masterKey,
    //   autoSendSessionId: true,
    //   coreStore: await CoreStoreSharedPrefsImp.getInstance(),
    // );

    _properties.clear();

    var response = await ParseObject('Property').getAll();

    if (response.success) {
      if (response.result != null) {
        for (var property in response.result) {
          // print(property.toString());
          List<String> _propertyImages = new List<String>();
          _propertyImages.add(
              property["image_1"] != null ? property["image_1"]["url"] : "");
          if (property["image_2"] != null) {
            _propertyImages.add(property["image_2"]["url"]);
            if (property["image_3"] != null) {
              _propertyImages.add(property["image_3"]["url"]);
              if (property["image_4"] != null) {
                _propertyImages.add(property["image_4"]["url"]);
                if (property["image_5"] != null) {
                  _propertyImages.add(property["image_5"]["url"]);
                  if (property["image_6"] != null) {
                    _propertyImages.add(property["image_6"]["url"]);
                    if (property["image_7"] != null) {
                      _propertyImages.add(property["image_7"]["url"]);
                      if (property["image_8"] != null) {
                        _propertyImages.add(property["image_8"]["url"]);
                      }
                    }
                  }
                }
              }
            }
          }

          PropertyItem propertyItem = new PropertyItem(
            id: property["objectId"] ?? "",
            name: property["name"] ?? "",
            location: property["location"] ?? "",
            image:
                property["image_1"] != null ? property["image_1"]["url"] : "",
            price: property["rental_rate"].toDouble(),
            type: property["type"] ?? "",
            downloadImageUrl: _propertyImages,
            createdUserId: property["user_id"],
            createdUser: property["username"],
            contactNumber: property["contact_number"],
            createdDate: property["createdAt"],
            viewCount: property["view"],
          );
          _properties.add(propertyItem);
        }
        if (_properties.length > 0) {
          _properties.sort((a, b) => b.createdDate.compareTo(a.createdDate));
        }
      }
    }
    notifyListeners();
  }

  Future<bool> submitNewProperty(PropertyItem property) async {
    // final dio.BaseOptions options = new dio.BaseOptions(
    //     baseUrl: 'https://test4appdemo.b4a.io/classes',
    //     headers: <String, String>{
    //       'X-Parse-Application-Id': parse.applicationId,
    //       'X-Parse-REST-API-Key': parse.restApiKey,
    //       'Content-Type': 'application/json',
    //     });

    // final _dio = new dio.Dio(options);

    // print(json.encode(property.toJson()));
    // print(property.uploadImageFiles[0].path);
    // print(basename(property.uploadImageFiles[0].path));
    // print(extension(property.uploadImageFiles[0].path).replaceAll('.', ''));

    // dio.FormData formData = new dio.FormData.fromMap({
    //   "name": property.name,
    //   "location": property.location,
    //   "image": await dio.MultipartFile.fromFile(
    //       property.uploadImageFiles[0].path,
    //       filename: basename(property.uploadImageFiles[0].path)),
    //   "rental_rate": property.price,
    //   "type": property.type,
    // });

    // print(formData.toString());

    // dio.Response response = await _dio.post("/Property", data: formData);
    // print(response.data.toString());

    // await Parse().initialize(
    //   parse.applicationId,
    //   'https://parseapi.back4app.com',
    //   masterKey: parse.masterKey,
    // );

    var saveProperty = ParseObject('Property')
      ..set('name', property.name)
      ..set('location', property.location)
      ..set('rental_rate', property.price)
      ..set('type', property.type)
      ..set('user_id', property.createdUserId)
      ..set('username', property.createdUser)
      ..set('contact_number', property.contactNumber);

    if (property.uploadImageFile_1 != null) {
      saveProperty..set('image_1', new ParseFile(property.uploadImageFile_1));
    }
    if (property.uploadImageFile_2 != null) {
      saveProperty..set('image_2', new ParseFile(property.uploadImageFile_2));
    }
    if (property.uploadImageFile_3 != null) {
      saveProperty..set('image_3', new ParseFile(property.uploadImageFile_3));
    }
    if (property.uploadImageFile_4 != null) {
      saveProperty..set('image_4', new ParseFile(property.uploadImageFile_4));
    }
    if (property.uploadImageFile_5 != null) {
      saveProperty..set('image_5', new ParseFile(property.uploadImageFile_5));
    }
    if (property.uploadImageFile_6 != null) {
      saveProperty..set('image_6', new ParseFile(property.uploadImageFile_6));
    }
    if (property.uploadImageFile_7 != null) {
      saveProperty..set('image_7', new ParseFile(property.uploadImageFile_7));
    }
    if (property.uploadImageFile_8 != null) {
      saveProperty..set('image_8', new ParseFile(property.uploadImageFile_8));
    }

    // if (property.uploadImageFiles.length >= 2 &&
    //     property.uploadImageFiles[1] != null) {
    //   saveProperty.set('image_2', new ParseFile(property.uploadImageFiles[1]));
    //   if (property.uploadImageFiles.length >= 3 &&
    //       property.uploadImageFiles[2] != null) {
    //     saveProperty.set(
    //         'image_3', new ParseFile(property.uploadImageFiles[2]));
    //     if (property.uploadImageFiles.length >= 4 &&
    //         property.uploadImageFiles[3] != null) {
    //       saveProperty.set(
    //           'image_4', new ParseFile(property.uploadImageFiles[3]));
    //       if (property.uploadImageFiles.length >= 5 &&
    //           property.uploadImageFiles[4] != null) {
    //         saveProperty.set(
    //             'image_5', new ParseFile(property.uploadImageFiles[4]));
    //         if (property.uploadImageFiles.length >= 6 &&
    //             property.uploadImageFiles[5] != null) {
    //           saveProperty.set(
    //               'image_6', new ParseFile(property.uploadImageFiles[5]));
    //           if (property.uploadImageFiles.length >= 7 &&
    //               property.uploadImageFiles[6] != null) {
    //             saveProperty.set(
    //                 'image_7', new ParseFile(property.uploadImageFiles[6]));
    //             if (property.uploadImageFiles.length >= 8 &&
    //                 property.uploadImageFiles[7] != null)
    //               saveProperty.set(
    //                   'image_8', new ParseFile(property.uploadImageFiles[7]));
    //           }
    //         }
    //       }
    //     }
    //   }
    // }

    var response = await saveProperty.save();

    if (response.success)
      return true;
    else
      return false;
  }

  Future<bool> updateProperty(PropertyItem property) async {
    var updateProperty = ParseObject('Property')
      ..objectId = property.id
      ..set('name', property.name)
      ..set('rental_rate', property.price)
      ..set('location', property.location)
      ..set('type', property.type);

    if (property.uploadImageFile_1 != null) {
      updateProperty..set('image_1', new ParseFile(property.uploadImageFile_1));
    }
    if (property.uploadImageFile_2 != null) {
      updateProperty..set('image_2', new ParseFile(property.uploadImageFile_2));
    }
    if (property.uploadImageFile_3 != null) {
      updateProperty..set('image_3', new ParseFile(property.uploadImageFile_3));
    }
    if (property.uploadImageFile_4 != null) {
      updateProperty..set('image_4', new ParseFile(property.uploadImageFile_4));
    }
    if (property.uploadImageFile_5 != null) {
      updateProperty..set('image_5', new ParseFile(property.uploadImageFile_5));
    }
    if (property.uploadImageFile_6 != null) {
      updateProperty..set('image_6', new ParseFile(property.uploadImageFile_6));
    }
    if (property.uploadImageFile_7 != null) {
      updateProperty..set('image_7', new ParseFile(property.uploadImageFile_7));
    }
    if (property.uploadImageFile_8 != null) {
      updateProperty..set('image_8', new ParseFile(property.uploadImageFile_8));
    }

    var response = await updateProperty.save();

    if (response.success) {
      print(response.results);
      return true;
    } else {
      print(response.error);
      return false;
    }
  }

  Future<bool> deleteProperty(String id) async {
    print('<property.dart> deleteProperty - preparing parse object ...');
    var selectedProperty = ParseObject('Property')..objectId = id;

    var response = await selectedProperty.delete();
    print('<property.dart> deleteProperty - done deleted property');
    if (response.success) {
      print(response.results);
      return true;
    } else {
      print(response.error);
      return false;
    }
  }

  void clearPropertyList() {
    _properties.clear();
    notifyListeners();
  }
}
