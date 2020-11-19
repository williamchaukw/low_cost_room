import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/property.dart';
import '../models/user.dart';

class PropertyDetailsScreen extends StatefulWidget {
  static final route = '/property-details';
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isInitialized = false;

  List<Widget> propertyImages(List<String> downloadPropertyImages) {
    List<Widget> _networkImages = new List<Widget>();
    if (downloadPropertyImages.length > 0) {
      for (int x = 0; x < downloadPropertyImages.length; x++) {
        _networkImages.add(new Image.network(downloadPropertyImages[x]));
        // _networkImages.add(CachedNetworkImage(
        //   imageUrl: downloadPropertyImages[x],
        //   placeholder: (context, url) => CircularProgressIndicator(),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        // ));
      }
    }
    return _networkImages;
  }

  Widget contentRow(String contentTitle, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Text(contentTitle, style: TextStyle(fontSize: 15))),
        Expanded(child: Text(content, style: TextStyle(fontSize: 15))),
      ],
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber, String message) async {
    String url() {
      return "whatsapp://send?phone=${'+6' + phoneNumber}&text=${Uri.parse(message)}";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
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
    final propertyData = Provider.of<Property>(context);
    final userProvider = Provider.of<User>(context);

    final routeData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    PropertyItem property;

    GoogleSignInAccount account = userProvider.account;

    if (routeData['isSearchResult'] as bool) {
      property = propertyData
          .getSearchedPropertyItem(routeData['property_id'] as String);
    } else {
      property =
          propertyData.getPropertyItem(routeData['property_id'] as String);
    }

    if (!_isInitialized) {
      print('<property_details_screen.dart> property id: ' + property.id);
      propertyData.increasePropertyView(property.id).then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
    }

    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      appBar: new AppBar(title: Text(property.name, softWrap: true)),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              CarouselSlider(
                  items: propertyImages(property.downloadImageUrl),
                  options: CarouselOptions(
                    height: 300,
                    aspectRatio: 16 / 9,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    enableInfiniteScroll: false,
                  )),
              SizedBox(height: 20),
              Column(
                children: [
                  contentRow('Property Name', property.name),
                  SizedBox(height: 10),
                  contentRow('Location', property.location),
                  SizedBox(height: 10),
                  contentRow('Rental Price',
                      'RM ' + property.price.toStringAsFixed(0)),
                  SizedBox(height: 10),
                  contentRow('Rental Type', property.type),
                  SizedBox(height: 10),
                  contentRow('Owner / Agent', property.createdUser),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/icons8-whatsapp-80.png',
                        height: 25.0,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10),
                      Text('WhatsApp Owner')
                    ],
                  ),
                  onPressed: () {
                    account == null
                        ? showDialog(
                            context: context,
                            builder: (ctx) => _userAlert('Please login first'))
                        : property.contactNumber == ''
                            ? showDialog(
                                context: context,
                                builder: (ctx) => _userAlert(
                                    'This owner have no contact number'))
                            : _launchWhatsApp(
                                property.contactNumber,
                                'I am interested in your property ${property.name} at ${property.location}.',
                              );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
