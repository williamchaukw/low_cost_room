import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './models/property.dart';
import './models/user.dart';
import './screens/home_screen.dart';
import './screens/property_list_screen.dart';
import './screens/user_screen.dart';
import './screens/user_property_list_screen.dart';
import './screens/user_add_property_screen.dart';
import './screens/property_details_screen.dart';
import './screens/search_screen.dart';
import './screens/search_result_screen.dart';
import './screens/user_property_edit_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Property()),
        ChangeNotifierProvider.value(value: User()),
      ],
      child: MaterialApp(
        // title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          HomeScreen.route: (context) => HomeScreen(),
          PropertyListScreen.route: (context) => PropertyListScreen(),
          UserPropertyListScreen.route: (context) => UserPropertyListScreen(),
          UserAddPropertyScreen.route: (context) => UserAddPropertyScreen(),
          UserScreen.route: (context) => UserScreen(),
          PropertyDetailsScreen.route: (context) => PropertyDetailsScreen(),
          SearchScreen.route: (context) => SearchScreen(),
          SearchResultScreen.route: (context) => SearchResultScreen(),
          UserPropertyEditScreen.route: (context) => UserPropertyEditScreen(),
        },
        home: HomeScreen(),
      ),
    );
  }
}
