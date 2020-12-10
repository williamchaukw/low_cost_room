import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import './models/property.dart';
import './models/user.dart';
import './models/news.dart';
import './screens/home_screen.dart';
import './screens/property_list_screen.dart';
import './screens/user_screen.dart';
import './screens/user_property_list_screen.dart';
import './screens/user_add_property_screen.dart';
import './screens/property_details_screen.dart';
import './screens/search_screen.dart';
import './screens/search_result_screen.dart';
import './screens/user_property_edit_screen.dart';
import './screens/news_screen.dart';
import './screens/mobile_topup_screen.dart';
import './parse.dart' as parse;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    print('<main.dart> start Parse initialization');
    await Parse().initialize(
      parse.applicationId,
      'https://parseapi.back4app.com',
      masterKey: parse.masterKey,
      autoSendSessionId: true,
      coreStore: await CoreStoreSharedPrefsImp.getInstance(),
    );
    print('<main.dart> end Parse initialization');
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Property()),
        ChangeNotifierProvider.value(value: User()),
        ChangeNotifierProvider.value(value: News()),
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
          NewsScreen.route: (context) => NewsScreen(),
          MobileTopupScreen.route: (context) => MobileTopupScreen(),
        },
        home: HomeScreen(),
      ),
    );
  }
}
