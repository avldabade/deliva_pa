import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/podo/response_podo_s.dart';
import 'package:deliva_pa/registration/registration.dart';
import 'package:deliva_pa/forgot_password/reset_password.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:toast/toast.dart';

import '../constants/Constant.dart';

class LoginMobileOTP extends StatefulWidget {
  final String countryCode;
  final String mobileNo;
  //final String otp;

  LoginMobileOTP(this.countryCode, this.mobileNo, {Key key})
      : super(key: key);
  @override
  _LoginMobileOTPState createState() => _LoginMobileOTPState();
}

class _LoginMobileOTPState extends State<LoginMobileOTP> {
  TextEditingController controller = TextEditingController();
  String otpText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  bool _isInProgress=false;

  bool _isSubmitPressed=false;

  Timer _timer;
  int _start = Constants.OTP_TIMER;

  String _OTPErrorMsg=StringValues.blankOTP;
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    return Material(
      //resizeToAvoidBottomPadding: false,
      /* appBar: AppBar(
        backgroundColor: Color(ColorValues.white),
        title: Text(
          StringValues.TEXT_ENTER_OTP,
          style: TextStyle(color: Color(ColorValues.black)),
        ),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Color(ColorValues.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),*/
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Utils().commonAppBar(StringValues.TEXT_ENTER_OTP,context),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(24.0),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              children: <Widget>[
                                Image(
                                  image: new AssetImage('assets/images/otp_img.png'),
                                  width: 127.0,
                                  height: 174.0,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0, bottom: 24.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    StringValues.otp_screen_msg_mobile,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(ColorValues.text_view_hint),
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:40.0,bottom: 30.0),
                                  child: _start != 0 ? Text('$_start ${StringValues.sec}',
                                    style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 20.0,fontWeight: FontWeight.w600),
                                  ):Text('${StringValues.otp_expire_msg_mobile}',
                                    style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 14.0,fontWeight: FontWeight.w600),
                                  ),
                                ),
                                PinCodeTextField(
                                  autofocus: false,
                                  pinBoxWidth: 35.0,
                                  controller: controller,
                                  hideCharacter: false,
                                  highlight: true,
                                  highlightColor: Color(ColorValues.grey_light_divider),
                                  //Colors.blue,
                                  defaultBorderColor: Color(ColorValues.grey_light_divider),
                                  //Colors.black,
                                  hasTextBorderColor: Color(ColorValues.grey_light_divider),
                                  //Colors.green,
                                  errorBorderColor: Color(ColorValues.text_red),
                                  maxLength: pinLength,
                                  hasError: hasError,
                                  maskCharacter: "😎",

                                  onTextChanged: (text) {
                                    setState(() {
                                      hasError = false;
                                    });
                                  },
                                  onDone: (text) {
                                    print("DONE $text");
                                  },
                                  //pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                                  wrapAlignment: WrapAlignment.center,
                                  pinBoxDecoration:
                                  ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                                  pinTextStyle: TextStyle(fontSize: 20.0),
                                  pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                                  pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
                                ),
                                /*Visibility(
                                  child:controller.text==""?Text(
                                    "Enter OTP",
                                    style: TextStyle(color: Colors.red),
                                  ): Text(
                                    StringValues.wrongOTP,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  visible: hasError,
                                ),*/
                                Visibility(
                                  child: Text(
                                    '$_OTPErrorMsg',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  visible: hasError,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(_start == 0){
                                      controller.clear();
                                      callGetLoginOtpApi();
                                    }
                                  },
                                  child: Text(
                                    StringValues.TEXT_RESEND_CODE,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: _start != 0 ? Color(ColorValues.text_view_hint) : Color(ColorValues.blueTheme),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                ),
                                SizedBox(
                                  width: 250.0,
                                  height: 52.0,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(30.0),
                                        side: BorderSide(
                                          color: _start != 0 ?Color(ColorValues.accentColor):Color(ColorValues.grey_hint_color),)),
                                    onPressed: () {
                                      _start != 0 ?  validateOtp():"";
                                    },
                                    color: _start != 0 ?Color(ColorValues.accentColor):Color(ColorValues.grey_hint_color),
                                    textColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(StringValues.TEXT_SUBMIT.toUpperCase(),
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _isInProgress ? CommonWidgets.getLoader(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future validateOtp() async {
    print("_isSubmitPressed:: $_isSubmitPressed");
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        bool isConnected = await Utils.isInternetConnected();
        if (isConnected) {
          _validateInputs();
        } else {
          _isSubmitPressed = false;
          //Utils.showGreenSnackBar(StringValues.INTERNET_ERROR, scaffoldKey);
          print(StringValues.INTERNET_ERROR);
          Toast.show(StringValues.INTERNET_ERROR, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } catch (exception) {
        print('exception is: ${exception}');
      }
    }
  }

/*  void _validateInputs() {
    this.otpText = controller.text;
    if (otpText.length < 4 ||
        otpText.isEmpty ||
        otpText.compareTo("1234") != 0) {
      setState(() {
        this.hasError = true;
      });
      _isSubmitPressed = false;
    } else {
      print("OPT is correct...");
      callLoginApi();
    }
  }*/

  void _validateInputs() {
    this.otpText = controller.text;
    if (otpText.isEmpty){
      setState(() {
        this.hasError = true;
        _OTPErrorMsg = StringValues.blankOTP;
      });
      _isSubmitPressed = false;
    }
    else if (otpText.length < 4 || otpText.compareTo("1234") != 0) {
      setState(() {
        this.hasError = true;
        _OTPErrorMsg = StringValues.wrongOTP;
      });
      _isSubmitPressed = false;
    } else {
      print("OPT is correct...");
      callLoginApi();
    }
  }

  void callLoginApi() async {
    print('otpText::: $otpText');
    String encodedPassword = Utils.encodeStringToBase64(otpText);
    print('encodedPassword::: $encodedPassword');
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      //"username": _email,
      //"password": password//,
      //"deviceToken": deviceToken
    };
//http://103.76.253.133:8751/userauth/oauth/token?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL +
        Constants.LOGIN_API +
        //"?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2";
        //'?grant_type=password&username=${widget.mobileNo}&password=$encodedPassword&countryCode=$widget.countryCode&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByMobile}';
        '?grant_type=password&username=${widget.mobileNo}&password=$encodedPassword&countryCode=${widget.countryCode}&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByMobile}';
    //"?grant_type=password&username=$_email&password=$encodedPassword&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByMobile}";
    try {
      http.Response response = await http.post(dataURL,
          headers: headers, body: json.encode(requestJson));

      //if (!mounted) return;
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;

      if (response.statusCode == 200) {
        print("statusCode 200....");

        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        LoginResponse loginResponse =
        new LoginResponse.fromJson(jsonResponseMap);
        if (jsonResponseMap.containsKey("userid")) {
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.ACCESS_TOKEN, loginResponse.accessToken);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.AWS_ACCESS_KEY, loginResponse.awsAccessKeyId);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.AWS_SECRET_KEY, loginResponse.awsSecretAccessKey);
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.IS_LOGGED_IN, true);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.TOKEN_TYPE, loginResponse.tokenType);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.REFRESH_TOKEN,
              loginResponse.refreshToken);
          SharedPreferencesHelper.setPrefInt(
              SharedPreferencesHelper.EXPIRES_IN, loginResponse.expiresIn);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.SCOPE, loginResponse.scope);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.NAME, loginResponse.name);
          SharedPreferencesHelper.setPrefInt(
              SharedPreferencesHelper.USER_ID, loginResponse.userid);
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.IS_REGISTRATION_COMPLETE,
              loginResponse.isRegistrationComplete);
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.IS_ACTIVE, loginResponse.isActive);
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.isNewLogin, loginResponse.isNewLogin);
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.IS_PROFILE_COMPLETE,
              loginResponse.isProfileComplete);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.JIT, loginResponse.jti);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.USER_PASSWORD, encodedPassword);
          Toast.show("User logged in successfully.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

          //==============================
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.mobileNo, widget.mobileNo);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.countryCode, widget.countryCode);
          //===============================

          _performLogin();
        } else if (jsonResponseMap.containsKey("error")) {
          Toast.show("${loginResponse.errorDescription}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (response.statusCode == 400) {
        Toast.show(StringValues.ERROR_LOGIN, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (response.statusCode == 401) {
        Toast.show(StringValues.ERROR_LOGIN_NOT_REGISTERED, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print("statusCode error....");
        Toast.show("error code::: ${response.statusCode}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } on SocketException catch (e) {
      print('error caught: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
      Toast.show(Constants.TEXT_SERVER_EXCEPTION, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(Constants.TEXT_SERVER_EXCEPTION);
      //_view.onLoginError();
      _isSubmitPressed = false;
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;
    }
  }

  Future _performLogin() async {
    // This is just a demo, so no actual login here.
    //_saveLoginState();
    /*final result =
    await Navigator.of(context).pushReplacementNamed('/dashboard');*/
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/dashboard',
            (Route<dynamic> route) => false);

  }

  void callGetLoginOtpApi() async {
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      //"username": _mobileNo,
      //"password": password//,
      //"deviceToken": deviceToken
    };
//http://103.76.253.133:8751/userauth/oauth/token?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL +
        Constants.LOGIN_OTP_API +
        '?mobile=${widget.mobileNo}&countryCode=${widget.countryCode}&roleId=${Constants.ROLE_ID}';
    //"?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2";
    //"?grant_type=password&username=$_mobileNo&password=$encodedPassword&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}";
    try {
      http.Response response = await http.post(dataURL,
          headers: headers, body: json.encode(requestJson));

      //if (!mounted) return;
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;
      final Map jsonResponseMap = json.decode(response.body);
      //final jsonResponse = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
      APIResponse loginResponse =
      new APIResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");


        if (loginResponse.status == 200) {// success condition
          _start=Constants.OTP_TIMER;
          startTimer();
          Toast.show(loginResponse.responseMessage, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        } else if (jsonResponseMap.containsKey("error")) {
          Toast.show("${loginResponse.errorDescription}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (response.statusCode == 400) {
        Toast.show(StringValues.ERROR_LOGIN, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (response.statusCode == 401) {
        Toast.show(StringValues.ERROR_LOGIN_NOT_REGISTERED, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print("statusCode error....");
        Toast.show("error code::: ${response.statusCode}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } on SocketException catch (e) {
      print('error caught: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
      Toast.show(Constants.TEXT_SERVER_EXCEPTION, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(Constants.TEXT_SERVER_EXCEPTION);
      //_view.onLoginError();
      _isSubmitPressed = false;
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;
    }
  }

}
