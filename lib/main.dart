import 'package:deliva_pa/home_screen/dashboard.dart';
import 'package:deliva_pa/forgot_password/forgot_password.dart';
import 'package:deliva_pa/login/login.dart';
import 'package:deliva_pa/login/login_options.dart';
import 'package:deliva_pa/login/login_with_email.dart';
import 'package:deliva_pa/login/login_with_mobile.dart';
import 'package:deliva_pa/login/splash_page.dart';
import 'package:deliva_pa/registration/my_profile.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
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
    bool _isProfileComplete = await SharedPreferencesHelper.getPrefBool(SharedPreferencesHelper.IS_PROFILE_COMPLETE);

    if (_isLoggedin) {
      /*if(_isProfileComplete){

      }*/
      _defaultHome = new Dashboard('','');
      SharedPreferencesHelper.setPrefBool(SharedPreferencesHelper.IS_LOGGED_OUT,false);
    }/*else if(!_isProfileComplete){
      _defaultHome = new MyProfile(countryCode, mobileNo, userId);
    }*/
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
      //'/forgot': (context) => ForgotPassword(""),
      '/dashboard': (context) => Dashboard('',''),
      //'/profile': (context) => MyProfile("","",0),
    },
    //home: MyHomePage(title: 'Flutter Demo Home Page'),
    debugShowCheckedModeBanner: false,
  ));
}
