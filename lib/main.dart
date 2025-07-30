import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stay_safe/ui/screens/nearby_interface.dart';

import 'package:stay_safe/ui/screens/sign_up_screen.dart';
import 'package:stay_safe/ui/screens/walk_screen.dart';
import 'package:stay_safe/ui/screens/root_screen.dart';
import 'package:stay_safe/ui/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();
 Firestore.instance.settings(); 
 SharedPreferences.getInstance().then((prefs) {    
  
    runApp(MyApp(prefs: prefs));
  });}

class MyApp extends StatelessWidget {
 final SharedPreferences prefs;
 MyApp({this.prefs});
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StaySafe',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/root': (BuildContext context) => new RootScreen(),
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
        '/nearby': (BuildContext context) => new NearbyInterface(),
     },
     theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
      ),
      home: _handleCurrentScreen(),
    );
}

 Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
     return new RootScreen();
    } else {
      return new WalkthroughScreen(prefs: prefs);
   }
 }
}
