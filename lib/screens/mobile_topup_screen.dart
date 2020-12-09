import 'package:flutter/material.dart';

class MobileTopupScreen extends StatefulWidget {
  static final route = '/mobile-topup';
  _MobileTopupScreenState createState() => _MobileTopupScreenState();
}

class _MobileTopupScreenState extends State<MobileTopupScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: deviceSize.height,
          alignment: Alignment.center,
          child: Image.asset('assets/images/mobile_pay.png'),
        )),
      ),
    );
  }
}
