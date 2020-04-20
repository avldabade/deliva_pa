import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:deliva/constants/Constant.dart';
import 'package:deliva/forgot_password/forgot_password.dart';
import 'package:deliva/login/login.dart';
import 'package:deliva/registration/my_profile.dart';
import 'package:deliva/podo/api_response.dart';
import 'package:deliva/registration/registration_otp.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../services/number_text_input_formator.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileNoController = TextEditingController();

  final FocusNode _mobileNoFocus = FocusNode();

  String _mobileNo;

  bool submitFlag = false;
  bool isSwitched = true;
  bool _obscureText = true;

  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _checkedValue = true;

  bool _isSubmitPressed = false;

  bool _isInProgress = false;

  String _countryCode = "91";

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mobileNoController.dispose();
    _mobileNoFocus.dispose();
    super.dispose();
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    var code = countryCode.toString().split("+");
    //print("Country selected: " + code[1]);
    _countryCode = code[1];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.primaryColor),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    return Material(
      //key: scaffoldKey,
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
                                      // bottom: 90.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        autovalidate: _autoValidate,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                48.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 32.0,
                                                            bottom: 32.0),
                                                    child: Text(
                                                      StringValues
                                                          .TEXT_REGISTRATION,
                                                      style: TextStyle(
                                                          color: Color(
                                                              ColorValues
                                                                  .accentColor),
                                                          fontSize: 25.0),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      CountryCodePicker(
                                                        onChanged:
                                                            _onCountryChange,
                                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                        initialSelection:
                                                            '+$_countryCode',
                                                        favorite: [
                                                          'IN',
                                                          '+39',
                                                          'FR'
                                                        ],
                                                        // optional. Shows only country name and flag
                                                        showCountryOnly: false,
                                                        // optional. Shows only country name and flag when popup is closed.
                                                        showOnlyCountryWhenClosed:
                                                            false,
                                                        // optional. aligns the flag and the Text left
                                                        alignLeft: false,
                                                        showFlag: false,
                                                        showFlagDialog: false,

                                                        padding:
                                                            EdgeInsets.all(0),
                                                        flagWidth: 25.0,
                                                        onInit: (code) {
                                                          print(
                                                              "on init ${code.name} ${code.dialCode}");
                                                          var codeA = code
                                                              .dialCode
                                                              .split("+");
                                                          print(
                                                              "Country on init: " +
                                                                  codeA[1]);
                                                          _countryCode =
                                                              codeA[1];
                                                        },
                                                      ),
                                                      Container(
                                                        height: 30.0,
                                                        width: 1.0,
                                                        color: Color(ColorValues
                                                            .grey_light_divider),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/phone_icon.png'),
                                                        width: 16.0,
                                                        height: 16.0,
                                                        //fit: BoxFit.fitHeight,
                                                      ),
                                                      Container(width: 8.0,),
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              mobileNoController,
                                                          focusNode:
                                                              _mobileNoFocus,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          maxLength: 13,
                                                          inputFormatters: [
                                                            WhitelistingTextInputFormatter
                                                                .digitsOnly,
                                                            // Fit the validating format.
                                                            //_phoneNumberFormatter,
                                                          ],
                                                          //to block space character
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          //autofocus: true,
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: '',
                                                            labelText: StringValues
                                                                .TEXT_MOBILE_NO,
                                                            hintText: StringValues
                                                                .TEXT_MOBILE_NO,
                                                            border: InputBorder
                                                                .none,
                                                            /*errorText:
                                                                          submitFlag ? _validateEmail() : null,*/
                                                          ),
                                                          onFieldSubmitted:
                                                              (_) {
                                                            _mobileNoFocus
                                                                .unfocus();
                                                            _validate();
                                                          },
                                                          validator: Validation
                                                              .validateMobile,
                                                          onSaved: (value) {
                                                            _mobileNo = value;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 24.0),
                                                    child: new Container(
                                                      height: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        /*Checkbox(
                                                          //checkColor: Color(ColorValues.sea_green_blue_light),
                                                          //tristate: true,
                                                          //activeColor: Color(ColorValues.white),
                                                          value: _checkedValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _checkedValue =
                                                                  value;
                                                            });
                                                          },
                                                        ),*/
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _checkedValue =
                                                              !_checkedValue;
                                                            });
                                                          },
                                                          child: Image(
                                                            image: _checkedValue
                                                                ? new AssetImage(
                                                                'assets/images/select_grey.png')
                                                                : new AssetImage(
                                                                'assets/images/unselect_grey.png'),
                                                            width: 20.0,
                                                            height: 20.0,
                                                            //fit: BoxFit.fitHeight,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:12.0),
                                                          child: Text(
                                                            StringValues
                                                                .TEXT_AGREE_T_C,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    ColorValues
                                                                        .text_view_hint),
                                                                fontSize: 16.0),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50.0),
                                                  ),
                                                  SizedBox(
                                                    width: 250.0,
                                                    height: 52.0,
                                                    child: RaisedButton(
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0),
                                                          side: BorderSide(
                                                              color: Color(
                                                                  ColorValues
                                                                      .yellow_light))),
                                                      onPressed: () {
                                                        _validate();
                                                      },
                                                      color: Color(ColorValues
                                                          .yellow_light),
                                                      textColor: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            StringValues
                                                                .TEXT_VERIFY
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    20.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50.0),
                                                  ),
                                                 /* Text(
                                                      StringValues
                                                          .TEXT_LOGIN_OTHER,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Color(ColorValues
                                                              .text_view_hint),
                                                          fontFamily:
                                                              StringValues
                                                                  .customLight)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 24.0),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/facebook_btn_elips.png'),
                                                        //width: 145.0,
                                                        height: 40.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/google_btn_eclips.png'),
                                                        //width: 145.0,
                                                        height: 40.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 24.0),
                                                  ),
                                                  */


                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
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
                              StringValues.TEXT_ALREDY_MEMBER,
                              style: TextStyle(
                                  color: Color(ColorValues.text_view_hint),
                                  fontSize: 14.0),
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              StringValues.TEXT_LOGIN_NOW,
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
              _isInProgress ? CommonWidgets.getLoader(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  void _navigateToRegistrationOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationOTP(_countryCode, _mobileNo,_checkedValue)),
    );
  }

  void _navigateToMyProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyProfile(_countryCode, _mobileNo, userId)),
    );
  }

  Future _validate() async {
    print("_isSubmitPressed:: $_isSubmitPressed");
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        submitFlag = true;
        _mobileNo = mobileNoController.text.trim();
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
        submitFlag = false;
        // });
      } catch (exception) {
        print('exception is: ${exception}');
      }
    }
  }

  /*Future _validate() async {
    print("validateLogin....");
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        submitFlag = true;
        _mobileNo = mobileNoController.text.trim();

        bool isConnected = await Utils.isInternetConnected();
        //isConnected ? authenticateUser(_email, _password) : Utils.showToast(Constants.INTERNET_ERROR);
        if (isConnected) {
          if (_validateMobileNo() == null) {
            if (_checkedValue) {
              callGetOtpApi(_mobileNo);
              //_navigateToRegistrationOtp();
            } else {
              //Utils.showRedSnackBar(StringValues.TEXT_PLEASE_ACCEPT, scaffoldKey);
              print("${StringValues.TEXT_PLEASE_ACCEPT}");
              _isSubmitPressed = false;
            }
          } else {
            _isSubmitPressed = false;
            //Utils.showRedSnackBar(_validateMobileNo(), scaffoldKey);
            print(_validateMobileNo());
          }
        } else {
          _isSubmitPressed = false;
          //Utils.showGreenSnackBar(StringValues.INTERNET_ERROR, scaffoldKey);
          print(StringValues.INTERNET_ERROR);
        }
        submitFlag = false;
        // });
      } catch (exception) {
        print('exception is: ${exception}');
      }
    }
  }*/

  void callGetOtpApi() async {
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {
      "countryCode": _countryCode,
      "mobileNo": _mobileNo,
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
        if (apiResponse.status == 200) {
          print("apiResponse.resourceData:: ${apiResponse.resourceData}");
          ResourceData resourceData = apiResponse.resourceData;
          print("resourceData:: ${resourceData}");
          if (resourceData == null) {
            //.isRegistrationComplete == "false"){
            _navigateToRegistrationOtp();
          } else if (apiResponse.resourceData.isRegistrationComplete ==
              "false") {
            _navigateToMyProfile(apiResponse.resourceData.userId);
          }
        } else if (apiResponse.status == 409) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _navigateToLogin();
        } else if (apiResponse.status == 500) {
          print("${apiResponse.message} \nServert Error, Try again.");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        }
      } else if (apiResponse.status == 409) {
        print("${apiResponse.message}");
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _navigateToLogin();
      } else if (apiResponse.status == 500) {
        print("${apiResponse.message} \nServert Error, Try again.");
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //_navigateToLogin();
      } else {
        Toast.show("Error Code is:: ${response.statusCode}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      if (_checkedValue) {
        callGetOtpApi();
        //_navigateToRegistrationOtp();
      } else {
        //Utils.showRedSnackBar(StringValues.TEXT_PLEASE_ACCEPT, scaffoldKey);
        print("${StringValues.TEXT_PLEASE_ACCEPT}");

        Toast.show(StringValues.TEXT_PLEASE_ACCEPT, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _isSubmitPressed = false;
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
    }
  }
}
