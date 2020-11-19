import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:image_picker/image_picker.dart';

// import '../api_key.dart' as apiKey;
import '../models/property.dart';
import '../models/user.dart';
import '../string_constants.dart';

class UserAddPropertyScreen extends StatefulWidget {
  static final String route = '/user-add-property';
  _UserAddPropertyScreenState createState() => _UserAddPropertyScreenState();
}

class _UserAddPropertyScreenState extends State<UserAddPropertyScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _rent_type = [
    'Whole Unit',
    'Room',
  ];

  // List<Asset> images = List<Asset>();
  //Image Picker
  List<File> _imageFiles = List<File>();
  final picker = ImagePicker();

  bool _haveImage = true;
  bool _isSubmitting = false;

  String _currentRentType = 'Room';

  double _latitude;
  double _longitude;

  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  File _imageFile4;
  File _imageFile5;
  File _imageFile6;
  File _imageFile7;
  File _imageFile8;

  TextEditingController _propertyNameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();

  FocusNode _propertyNameFocusNode = new FocusNode();
  FocusNode _priceFocusNode = new FocusNode();
  FocusNode _locationFocusNode = new FocusNode();

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
      // _haveImage = true;
    } else {
      return null;
    }
  }

  Widget newDisplayImage(int index, bool isCoverPage) {
    switch (index) {
      case 0:
        {
          return _imageFile1 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile1 = tempImage;
                    });
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                    margin: EdgeInsets.only(right: 10),
                    child: Center(
                        child: isCoverPage
                            ? FittedBox(
                                child: Text('Cover Page'),
                              )
                            : Icon(Icons.add)),
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile1 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile1, fit: BoxFit.contain),
                  ));
        }
      case 1:
        {
          return _imageFile2 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile2 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile2 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile2, fit: BoxFit.contain),
                  ));
        }
      case 2:
        {
          return _imageFile3 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile3 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile3 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile3, fit: BoxFit.contain),
                  ));
        }
      case 3:
        {
          return _imageFile4 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile4 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile4 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile4, fit: BoxFit.contain),
                  ));
        }
      case 4:
        {
          return _imageFile5 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile5 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile5 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile5, fit: BoxFit.contain),
                  ));
        }
      case 5:
        {
          return _imageFile6 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile6 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile6 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile6, fit: BoxFit.contain),
                  ));
        }
      case 6:
        {
          return _imageFile7 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile7 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile7 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile7, fit: BoxFit.contain),
                  ));
        }
      case 7:
        {
          return _imageFile8 == null
              ? GestureDetector(
                  onTap: () async {
                    File tempImage = await getImage();
                    setState(() {
                      _imageFile8 = tempImage;
                    });
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
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageFile8 = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.file(_imageFile8, fit: BoxFit.contain),
                  ));
        }
      default:
        return Container();
    }
  }

  // Widget displayImage(int index) {
  //   return GestureDetector(
  //     child: _imageFiles.length > 0 &&
  //             _imageFiles.length >= index + 1 &&
  //             _imageFiles[index] != null
  //         ? Container(
  //             width: 100,
  //             margin: EdgeInsets.only(right: 10),
  //             child: Image.file(_imageFiles[index], fit: BoxFit.contain),
  //           )
  //         : Container(
  //             width: 100,
  //             decoration: BoxDecoration(
  //                 border: Border.all(
  //               width: 1,
  //               color: Colors.grey,
  //             )),
  //             margin: EdgeInsets.only(right: 10),
  //             child: Center(child: Icon(Icons.add)),
  //           ),
  //     onTap: () async {
  //       _imageFiles.length > 0 &&
  //               _imageFiles.length >= index + 1 &&
  //               _imageFiles[index] != null
  //           ? removeImageFromImageFiles(index)
  //           : await getImage();
  //     },
  //   );
  // }

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
    final propertyData = Provider.of<Property>(context);
    final loggedInUser = Provider.of<User>(context).loggedInAccountParse;

    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Add New Property'),
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  _propertyNameFocusNode.unfocus();
                  _priceFocusNode.unfocus();
                  // if (_imageFiles.length == 0) {
                  //   setState(() {
                  //     _haveImage = false;
                  //   });
                  //   return;
                  // } else {
                  //   setState(() {
                  //     _haveImage = true;
                  //   });
                  // }

                  if (_formKey.currentState.validate()) {
                    if (_imageFile1 == null &&
                        _imageFile2 == null &&
                        _imageFile3 == null &&
                        _imageFile4 == null &&
                        _imageFile5 == null &&
                        _imageFile6 == null &&
                        _imageFile7 == null &&
                        _imageFile8 == null) {
                      setState(() {
                        _haveImage = false;
                      });
                      return;
                    } else {
                      PropertyItem newProperty = new PropertyItem(
                        id: "",
                        name: _propertyNameController.text,
                        location: _locationController.text,
                        price: double.parse(_priceController.text),
                        type: _currentRentType,
                        image: '',
                        // uploadImageFiles: _imageFiles,
                        createdUserId: loggedInUser.get('objectId') ?? 'ABC123',
                        createdUser: loggedInUser.get('username') ?? 'Unknown',
                        contactNumber:
                            loggedInUser.get('contact_number') ?? '0',
                        uploadImageFile_1: _imageFile1,
                        uploadImageFile_2: _imageFile2,
                        uploadImageFile_3: _imageFile3,
                        uploadImageFile_4: _imageFile4,
                        uploadImageFile_5: _imageFile5,
                        uploadImageFile_6: _imageFile6,
                        uploadImageFile_7: _imageFile7,
                        uploadImageFile_8: _imageFile8,
                      );
                      setState(() {
                        _isSubmitting = true;
                      });
                      await propertyData
                          .submitNewProperty(newProperty)
                          .then((value) {
                        if (value)
                          setState(() {
                            _isSubmitting = false;
                          });
                        Navigator.of(context).pop();
                      });
                    }
                  }
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Property Name
                    TextFormField(
                      controller: _propertyNameController,
                      focusNode: _propertyNameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Property Name',
                      ),
                      validator: (String value) {
                        if (value == '') return propertyNameMandatoryError;
                        return null;
                      },
                    ),
                    //Rental Type
                    FormField<String>(builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            hintText: 'Please select rent type'),
                        isEmpty: _currentRentType == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentRentType ?? '',
                            onChanged: (String value) {
                              setState(() {
                                _currentRentType = value;
                              });
                            },
                            items: _rent_type.map((String v) {
                              return DropdownMenuItem<String>(
                                child: Text(v),
                                value: v,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                    //Price
                    TextFormField(
                      controller: _priceController,
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                          labelText: 'Rental Rate', prefix: Text('RM ')),
                      validator: (String value) {
                        if (value != '' && int.parse(value) > 500)
                          return priceMoreThan500Error;
                        if (value == '') return priceMandatoryError;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    //Location
                    TextFormField(
                      controller: _locationController,
                      focusNode: _locationFocusNode,
                      decoration: InputDecoration(
                          labelText: _locationController.text == ''
                              ? 'Click to find your location'
                              : 'Location'),
                      validator: (String value) {
                        if (value == '') return locationMandatoryError;
                        return null;
                      },
                      onTap: () async {
                        Prediction prediction = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: 'AIzaSyAu9pmokxHrwGoFr57P3yWVQwYiFpGXEY8',
                            mode: Mode.overlay,
                            language: "en",
                            components: [Component(Component.country, "my")]);

                        Map<String, dynamic> locationMap =
                            await _getLatLng(prediction);

                        setState(() {
                          _locationController.text = locationMap["address"];
                          _latitude = locationMap["latitude"];
                          _longitude = locationMap["longitude"];
                          _locationFocusNode.unfocus();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _locationController.text == ""
                        ? Container()
                        : Container(
                            width: double.infinity,
                            height: 150,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_latitude, _longitude),
                                zoom: 16,
                              ),
                              mapType: MapType.normal,
                            )),
                    // SizedBox(height: 10),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   child: RaisedButton(
                    //     child: Text('Upload Image'),
                    //     onPressed: () async {},
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Container(
                        width: double.infinity,
                        child: Text(
                          'Property Images (Max 8)',
                          style: TextStyle(fontSize: 15),
                        ),
                        alignment: Alignment.centerLeft),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          newDisplayImage(0, true),
                          newDisplayImage(1, false),
                          newDisplayImage(2, false),
                          newDisplayImage(3, false),
                          newDisplayImage(4, false),
                          newDisplayImage(5, false),
                          newDisplayImage(6, false),
                          newDisplayImage(7, false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _haveImage
                        ? Container()
                        : Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text(atLeast1PhotoReminder,
                                style: TextStyle(color: Colors.red))),
                  ],
                ),
              ),
            ),
            _isSubmitting ? centerLoader(context) : Container(),
          ],
        )));
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
