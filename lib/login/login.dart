import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/forgot_password/forgot_password.dart';
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileNoController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _mobileNo;
  String _password;

  bool submitFlag = false;
  bool isSwitched = true;
  bool _obscureText = true;

  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _isInProgress = false;
  bool _isSubmitPressed = false;

  String _countryCode = "91";

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    mobileNoController.dispose();
    _mobileNoFocus.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  /*Widget _buildDropdownItem(Country country) {
    return Container(
      child: Row(
        children: <Widget>[
          //CountryPickerUtils.getDefaultFlagImage(country),
         */ /* SizedBox(
            width: 8.0,
          ),*/ /*
          //Text("+${country.phoneCode}(${country.isoCode})"),
          Text("+${country.phoneCode}"),
        ],
      ),
    );
  }*/

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    var code = countryCode.toString().split("+");
    //print("Country selected: " + code[1]);
    _countryCode = code[1];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isInProgress = false;
    _isSubmitPressed = false;
    _mobileNo = mobileNoController.text.trim();
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
                                                            top: 16.0,
                                                            bottom: 32.0),
                                                    child: Text(
                                                      StringValues.TEXT_LOGIN,
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
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        //flagWidth: 25.0,
                                                        //Get the country information relevant to the initial selection
                                                        onInit: (code) {
                                                          print(
                                                              "on init ${code} ${code.name} ${code.dialCode}");
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
                                                                  .next,

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
                                                            Utils.fieldFocusChange(
                                                                context,
                                                                _mobileNoFocus,
                                                                _passwordFocus);
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
                                                            top: 0.0),
                                                    child: new Container(
                                                      height: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              passwordController,
                                                          focusNode:
                                                              _passwordFocus,

                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: [
                                                            BlacklistingTextInputFormatter(
                                                                new RegExp(
                                                                    '[\\ ]'))
                                                          ],
                                                          //to block space character
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          //autofocus: true,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: StringValues
                                                                .TEXT_PASSWORD,
                                                            hintText: StringValues
                                                                .TEXT_PASSWORD,
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          obscureText:
                                                              _obscureText,
                                                          onFieldSubmitted:
                                                              (value) {
                                                            _passwordFocus
                                                                .unfocus();
                                                            validateLogin();
                                                          },
                                                          validator: Validation
                                                              .validatePassword,
                                                          onSaved: (value) {
                                                            _password = value;
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        child: new IconButton(
                                                          onPressed: _toggle,
                                                          icon: Image.asset(_obscureText
                                                              ? 'assets/images/eye.png'
                                                              : 'assets/images/eye_cross.png'),
                                                          //color:Color(ColorValues.accentColor),
                                                          //iconSize: 24.0,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 0.0),
                                                    child: new Container(
                                                      height: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      /*Row(
                                                      //mainAxisSize: MainAxisSize.min,

                                                      children: <Widget>[
                                                        Switch(
                                                          value: isSwitched,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isSwitched = value;
                                                              print(isSwitched);
                                                            });
                                                          },
                                                          activeTrackColor:
                                                              Color(ColorValues.accentColor),
                                                          activeColor: Colors.white,
                                                        ),
                                                        Text(
                                                          StringValues.TEXT_REMEMBER,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  ColorValues.sea_green_blue_light),
                                                              fontSize: 16.0),
                                                        )
                                                      ],
                                                    ),*/
                                                      GestureDetector(
                                                        onTap:
                                                            _navigateToForgotPassword,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child: Text(
                                                            StringValues
                                                                .TEXT_FORGOT,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    ColorValues
                                                                        .accentColor),
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 30.0),
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
                                                                      .accentColor))),
                                                      onPressed: () {
                                                        print("Login....");
                                                        validateLogin();
                                                      },
                                                      color: Color(ColorValues
                                                          .accentColor),
                                                      textColor: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                            StringValues
                                                                .TEXT_LOGIN
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 24.0),
                                                  ),
                                                  Text(
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
                                                            bottom: 16.0),
                                                  ),
                                                ],
                                              ),
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
              /* _isInProgress
                  ? Center(
                      child: Utils.getLoader(),
                    )
                  : Container(),*/
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

  void _navigateToForgotPassword() {
    _mobileNo = mobileNoController.text.trim();
   /* Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgotPassword(_countryCode, _mobileNo)),
    );*/
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  Widget showProgress() {
    if (_isInProgress) {
      return new Stack(
        children: [
          new Opacity(
            opacity: 0.9,
            child:
                const ModalBarrier(dismissible: false, color: Colors.black54),
          ),
          new Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: new Text("Loading..."),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }

  Future validateLogin() async {
    //var currentLocation= await Utils.getCurrentLocation();
    //print("currentLocation::: $currentLocation");
    print("validateLogin....");
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        submitFlag = true;
        _mobileNo = mobileNoController.text.trim();
        _password = passwordController.text.trim();
        bool isConnected = await Utils.isInternetConnected();
        if (isConnected) {
          /* String msgMob = _validateMobileNo();
          if (msgMob == null) {
            String msgPass = _validatePassword();
            if (msgPass == null) {
              String encodeedPassword = Utils.encodeStringToBase64(_password);
              print("encodeedPassword::: $encodeedPassword");
              callLoginApi(_mobileNo, encodeedPassword, _countryCode);
            } else {
              //Utils.showRedSnackBar(msgPass, scaffoldKey);
              Toast.show(msgPass, context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              _isSubmitPressed = false;
            }
          } else {
            _isSubmitPressed = false;
            //Utils.showRedSnackBar(msgMob, scaffoldKey);
            Toast.show(msgMob, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }*/
          _validateInputs();
        } else {
          _isSubmitPressed = false;
          //Utils.showGreenSnackBar(StringValues.INTERNET_ERROR, scaffoldKey);
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

  void callLoginApi() async {
    String encodedPassword = Utils.encodeStringToBase64(_password);
    print("login _password::: $_password \n_mobileNo:: $_mobileNo \n_countryCode::: $_countryCode ");
    print("login encodedPassword::: $encodedPassword");
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
        Constants.LOGIN_API +
        //"?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2";
        "?grant_type=password&username=$_mobileNo&password=$encodedPassword&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}";
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
              SharedPreferencesHelper.IS_PROFILE_COMPLETE,
              loginResponse.isProfileComplete);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.JIT, loginResponse.jti);
          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.USER_PASSWORD, encodedPassword);
          Toast.show("User logged in successfully.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
        Toast.show("${response.statusCode}", context,
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
    final result =
        await Navigator.of(context).pushReplacementNamed('/dashboard');
    setState(() {
      print('result:::: $result');
    });
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      callLoginApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
    }
  }
}
