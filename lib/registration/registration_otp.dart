import 'dart:convert';
import 'dart:io';

import 'package:deliva/constants/Constant.dart';
import 'package:deliva/registration/my_profile.dart';
import 'package:deliva/podo/api_response.dart';
import 'package:deliva/registration/registration.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
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

  //String _mobileNo = widge.mobileNo;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
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
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  //alignment: Alignment.topCenter,
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
                                    padding:
                                    const EdgeInsets.only(top: 0.0, bottom: 24.0),
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
                                  PinCodeTextField(
                                    autofocus: false,
                                    pinBoxWidth: 35.0,
                                    controller: controller,
                                    hideCharacter: false,
                                    highlight: true,
                                    highlightColor: Color(ColorValues.yellow_light),
                                    //Colors.blue,
                                    defaultBorderColor:
                                    Color(ColorValues.grey_hint_color),
                                    //Colors.black,
                                    hasTextBorderColor:
                                    Color(ColorValues.grey_hint_color),
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
                                  Visibility(
                                    child: Text(
                                      "Wrong OTP!",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    visible: hasError,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30.0),
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
                                        child: Text(
                                            StringValues.TEXT_SUBMIT.toUpperCase(),
                                            style: TextStyle(fontSize: 20.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 40.0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      callGetOtpApi();
                                    },
                                    child: Text(
                                      StringValues.TEXT_RESEND_CODE,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(ColorValues.sea_blue),
                                      ),
                                    ),
                                  )
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
          if (apiResponse.resourceData == null) {
            //.isRegistrationComplete == "false"){
          } else if (apiResponse.resourceData.isRegistrationComplete ==
              "false") {
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

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  void _navigateToMyProfile(int userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyProfile(widget.countryCode,widget.mobileNo,userId)),
    );
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
        APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
        if(apiResponse.status == 200){
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          print("userId:: ${apiResponse.resourceData.userId}");

          _navigateToMyProfile(apiResponse.resourceData.userId);

          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }else{
          Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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

  void _validateInputs() {
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
  }
}
