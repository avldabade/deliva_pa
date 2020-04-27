import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deliva/podo/api_response.dart';
import 'package:deliva/podo/response_podo.dart';
import 'package:deliva/podo/response_podo_s.dart';
import 'package:deliva/registration/registration.dart';
import 'package:deliva/forgot_password/reset_password.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:toast/toast.dart';

import '../constants/Constant.dart';

class ForgotOTP extends StatefulWidget {
  final String email;

  ForgotOTP(this.email, {Key key})
      : super(key: key);
  @override
  _ForgotOTPState createState() => _ForgotOTPState();
}

class _ForgotOTPState extends State<ForgotOTP> {
  TextEditingController controller = TextEditingController();
  String otpText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  bool _isInProgress=false;

  bool _isSubmitPressed=false;

  Timer _timer;
  int _start = Constants.OTP_TIMER;

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
                  Container(
                    height: 60.0,
                    //margin: EdgeInsets.only(top: 24.0),
                    child: Card(
                      margin: EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          IconButton(
                            icon: new Icon(
                              Icons.arrow_back_ios,
                              color: Color(ColorValues.black),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Center(
                            child: Text(
                              StringValues.TEXT_ENTER_OTP,
                              style: TextStyle(
                                  color: Color(ColorValues.black),
                                  fontSize: 20.0,
                                  fontFamily: StringValues.customSemiBold),
                            ),
                          ),
                          IconButton(
                            icon: new Icon(
                              Icons.arrow_back_ios,
                              color: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                    StringValues.otp_screen_msg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(ColorValues.text_view_hint),
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:40.0,bottom: 30.0),
                                  child: Text('$_start ${StringValues.sec}',
                                    style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 20.0,fontWeight: FontWeight.w600),
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
                                  defaultBorderColor: Color(ColorValues.grey_light_divider),//text_view_hint
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
                                Visibility(
                                  child: Text(
                                    StringValues.wrongOTP,
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
                                      callGetGenerateOtpApi();
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
                                            color: Color(ColorValues.yellow_light))),
                                    onPressed: () {
                                      validateOtp();
                                    },
                                    color: Color(ColorValues.yellow_light),
                                    textColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(StringValues.TEXT_VERIFY.toUpperCase(),
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
  void callGetGenerateOtpApi() async {

    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      "email": widget.email,
      "role": Constants.ROLE_ID
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL + Constants.FORGOT_PASSWORD_GET_OTP_API;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.post(dataURL,
          headers: headers, body: json.encode(requestJson));

      //if (!mounted) return;
      print("response::: ${response.body}");

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      //final jsonResponse = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
      print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          //_navigateToForgotOTP();
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          _start=Constants.OTP_TIMER;
          startTimer();
        }else if (apiResponse.status == 404) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          //_navigateToLogin();
        }
        else if (apiResponse.status == 500) {
          print("${apiResponse.message} \nServert Error, Try again.");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          //_navigateToLogin();
        }
      } else if (apiResponse.status == 404) {
        print("${apiResponse.message}");
        Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        //_navigateToLogin();
      }
      else if (apiResponse.status == 500) {
        print("${apiResponse.message} \nServert Error, Try again.");
        Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        //_navigateToLogin();
      }else {
        print("statusCode error....");
        Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    } on SocketException catch (e) {
      print('error caught: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
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

  void _navigateToResetPassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResetPassword(widget.email)),
    );
  }
  void callVerifyOtpApi() async {

    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      "email": widget.email,
      "otp": otpText
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL + Constants.FORGOT_PASSWORD_VERIFY_OTP_API;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          headers: headers, body: json.encode(requestJson));

      //if (!mounted) return;
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        _isSubmitPressed = false;
        setState(() {
          _isInProgress = false;
        });
        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
        if (apiResponse.status == 200) {
          _navigateToResetPassword();
        }else if (apiResponse.status == 404) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          //_navigateToLogin();
        }
        else if (apiResponse.status == 500) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          //_navigateToLogin();
        }
      } else {
        _isSubmitPressed = false;
        print("statusCode error....");
        setState(() {
          _isInProgress = false;
        });
      }
    } on SocketException catch (e) {
      print('error caught: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
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

  void _validateInputs() {
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
      callVerifyOtpApi();
    }
  }
}
