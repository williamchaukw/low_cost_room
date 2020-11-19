import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../screens/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  static final route = '/search';
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _radioValue = 0;
  double _sliderValue = 100;
  bool _isSearching = false;

  TextEditingController _locationController = new TextEditingController();

  FocusNode _locationFocusNode = new FocusNode();

  void _handleRadioValueChanged(int value) {
    _locationFocusNode.unfocus();
    setState(() {
      _radioValue = value;
    });
    print('<_handleRadioValueChanged> _radioValue: ' + _radioValue.toString());
  }

  void _handleSliderValueChanged(double value) {
    _locationFocusNode.unfocus();
    setState(() {
      _sliderValue = value;
    });
    print(
        '<_handleSliderValueChanged> _sliderValue: ' + _sliderValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    final propertyData = Provider.of<Property>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Form(
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    RichText(
                        text: TextSpan(
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                          TextSpan(text: 'Rental Rate  '),
                          TextSpan(
                              text: 'RM ' + _sliderValue.round().toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ])),
                    Expanded(
                      child: Slider(
                        value: _sliderValue,
                        min: 100,
                        max: 500,
                        label: _sliderValue.round().toString(),
                        onChanged: _handleSliderValueChanged,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: _isSearching
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          child: Text('Start Search'),
                          onPressed: () async {
                            _locationFocusNode.unfocus();
                            setState(() {
                              _isSearching = true;
                            });
                            propertyData
                                .getSearchedProperties(
                              _locationController.text,
                              _radioValue.toString(),
                              _sliderValue.toString(),
                            )
                                .then((_) {
                              setState(() {
                                _isSearching = false;
                              });
                              Navigator.of(context)
                                  .pushNamed(SearchResultScreen.route);
                            });
                          },
                        ),
                )
              ],
            ),
          )),
    );
  }
}
