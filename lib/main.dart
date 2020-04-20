import 'package:deliva/home_screen/dashboard.dart';
import 'package:deliva/forgot_password/forgot_password.dart';
import 'package:deliva/login/login.dart';
import 'package:deliva/login/login_options.dart';
import 'package:deliva/login/login_with_email.dart';
import 'package:deliva/login/login_with_mobile.dart';
import 'package:deliva/login/splash_page.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Set default home.
  Widget _defaultHome = new SplashScreen();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //await Utils.getVersionInfo();
  //await Utils.getDeviceToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferencesHelper.setPrefBool(SharedPreferencesHelper.IS_LOGGED_OUT,true);
  //Fabric.with(this, new Crashlytics());
  //setState(() {
  try {
    bool _isLoggedin = (prefs.getBool('isLoggedin') ?? false);
    if (_isLoggedin) {
      _defaultHome = new Dashboard();
      SharedPreferencesHelper.setPrefBool(SharedPreferencesHelper.IS_LOGGED_OUT,false);
    }
  } catch (exception) {
    print(exception);
  }

  runApp(MaterialApp(
    title: StringValues.AAP_NAME,
    theme: ThemeData(
      // This is the theme of your application.
      //
      brightness: Brightness.light,
      primaryColor: Color(ColorValues.accentColor),
      accentColor: Color(ColorValues.accentColor),

      //primarySwatch: Color(ColorValues.accentColor),
      // Define the default Font Family
      fontFamily: 'Nunito',
    ),
    initialRoute: '/',
    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/': (context) => _defaultHome,
      //MyApp(),
      // When we navigate to the "/second" route, build the SecondScreen Widget
      '/login': (context) => Login(),
      '/loginEmail': (context) => LoginEmail(),
      '/loginMobile': (context) => LoginMobile(),
      '/loginOptions': (context) => LoginOptions(),
      //'/registration': (context) => RegistraionPage(),
      '/forgot': (context) => ForgotPassword(""),
      '/dashboard': (context) => Dashboard(),
    },
    //home: MyHomePage(title: 'Flutter Demo Home Page'),
    debugShowCheckedModeBanner: false,
  ));
}
