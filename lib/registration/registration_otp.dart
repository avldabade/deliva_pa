import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/registration/my_profile.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/registration/registration.dart';
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

class RegistrationOTP extends StatefulWidget {
  final String countryCode;
  final String mobileNo;
  final bool checkedValue;
  RegistrationOTP(this.countryCode,this.mobileNo, this.checkedValue, {Key key}): super(key: key);

  @override
  _RegistrationOTPState createState() => _RegistrationOTPState();
}

class _RegistrationOTPState extends State<RegistrationOTP> {
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  bool _isSubmitPressed = false;

  bool _isInProgress = false;

  Timer _timer;
  int _start = Constants.OTP_TIMER;

  String _OTPErrorMsg=StringValues.blankOTP;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    _timer.cancel();
    super.dispose();
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
      /*appBar: AppBar(
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
              Container(
                //margin: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  //alignment: Alignment.topCenter,
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
                                    padding:
                                    const EdgeInsets.only(top: 0.0, bottom: 24.0),
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
                                    defaultBorderColor:
                                    Color(ColorValues.grey_light_divider),
                                    //Colors.black,
                                    hasTextBorderColor:
                                    Color(ColorValues.grey_light_divider),
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
                                    pinBoxDecoration: ProvidedPinBoxDecoration
                                        .underlinedPinBoxDecoration,
                                    pinTextStyle: TextStyle(fontSize: 20.0),
                                    pinTextAnimatedSwitcherTransition:
                                    ProvidedPinBoxTextAnimation.scalingTransition,
                                    pinTextAnimatedSwitcherDuration:
                                    Duration(milliseconds: 300),
                                  ),
                                  /*Visibility(
                                    child: controller.text==""?Text(
                                      "Enter OTP",
                                      style: TextStyle(color: Colors.red),
                                    ):Text(
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
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if(_start == 0){
                                        controller.clear();
                                        callGetOtpApi();

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
                                              color: _start != 0 ?Color(ColorValues.accentColor):Color(ColorValues.grey_hint_color))),
                                      onPressed: () {
                                        _start != 0 ?  validateOtp():"";
                                      },
                                      color: _start != 0 ?Color(ColorValues.accentColor):Color(ColorValues.grey_hint_color),
                                      textColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            StringValues.TEXT_SUBMIT.toUpperCase(),
                                            style: TextStyle(fontSize: 20.0)),
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
                    //Spacer(),
                    /*Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            StringValues.TEXT_ANY_ACCOUNT,
                            style: TextStyle(
                                color: Color(ColorValues.sea_green_blue_light),
                                fontSize: 14.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToRegistration,
                          child: Text(
                            StringValues.TEXT_REGISTER_NOW,
                            style: TextStyle(
                                color: Color(ColorValues.blueTheme), fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
              _isInProgress ? CommonWidgets.getLoader(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void callGetOtpApi() async {
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      "countryCode": widget.countryCode,
      "mobileNo": widget.mobileNo,
      "isAgree": widget.checkedValue,
      "roleId": Constants.ROLE_ID
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL + Constants.REGISTRATION_STEP1_API;
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
        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
        if (apiResponse.status == 200) {
          _start=Constants.OTP_TIMER;
          startTimer();
          if (apiResponse.resourceData == null) {
            //.isRegistrationComplete == "false"){
          } else if (apiResponse.resourceData.isRegistrationComplete ==
              "false") {
            //==============================
            SharedPreferencesHelper.setPrefString(
                SharedPreferencesHelper.mobileNo, widget.mobileNo);
            SharedPreferencesHelper.setPrefString(
                SharedPreferencesHelper.countryCode, widget.countryCode);
            SharedPreferencesHelper.setPrefInt(
                SharedPreferencesHelper.USER_ID, apiResponse.resourceData.userId);
            //===============================
            _navigateToMyProfile(apiResponse.resourceData.userId);
          }
        } /*else if (apiResponse.status == 409) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          _navigateToLogin();
        }*/else if (apiResponse.status == 500) {
          print("${apiResponse.message} \nServert Error, Try again.");
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          //_navigateToLogin();
        }
      } else if (apiResponse.status == 500) {
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

  Future _navigateToMyProfile(int userId) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyProfile(widget.countryCode,widget.mobileNo,userId,"register")),
    );
    //final result = await Navigator.of(context).pushReplacementNamed('/profile',arguments: {widget.countryCode,widget.mobileNo,userId});
   /* final result = await Navigator.of(context).pushReplacementNamed('/profile',arguments:<String, dynamic>{
      'countryCode': widget.countryCode,
      'mobileNo': widget.mobileNo,
      'userId': userId
    } );*/

    /*final result1 = await Navigator.of(context).pushReplacementNamed('/profile',arguments: MyProfile(
      widget.countryCode,
      widget.mobileNo,
      userId
     ));*/

    /*final resultData = await Navigator.of(context).pushReplacement(new MaterialPageRoute(settings: const RouteSettings(name: '/profile'), builder: (context) => new MyProfile('${widget.countryCode}','${widget.mobileNo}',userId)));
    print('resultData:: $resultData');
    if(resultData as int == Constants.popScreen)
      Navigator.of(context).pop(Constants.popScreen);*/
    /*final result =
    await Navigator.of(context).pushReplacementNamed('/dashboard');
    setState(() {
      print('result:::: $result');
    });*/
  }

  void callVerifyUserApi() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });

    String otpInBase64 = Utils.encodeStringToBase64("1234");
    Map<String, dynamic> requestJson = {
    /*   "countryCode": widget.countryCode,
      "mobile": widget.mobileNo,
      "otp": "1234",
      "roleId": Constants.ROLE_ID*/
    };
    String jsonParam='{"countryCode": "91","mobile": "1122112211","otp": "1234","roleId": ${Constants.ROLE_ID}';
    //print("jsonParam::: $jsonParam");
    //Map<String, dynamic> requestJson1 = {"mobile": "7000543895"};
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String dataURL = Constants.BASE_URL + Constants.REGISTRATION_VERIFY_OTP_API;
    datahttp://103.76.253.133:8751/user/user/verify/91/1122112211/1234/2
    dataURL = dataURL + "${widget.countryCode}/${widget.mobileNo}/1234/${Constants.ROLE_ID}/${widget.checkedValue}";

    print("Verify OTP URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers, body: json.encode(requestJson));
      //if (!mounted) return;
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        setState(() {
          _isInProgress = false;
        });
        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponseMap);
        if (jsonResponseMap.containsKey("userid")) {
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.ACCESS_TOKEN, loginResponse.accessToken);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.AWS_ACCESS_KEY, loginResponse.awsAccessKeyId);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.AWS_SECRET_KEY, loginResponse.awsSecretAccessKey);
         /* SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.IS_LOGGED_IN, true);*/
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.TOKEN_TYPE, loginResponse.tokenType);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.REFRESH_TOKEN,
              loginResponse.refreshToken);
          SharedPreferencesHelper.setPrefInt(
              SharedPreferencesHelper.EXPIRES_IN, loginResponse.expiresIn);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.SCOPE, loginResponse.scope);

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

          //==============================
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.mobileNo, widget.mobileNo);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.countryCode, widget.countryCode);
          //===============================

          Toast.show("User logged in successfully.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _navigateToMyProfile(loginResponse.userid);
        } else if (jsonResponseMap.containsKey("error")) {
          Toast.show("${loginResponse.errorDescription}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
        _isSubmitPressed = false;
        setState(() {
          _isInProgress = false;
        });
      } else {
        _isSubmitPressed = false;
        print("statusCode error....");
        Toast.show("status error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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

 /* void _validateInputs() {
    this.thisText = controller.text;
    if (thisText.length < 4 ||
        thisText.isEmpty ||
        thisText.compareTo("1234") != 0) {
      setState(() {
        this.hasError = true;
      });
      _isSubmitPressed = false;
    } else {
      print("OPT is correct...");
      callVerifyUserApi();
    }
  }*/
  void _validateInputs() {
    this.thisText = controller.text;
    if (thisText.isEmpty){
      setState(() {
        this.hasError = true;
        _OTPErrorMsg = StringValues.blankOTP;
      });
      _isSubmitPressed = false;
    }
    else if (thisText.length < 4 || thisText.compareTo("1234") != 0) {
      setState(() {
        this.hasError = true;
        _OTPErrorMsg = StringValues.wrongOTP;
      });
      _isSubmitPressed = false;
    }  else {
      print("OPT is correct...");
      callVerifyUserApi();
    }
  }
}
