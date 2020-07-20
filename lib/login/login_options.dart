import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/forgot_password/forgot_password.dart';
import 'package:deliva_pa/login/login_with_email.dart';
import 'package:deliva_pa/login/login_with_mobile.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/registration/registration.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:country_code_picker/country_code_picker.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSubmitPressed = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSubmitPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.primaryColor),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));

    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(ColorValues.white),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    /*SizedBox(
                                   height: 150.0,
                                   width: MediaQuery.of(context).size.width,
                                    //child:
                                  child: Image.asset('assets/images/header_bg_rectangle.png',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),*/

                                    Container(
                                      height: 150.0,
                                      width: MediaQuery.of(context).size.width,
                                      //margin: const EdgeInsets.only(top: 24.0),
                                      //padding: const EdgeInsets.only(top: 50.0),
                                      decoration: new BoxDecoration(
                                        color: Color(ColorValues.primaryColor),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(32.0),
                                            bottomRight: Radius.circular(32.0)),
                                      ),

                                      child: Stack(
                                        children: <Widget>[
                                          /*  Image.asset(
                                          'assets/images/header_bg_center.png',
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                        ),*/
                                          Container(
                                            child: Image.asset(
                                              'assets/images/header_only_leaf.png',
                                              fit: BoxFit.fill,
                                              height: double.infinity,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                            ),
                                            margin: EdgeInsets.only(top: 50.0),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                StringValues.AAP_NAME,
                                                //textAlign: TextAlign.center,

                                                style: TextStyle(
                                                    color: Color(
                                                        ColorValues.white),
                                                    fontSize: 40.0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      margin: const EdgeInsets.only(
                                          top: 125.0, left: 24.0, right: 24.0),
                                      //, bottom: 90.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width - 48.0,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(height: 20.0,),
                                                Image(
                                                  image: new AssetImage(
                                                      'assets/images/cloud_img_orange.png'),
                                                  width: 110.0,
                                                  height: 110.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          bottom: 16.0),
                                                  child: Text(
                                                    StringValues.welcomedeliva_pa,
                                                    style: TextStyle(
                                                        color: Color(
                                                            ColorValues
                                                                .black),
                                                        fontSize: 25.0),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 25.0),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 25.0),
                                                ),
                                                GestureDetector(
                                                  onTap: _navigateToLoginWithEmail,
                                                  child: Container(
                                                    //width: 130.0,
                                                    height: 45.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      new BorderRadius.all(
                                                        Radius.circular(30.0),
                                                      ),
                                                      //color: Color(ColorValues.primaryColor),
                                                      //Color(ColorValues.primaryColor),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Color(ColorValues
                                                            .accentColor),
                                                        width: 0.5,
                                                        style: BorderStyle.solid,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Image(
                                                            image: new AssetImage(
                                                                'assets/images/email_icon.png'),
                                                            width: 22.0,
                                                            height: 22.0,
                                                            //fit: BoxFit.fitHeight,
                                                          ),
                                                          Container(width: 8.0,),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              StringValues.emailLogin,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: Color(ColorValues
                                                                    .black),
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 25.0),
                                                ),
                                                GestureDetector(
                                                  onTap: _navigateToLoginWithMobile,
                                                  child: Container(
                                                    //width: 130.0,
                                                    height: 45.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      new BorderRadius.all(
                                                        Radius.circular(30.0),
                                                      ),
                                                      //color: Color(ColorValues.primaryColor),
                                                      //Color(ColorValues.primaryColor),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Color(ColorValues
                                                            .accentColor),
                                                        width: 0.5,
                                                        style: BorderStyle.solid,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Image(
                                                            image: new AssetImage(
                                                                'assets/images/phone_icon.png'),
                                                            width: 22.0,
                                                            height: 22.0,
                                                            //fit: BoxFit.fitHeight,
                                                          ),
                                                          Container(width: 8.0,),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              StringValues.mobileLogin,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: Color(ColorValues
                                                                    .black),
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                /*GestureDetector(
                                                  onTap: (){
                                                    //validateMyProfile();
                                                    //getAlertDialog(context);
                                                    print('save clicked');
                                                  },
                                                  child: Container(
                                                   // width: 130.0,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      new BorderRadius.all(
                                                        Radius.circular(
                                                            20.0),),
                                                      //color: Color(ColorValues.primaryColor),
                                                      //Color(ColorValues.primaryColor),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Color(ColorValues
                                                            .accentColor),
                                                        width: 1,
                                                        style: BorderStyle.solid,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[

                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                          child: Text(
                                                            StringValues.TEXT_SAVE
                                                                .toUpperCase(),
                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(ColorValues.black_light),),
                                                            maxLines: 1,

                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),*/
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 25.0),
                                                ),

                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 40.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              StringValues.TEXT_ANY_ACCOUNT,
                              style: TextStyle(
                                  color: Color(ColorValues.text_view_hint),
                                  fontSize: 14.0),
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToRegistration,
                            child: Text(
                              StringValues.TEXT_REGISTER_NOW,
                              style: TextStyle(
                                  color: Color(ColorValues.blueTheme),
                                  fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //WillPopScope(child: Container(), onWillPop: callPopFun),
              //WillPopCallback
            ],
          ),
        ),
      ),
    );
  }


  Future _navigateToRegistration() async {

    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
    print('resultData:: $resultData');
    /*if(resultData as int == Constants.popScreen)
      Navigator.of(context).pop(Constants.popScreen);*/
  }
  Future _navigateToLoginWithEmail() async {
    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginEmail()),
    );
    print('resultData:: $resultData');
    /*if(resultData as int == Constants.popScreen)
      Navigator.of(context).pop(Constants.popScreen);*/
  }
  Future _navigateToLoginWithMobile() async {
    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginMobile()),
    );
    /*if(resultData as int == Constants.popScreen)
      Navigator.of(context).pop(Constants.popScreen);*/
  }

  /*Future<bool> callPopFun() async {
    print('callPOp called');
    await Navigator.of(context).pop();
    return true;
  }*/
}
