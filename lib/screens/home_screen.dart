import 'package:flutter/material.dart';
import 'package:low_cost_room/screens/user_add_property_screen.dart';

import '../screens/property_list_screen.dart';
import '../screens/user_screen.dart';
import '../screens/user_property_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static final route = '/home';
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _currentTabIndex = 0;

  final List<Widget> _navigationList = [
    PropertyListScreen(),
    UserPropertyListScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Navigator(
      //   key: _navigatorKey,
      //   onGenerateRoute: generateRoute,
      // ),
      body: _navigationList[_currentTabIndex],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentTabIndex,
      onTap: _onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inclusive),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Your Property',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),
      ],
    );
  }

  void _onTap(int tabIndex) {
    print("_onTap: " + tabIndex.toString());
    // switch (tabIndex) {
    //   case 0:
    //     _navigatorKey.currentState
    //         .pushReplacementNamed(PropertyListScreen.route);
    //     break;
    //   case 1:
    //     _navigatorKey.currentState
    //         .pushReplacementNamed(UserPropertyListScreen.route);
    //     break;
    //   case 2:
    //     _navigatorKey.currentState.pushReplacementNamed(MoreScreen.route);
    //     break;
    // }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  // Route<dynamic> generateRoute(RouteSettings settings) {
  //   print("route settings name: " + settings.name);
  //   Function widgetBuilder;
  //   switch (settings.name) {
  //     case '/more':
  //       widgetBuilder = (BuildContext context, __, ___) => MoreScreen();
  //       break;
  //     case '/property-list':
  //       widgetBuilder = (BuildContext context, __, ___) => PropertyListScreen();
  //       break;
  //     case '/user-property-list':
  //       widgetBuilder =
  //           (BuildContext context, __, ___) => UserPropertyListScreen();
  //       break;
  //     case '/user-add-property':
  //       widgetBuilder =
  //           (BuildContext context, __, ___) => UserAddPropertyScreen();
  //       break;
  //     default:
  //       widgetBuilder = (BuildContext context, __, ___) => PropertyListScreen();
  //       break;
  //   }
  //   return PageRouteBuilder(pageBuilder: widgetBuilder, settings: settings);
  // }
}
