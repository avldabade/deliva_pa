import 'dart:async';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/forgot_password/forgot_otp.dart';
import 'package:deliva_pa/login/login.dart';
import 'package:deliva_pa/login/login_options.dart';
import 'package:deliva_pa/login/login_with_email.dart';
import 'package:deliva_pa/login/login_with_mobile.dart';
import 'package:deliva_pa/registration/my_profile.dart';
import 'package:deliva_pa/registration/registration_otp.dart';
import 'package:deliva_pa/forgot_password/reset_password.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () async {
              final resultData = await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginOptions()));
              print('resultData:: $resultData');
              if(resultData as int == Constants.popScreen)
                Navigator.of(context).pop(Constants.popScreen);
            });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    return Scaffold(
      //backgroundColor: Colors.white,

      body: Center(
        child: Image.asset('assets/images/splash_orange.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}