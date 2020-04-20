import 'dart:convert';
import 'dart:io';

import 'package:deliva/forgot_password/forgot_password.dart';
import 'package:deliva/podo/login_response.dart';
import 'package:deliva/podo/response_podo.dart';
import 'package:deliva/registration/registration.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:country_code_picker/country_code_picker.dart';

class LoginEmail extends StatefulWidget {
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _email;
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
    emailController.dispose();
    _emailFocus.dispose();
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
    _email = emailController.text.trim();
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              IconButton(
                                                icon: new Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Color(ColorValues.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Text(
                                                StringValues.AAP_NAME,
                                                //textAlign: TextAlign.center,

                                                style: TextStyle(
                                                    color: Color(
                                                        ColorValues.white),
                                                    fontSize: 40.0),
                                              ),
                                              IconButton(
                                                icon: new Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.transparent,
                                                ),
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
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/email_icon.png'),
                                                        width: 16.0,
                                                        height: 16.0,
                                                        //fit: BoxFit.fitHeight,
                                                      ),
                                                      Container(width: 8.0,),
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              emailController,
                                                          focusNode:
                                                              _emailFocus,
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          //maxLength: 13,
                                                          /*inputFormatters: [
                                                            WhitelistingTextInputFormatter
                                                                .digitsOnly,
                                                            // Fit the validating format.
                                                            //_phoneNumberFormatter,
                                                          ],*/
                                                          //to block space character
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,

                                                          //autofocus: true,
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: '',
                                                            labelText: StringValues
                                                                .TEXT_EMAIL,
                                                            hintText: StringValues
                                                                .TEXT_EMAIL,
                                                            border: InputBorder
                                                                .none,
                                                            /*errorText:
                                                                            submitFlag ? _validateEmail() : null,*/
                                                          ),
                                                          onFieldSubmitted:
                                                              (_) {
                                                            Utils.fieldFocusChange(
                                                                context,
                                                                _emailFocus,
                                                                _passwordFocus);
                                                          },
                                                          validator: Validation
                                                              .isEmail,
                                                          onSaved: (value) {
                                                            _email = value;
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
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/password_ic.png'),
                                                        width: 16.0,
                                                        height: 16.0,
                                                        //fit: BoxFit.fitHeight,
                                                      ),
                                                      Container(width: 8.0,),
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
                                                          //color:Color(ColorValues.yellow_light),
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
                                                                  top: 16.0),
                                                          child: Text(
                                                            StringValues
                                                                .TEXT_FORGOT,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    ColorValues
                                                                        .blueTheme),
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
                                                        print("Login....");
                                                        validateLogin();
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
                                                            bottom: 50.0),
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
    _email = emailController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgotPassword(_email)),
    );
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
    var currentLocation= await Utils.getCurrentLocation();
    print("currentLocation::: $currentLocation");
    print("validateLogin....");
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        submitFlag = true;
        _email = emailController.text.trim();
        _password = passwordController.text.trim();
        bool isConnected = await Utils.isInternetConnected();
        if (isConnected) {
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
    print("login _password::: $_password \n_email:: $_email \n_countryCode::: $_countryCode ");
    print("login encodedPassword::: $encodedPassword");
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
        '?grant_type=password&username=$_email&password=$encodedPassword&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByEmail}';
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
