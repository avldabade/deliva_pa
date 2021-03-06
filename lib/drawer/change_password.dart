import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/registration/registration.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../constants/Constant.dart';

class ChangePassword extends StatefulWidget {
  /*final String email;

  ChangePassword(this.email, {Key key}) : super(key: key);
*/
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _oldPasswordFocus = FocusNode();

  String _password;
  String _confirmPassword;
  String _oldPassword;

  bool _obscureTextOld = true;
  bool _obscureText = true;
  bool _obscureTextCon = true;

  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool isOldPasswordError = false;
  bool isPasswordError = false;

  bool isConPasswordError = false;

  @override
  void dispose() {
    // TODO: implement dispose
    oldPasswordController.dispose();
    _oldPasswordFocus.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();
    confirmPasswordController.dispose();
    _confirmPasswordFocus.dispose();
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
        */ /*actions: <Widget>[
          Center(child: Text("step 2",style: TextStyle(color: Color(ColorValues.black)),))
        ],*/ /*
        backgroundColor: Color(ColorValues.white),
        title: Text(
          StringValues.TEXT_RESET_PASSWORD,
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

                    Utils().commonAppBar(StringValues.TEXT_CHANGE_PASSWORD,context),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                MediaQuery.of(context).viewInsets.bottom),
                            child: Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: Container(
                                margin: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: new AssetImage(
                                          'assets/images/reset_img.png'),
                                      width: 127.0,
                                      height: 174.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0, bottom: 24.0),
                                    ),
                                    /*Row(
                                      children: <Widget>[
                                        Image(
                                          image: new AssetImage(
                                              'assets/images/password_ic.png'),
                                          width: 16.0,
                                          height: 16.0,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                        Container(
                                          width: 8.0,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: passwordController,
                                            focusNode: _passwordFocus,

                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              BlacklistingTextInputFormatter(
                                                  new RegExp('[\\ ]'))
                                            ],
                                            //to block space character
                                            textInputAction:
                                                TextInputAction.next,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              labelText:
                                                  StringValues.TEXT_PASSWORD,
                                              hintText:
                                                  StringValues.TEXT_PASSWORD,
                                              border: InputBorder.none,
                                            ),
                                            obscureText: _obscureText,
                                            onFieldSubmitted: (_) {
                                              Utils.fieldFocusChange(
                                                  context,
                                                  _passwordFocus,
                                                  _confirmPasswordFocus);
                                            },
                                            validator:
                                                Validation.validatePassword,
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
                                    ),*/
                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Text(
                                            StringValues.TEXT_OLD_PASSWORD,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.primaryColor),
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        isOldPasswordError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextFormField(
                                              controller: oldPasswordController,
                                              focusNode: _oldPasswordFocus,
                                              maxLength: 20,
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                BlacklistingTextInputFormatter(
                                                    new RegExp('[\\ ]'))
                                              ],
                                              //to block space character
                                              textInputAction:
                                              TextInputAction.next,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                //errorStyle: TextStyle(),
                                                prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/password_ic.png"),
                                                    ),
                                                  ),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                suffixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: _toggleOld,
                                                      icon: Image.asset(_obscureTextOld
                                                          ? 'assets/images/eye.png'
                                                          : 'assets/images/eye_cross.png'),
                                                    ),
                                                  ),
                                                ),
                                                counterText: '',
                                                hintText:
                                                StringValues.TEXT_OLD_PASSWORD,
                                                //hintStyle: TextStyle(),
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                              ),

                                              obscureText: _obscureTextOld,
                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _oldPasswordFocus,
                                                    _passwordFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.validateOldPassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  isOldPasswordError = true;
                                                else
                                                  isOldPasswordError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.validateOldPassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  isOldPasswordError = true;
                                                else
                                                  isOldPasswordError = false;
                                                //});
                                                setState(() {

                                                });
                                              },

                                              onSaved: (value) {
                                                _oldPassword = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 16.0,
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Text(
                                            StringValues.TEXT_NEW_PASSWORD,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.primaryColor),
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        isPasswordError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextFormField(
                                              controller: passwordController,
                                              focusNode: _passwordFocus,
                                              maxLength: 20,
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                BlacklistingTextInputFormatter(
                                                    new RegExp('[\\ ]'))
                                              ],
                                              //to block space character
                                              textInputAction:
                                              TextInputAction.next,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                //errorStyle: TextStyle(),
                                                prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/password_ic.png"),
                                                    ),
                                                  ),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                suffixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: _toggle,
                                                      icon: Image.asset(_obscureText
                                                          ? 'assets/images/eye.png'
                                                          : 'assets/images/eye_cross.png'),
                                                    ),
                                                  ),
                                                ),
                                                counterText: '',
                                                hintText:
                                                StringValues.TEXT_PASSWORD,
                                                //hintStyle: TextStyle(),
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                              ),

                                              obscureText: _obscureText,
                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _passwordFocus,
                                                    _confirmPasswordFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.validateNewPassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  isPasswordError = true;
                                                else
                                                  isPasswordError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged:  (String arg) {
                                                String val =
                                                Validation.validateNewPassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  isPasswordError = true;
                                                else
                                                  isPasswordError = false;
                                                if (arg !=
                                                    confirmPasswordController.text
                                                        .trim()) {
                                                  isConPasswordError = true;
                                                  print('on password change isConPasswordError:: $isConPasswordError');
                                                  String errro = StringValues
                                                      .PASSWORD_NOT_MATCH;
                                                }else if (arg ==
                                                    confirmPasswordController.text
                                                        .trim()) {
                                                  isConPasswordError = false;
                                                  print('else if on password change isConPasswordError:: $isConPasswordError');
                                                }
                                                setState(() {
                                                  isPasswordError=isPasswordError;
                                                  isConPasswordError=isConPasswordError;
                                                });

                                              },

                                              onSaved: (value) {
                                                _password = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 16.0,
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Text(
                                            StringValues.TEXT_CONFIRM_PASSWORD,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.primaryColor),
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        isConPasswordError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextFormField(
                                              controller: confirmPasswordController,
                                              focusNode: _confirmPasswordFocus,
                                              maxLength: 20,
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                BlacklistingTextInputFormatter(
                                                    new RegExp('[\\ ]'))
                                              ],
                                              //to block space character
                                              textInputAction:
                                              TextInputAction.done,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                //errorStyle: TextStyle(),
                                                prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/password_ic.png"),
                                                    ),
                                                  ),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                suffixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: _toggleCon,
                                                      icon: Image.asset(_obscureTextCon
                                                          ? 'assets/images/eye.png'
                                                          : 'assets/images/eye_cross.png'),
                                                    ),
                                                  ),
                                                ),
                                                counterText: '',
                                                hintText:
                                                StringValues.TEXT_PASSWORD,
                                                //hintStyle: TextStyle(),
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                              ),

                                              obscureText: _obscureTextCon,
                                              onFieldSubmitted: (_) {
                                                _confirmPasswordFocus.unfocus();
                                                validatePassword();
                                              },
                                              validator: (value) {
                                                if(value == null || value == ''){
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .ENTER_CONFIRM_PASSWORD;
                                                }
                                                /*if (value.length < 6) {
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .ENTER_VALID_PASSWORD;
                                                }*/
                                                if (value !=
                                                    passwordController.text
                                                        .trim()) {
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .PASSWORD_NOT_MATCH;
                                                }
                                                isConPasswordError=false;
                                                return null;
                                                /*Validation
                                                  .validateConfirmPassword(
                                                  passwordController.text.trim(), value);*/
                                              },
                                              onChanged: (String value){
                                                if(value == null || value == ''){
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .ENTER_CONFIRM_PASSWORD;
                                                }
                                                /*if (value.length < 6) {
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .ENTER_VALID_PASSWORD;
                                                }*/
                                                if (value !=
                                                    passwordController.text
                                                        .trim()) {
                                                  isConPasswordError=true;
                                                  return StringValues
                                                      .PASSWORD_NOT_MATCH;
                                                }
                                                isConPasswordError=false;
                                                setState(() {

                                                });
                                              },
                                              onSaved: (value) {
                                                _confirmPassword = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(height: 40.0,),
                                    SizedBox(
                                      width: 250.0,
                                      height: 52.0,
                                      child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            new BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: Color(
                                                    ColorValues.accentColor))),
                                        onPressed: () {
                                          validatePassword();
                                        },
                                        color: Color(ColorValues.accentColor),
                                        textColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              StringValues.TEXT_SAVE
                                                  .toUpperCase(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Spacer(),
                    /* Column(
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
                                color: Color(ColorValues.accentColor),
                                fontSize: 20.0),
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


  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void _toggleOld() {
    setState(() {
      _obscureTextOld = !_obscureTextOld;
    });
  }

  void _toggleCon() {
    setState(() {
      _obscureTextCon = !_obscureTextCon;
    });
  }

  Future validatePassword() async {
    FocusScope.of(context).requestFocus(new FocusNode()); //to dismiss keyboard
    //submitFlag = true;

    //_confirmPassword =confirmPasswordController.text.trim();
    //_password = passwordController.text.trim();
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      _validateInputs();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    // }
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
      callChangePasswordApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }

  /*Future validatePassword() async {

    FocusScope.of(context).requestFocus(
        new FocusNode()); //to dismiss keyboard
    //submitFlag = true;

    _confirmPassword =confirmPasswordController.text.trim();
    _password = passwordController.text.trim();
    bool isConnected =
    await Utils.isInternetConnected();
    if (isConnected) {
      String msgPwd=_validatePassword();
      if (msgPwd == null) {
        String msgConPwd=_validateConfirmPassword();
        if (msgConPwd ==
            null) {
          callChangePasswordApi();
        } else {
          Toast.show(msgConPwd, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }
      } else {
        Toast.show(msgPwd, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }

    } else {
      Toast.show(StringValues.INTERNET_ERROR, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
    // }

  }*/
  void callChangePasswordApi() async {
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });

    /*{
      "email": "ayush.makwani@lmsin.com",
    "newPassWord": "MTIzNDU2",
    "oldPassword": "MTIzNDU2",
    "role": 2
    }*/
    int userId= await SharedPreferencesHelper.getPrefInt(SharedPreferencesHelper.USER_ID);
    String access_token = await SharedPreferencesHelper.getPrefString(SharedPreferencesHelper.ACCESS_TOKEN);
    Map<String, dynamic> requestJson = {
      "userId": userId,//ask ayush to add email in login response
      "oldPassword": Utils.encodeStringToBase64(_oldPassword),
      "newPassword": Utils.encodeStringToBase64(_password),
      "roleId": Constants.ROLE_ID
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.CHANGE_PASSWORD_API;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.post(dataURL,
          headers: headers, body: json.encode(requestJson));
      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });

      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      ResponsePodo apiResponse = new ResponsePodo.fromJson(jsonResponseMap);

      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

        if (apiResponse.status == 200) {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
          _navigateToHome();
        } else if (apiResponse.status == 404) {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        } else if (apiResponse.status == 500) {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        }
      } else if (apiResponse.status == 404) {
        print("${apiResponse.message}");
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //_navigateToLogin();
      } else if (apiResponse.status == 500) {
        print("${apiResponse.message} \nServert Error, Try again.");
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //_navigateToLogin();
      } else {
        //_isSubmitPressed = false;
        print("statusCode error....");
        if (jsonResponseMap.containsKey("error")){
          if (apiResponse.error == StringValues.invalidateToken) {
            Toast.show('${StringValues.sessionExpired}', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            new Utils().callLogout(context);
          }else{
            Toast.show(apiResponse.error, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }else{
          Toast.show(apiResponse.error, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
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

  void _navigateToLogin() {
    new Utils().callLogout(context);
  }
  void _navigateToHome() {
    Navigator.of(context).pop('refresh');
  }
}
