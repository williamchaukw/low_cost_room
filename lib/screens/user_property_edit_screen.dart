import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/property.dart';
import '../string_constants.dart';
import '../string_constants.dart';

class UserPropertyEditScreen extends StatefulWidget {
  static final String route = '/user-property-edit';
  _UserPropertyEditScreenState createState() => _UserPropertyEditScreenState();
}

class _UserPropertyEditScreenState extends State<UserPropertyEditScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _propertyNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  FocusNode _propertyNameFocusNode = new FocusNode();
  FocusNode _locationFocusNode = new FocusNode();
  FocusNode _priceFocusNode = new FocusNode();

  List<bool> _isDeleted = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  File _imageFile4;
  File _imageFile5;
  File _imageFile6;
  File _imageFile7;
  File _imageFile8;

  int _radioValue = 0;
  double _latitude;
  double _longitude;

  bool _isInitialized = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _alertIsDeleting = false;

  List<File> _imageFiles = List<File>();
  final picker = ImagePicker();

  void _handleRadioValueChanged(int value) {
    _locationFocusNode.unfocus();
    setState(() {
      _radioValue = value;
    });
    print('<_handleRadioValueChanged> _radioValue: ' + _radioValue.toString());
  }

  Widget deleteAlert(Property propertyData, PropertyItem selectedProperty) {
    return _alertIsDeleting
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: Icon(Icons.warning_amber_sharp, color: Colors.red, size: 20),
            content: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 20,
                child: FittedBox(
                  child: Text('Are you sure to delete this property?'),
                )),
            actions: [
              FlatButton(
                onPressed: () async {
                  setState(() {
                    _alertIsDeleting = true;
                  });
                  propertyData
                      .deleteProperty(selectedProperty.id)
                      .then((value) {
                    if (value) {
                      setState(() {
                        _alertIsDeleting = false;
                      });
                      Fluttertoast.showToast(msg: 'Property has been deleted');
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: Text('Confirm'),
                color: Colors.red,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'))
            ],
          );
  }

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
      // _haveImage = true;
    } else {
      return null;
    }
  }

  Widget _displayImage(PropertyItem property, int index) {
    //existing image and no update at the same screen
    print('<user_property_edit_screen.dart> _displayImage -  _isDeleted:' +
        _isDeleted[index].toString());
    if (property.downloadImageUrl.length > index) {
      if (property.downloadImageUrl[index] != '' && !_isDeleted[index]) {
        return GestureDetector(
          child: Container(
            width: 100,
            margin: EdgeInsets.only(right: 10),
            child: Image.network(property.downloadImageUrl[index]),
          ),
          onTap: () async {
            setImage(index).then((_) {
              setState(() {
                _isDeleted[index] = true;
              });
            });
          },
        );
      }
      //existing image and new image selected at the same slot
      else if (property.downloadImageUrl[index] != '' && _isDeleted[index]) {
        if (getCorrespondingImageFile(index) == null) {
          return GestureDetector(
              onTap: () async {
                await setImage(index);
              },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Colors.grey,
                )),
                margin: EdgeInsets.only(right: 10),
                child: Center(child: Icon(Icons.add)),
              ));
        } else {
          return GestureDetector(
            child: Container(
              width: 100,
              margin: EdgeInsets.only(right: 10),
              child: Image.file(getCorrespondingImageFile(index)),
            ),
            onTap: () async {
              await setImage(index);
            },
          );
        }
      }
    } else {
      if (getCorrespondingImageFile(index) != null) {
        return GestureDetector(
          child: Container(
            width: 100,
            margin: EdgeInsets.only(right: 10),
            child: Image.file(getCorrespondingImageFile(index)),
          ),
          onTap: () async {
            await setImage(index);
          },
        );
      } else {
        return GestureDetector(
            onTap: () async {
              await setImage(index);
            },
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1,
                color: Colors.grey,
              )),
              margin: EdgeInsets.only(right: 10),
              child: Center(child: Icon(Icons.add)),
            ));
      }
    }
  }

  Future<void> setImage(int index) async {
    switch (index) {
      case 0:
        {
          File tmpImage = await getImage();
          setState(() {
            _imageFile1 = tmpImage;
          });
          break;
        }
      case 1:
        {
          File tmpImage = await getImage();
          setState(() {
            _imageFile2 = tmpImage;
          });
          break;
        }
      case 2:
        {
          File tmpImage = await getImage();
          setState(() {
            _imageFile3 = tmpImage;
          });
          break;
        }
      case 3:
        {
          File tmpImage = await getImage();

          setState(() {
            _imageFile4 = tmpImage;
          });

          break;
        }
      case 4:
        {
          File tmpImage = await getImage();

          setState(() {
            _imageFile5 = tmpImage;
          });

          break;
        }
      case 5:
        {
          File tmpImage = await getImage();

          setState(() {
            _imageFile6 = tmpImage;
          });

          break;
        }
      case 6:
        {
          File tmpImage = await getImage();

          setState(() {
            _imageFile7 = tmpImage;
          });

          break;
        }
      case 7:
        {
          File tmpImage = await getImage();

          setState(() {
            _imageFile8 = tmpImage;
          });

          break;
        }
      default:
        break;
    }
  }

  File getCorrespondingImageFile(int index) {
    switch (index) {
      case 0:
        return _imageFile1;
      case 1:
        return _imageFile2;
      case 2:
        return _imageFile3;
      case 3:
        return _imageFile4;
      case 4:
        return _imageFile5;
      case 5:
        return _imageFile6;
      case 6:
        return _imageFile7;
      case 7:
        return _imageFile8;
      default:
        return new File('');
    }
  }

  Widget centerLoader(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          strokeWidth: 4.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final propertyData = Provider.of<Property>(context);
    PropertyItem selectedProperty =
        propertyData.getUserPropertyItem(routeData['property_id']);

    if (!_isInitialized) {
      _radioValue = selectedProperty.type == 'Room' ? 0 : 1;
      setState(() {
        _isInitialized = true;
      });
    }

    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          title: Text('Edit property'),
        ),
        body: !_isInitialized
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // View Count
                              Container(
                                alignment: Alignment.centerLeft,
                                width: double.infinity,
                                height: 25,
                                child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        children: [
                                      TextSpan(text: 'This property has '),
                                      TextSpan(
                                          text: selectedProperty.viewCount
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                      TextSpan(text: ' views'),
                                    ])),
                              ),
                              // Property Name
                              TextFormField(
                                controller: _propertyNameController
                                  ..text = selectedProperty.name,
                                focusNode: _propertyNameFocusNode,
                                decoration:
                                    InputDecoration(labelText: 'Property Name'),
                                validator: (value) {
                                  if (value == '') {
                                    return propertyNameMandatoryError;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              //Rental Type
                              Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Text('Rental Type'),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChanged,
                                        ),
                                        Text('Room'),
                                        Radio(
                                          value: 1,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChanged,
                                        ),
                                        Text('Whole Unit'),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              //Price
                              TextFormField(
                                controller: _priceController
                                  ..text =
                                      selectedProperty.price.toStringAsFixed(0),
                                focusNode: _priceFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Rental Rate',
                                  prefix: Text('RM '),
                                ),
                                validator: (value) {
                                  if (value == '')
                                    return priceMandatoryError;
                                  else if (value != '' &&
                                      double.parse(value) > 500)
                                    return priceMoreThan500Error;
                                },
                              ),
                              SizedBox(height: 10),
                              //Location
                              TextFormField(
                                controller: _locationController
                                  ..text = selectedProperty.location,
                                focusNode: _locationFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                ),
                                validator: (value) {
                                  if (value == '')
                                    return locationMandatoryError;
                                },
                                onTap: () async {
                                  Prediction prediction =
                                      await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey:
                                              'AIzaSyAu9pmokxHrwGoFr57P3yWVQwYiFpGXEY8',
                                          mode: Mode.overlay,
                                          language: "en",
                                          components: [
                                        Component(Component.country, "my")
                                      ]);

                                  Map<String, dynamic> locationMap =
                                      await _getLatLng(prediction);

                                  setState(() {
                                    _locationController.text =
                                        locationMap["address"];
                                    _latitude = locationMap["latitude"];
                                    _longitude = locationMap["longitude"];
                                    _locationFocusNode.unfocus();
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              //Images

                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: Text('Images (Maximum 8)',
                                    style: TextStyle(fontSize: 15)),
                              ),

                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 150,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _displayImage(selectedProperty, 0),
                                    _displayImage(selectedProperty, 1),
                                    _displayImage(selectedProperty, 2),
                                    _displayImage(selectedProperty, 3),
                                    _displayImage(selectedProperty, 4),
                                    _displayImage(selectedProperty, 5),
                                    _displayImage(selectedProperty, 6),
                                    _displayImage(selectedProperty, 7),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  atLeast1PhotoReminder,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              SizedBox(height: 10),
                              //Update button
                              Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Text(
                                      'Update',
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          _isUpdating = true;
                                        });
                                        PropertyItem updateProperty =
                                            new PropertyItem(
                                          id: selectedProperty.id,
                                          name: _propertyNameController.text,
                                          location: _locationController.text,
                                          price: double.parse(
                                              _priceController.text),
                                          type: _radioValue == 0
                                              ? 'Room'
                                              : 'Whole Unit',
                                          createdUser:
                                              selectedProperty.createdUser,
                                          createdUserId:
                                              selectedProperty.createdUserId,
                                          contactNumber:
                                              selectedProperty.contactNumber,
                                          uploadImageFile_1: _imageFile1,
                                          uploadImageFile_2: _imageFile2,
                                          uploadImageFile_3: _imageFile3,
                                          uploadImageFile_4: _imageFile4,
                                          uploadImageFile_5: _imageFile5,
                                          uploadImageFile_6: _imageFile6,
                                          uploadImageFile_7: _imageFile7,
                                          uploadImageFile_8: _imageFile8,
                                        );

                                        await propertyData
                                            .updateProperty(updateProperty)
                                            .then((_) {
                                          setState(() {
                                            _isUpdating = false;
                                            Navigator.of(context).pop();
                                          });
                                        });
                                      }
                                    },
                                  )),
                              // SizedBox(height: 10),
                              //Delete button
                              Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0)),
                                      child: Text(
                                        'Delete',
                                      ),
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => deleteAlert(
                                                  propertyData,
                                                  selectedProperty,
                                                ));
                                      }))
                            ],
                          ),
                        )),
                  ),
                  _isUpdating || _isDeleting
                      ? centerLoader(context)
                      : Container()
                ],
              ));
  }
}

Future<Map<String, dynamic>> _getLatLng(Prediction prediction) async {
  GoogleMapsPlaces _places = new GoogleMapsPlaces(
      apiKey:
          'AIzaSyAu9pmokxHrwGoFr57P3yWVQwYiFpGXEY8'); //Same API_KEY as above
  PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(prediction.placeId);
  double latitude = detail.result.geometry.location.lat;
  double longitude = detail.result.geometry.location.lng;
  String address = prediction.description;

  Map<String, dynamic> _returnMap = {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
  };

  print("_getLatLng address: " + address);
  return _returnMap;
}
