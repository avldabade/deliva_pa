import 'dart:convert';
import 'dart:io';

import 'package:deliva/forgot_password/forgot_password.dart';
import 'package:deliva/login/login_mobile_otp.dart';
import 'package:deliva/login/login_options.dart';
import 'package:deliva/podo/api_response.dart';
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

class LoginMobile extends StatefulWidget {
  @override
  _LoginMobileState createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileNoController = TextEditingController();

  final FocusNode _mobileNoFocus = FocusNode();

  String _mobileNo;

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

  var hasError=false;

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
                                                  //Navigator.pop(context);
                                                  onBackPressed();
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 16.0,
                                                        bottom: 32.0),
                                                    child: Center(
                                                      child: Text(
                                                        StringValues.TEXT_LOGIN,
                                                        style: TextStyle(
                                                            color: Color(
                                                                ColorValues
                                                                    .accentColor),
                                                            fontSize: 25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(StringValues.TEXT_MOBILE_NO,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),
                                                  Row(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                        showFlag: false,
                                                        // optional. Shows only country name and flag when popup is closed.
                                                        showOnlyCountryWhenClosed:
                                                        false,
                                                        // optional. aligns the flag and the Text left
                                                        alignLeft: false,
                                                        padding:
                                                        EdgeInsets.all(0),
                                                        flagWidth: 25.0,
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
                                                            //to block space character
                                                            BlacklistingTextInputFormatter(
                                                                new RegExp(
                                                                    '[\\ ]'))
                                                            // Fit the validating format.
                                                            //_phoneNumberFormatter,
                                                          ],

                                                          textInputAction:
                                                          TextInputAction
                                                              .done,

                                                          //autofocus: true,
                                                          decoration:
                                                          InputDecoration(
                                                            counterText: '',
                                                            //labelText: StringValues.TEXT_MOBILE_NO,
                                                            hintText: StringValues
                                                                .TEXT_MOBILE_NO,
                                                            border: InputBorder
                                                                .none,
                                                            errorText: null,
                                                            errorBorder: InputBorder.none,
                                                            /*errorText:
                                                                            submitFlag ? _validateEmail() : null,*/
                                                          ),
                                                          onFieldSubmitted:
                                                              (value) {
                                                            _mobileNoFocus
                                                                .unfocus();
                                                            validateLogin();
                                                          },
                                                          validator: (String arg) {
                                                            String val=Validation.validateMobile(arg);
                                                            //setState(() {
                                                            if(val != null)
                                                              hasError=true;
                                                            else
                                                              hasError=false;
                                                            //});
                                                            return val;
                                                          },
                                                          onSaved: (value) {
                                                            _mobileNo = value;
                                                          },
                                                          onChanged: (val){
                                                            if(val.length > 9)
                                                              hasError=false;
                                                            else
                                                              hasError=true;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Stack(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(bottom: 10.0),
                                                        child: new Container(
                                                          height: 1.0,
                                                          color: hasError?Color(ColorValues.error_red) :Colors.grey,
                                                        ),
                                                      ),
                                                      Visibility(
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top:5.0),
                                                            child: Text(
                                                              StringValues.ENTER_VALID_MOBILE_NO,
                                                              style: TextStyle(color: Color(ColorValues.error_red),fontSize: 12.0),
                                                            ),
                                                          ),
                                                        ),
                                                        visible: hasError,
                                                      ),
                                                      hasError ? Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        //alignment: Alignment.bottomRight,
                                                        child: Image(
                                                          image: new AssetImage(
                                                              'assets/images/error_icon_red.png'),
                                                          width: 16.0,
                                                          height: 16.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ):Container(),
                                                    ],
                                                  ),

                                                  Container(height:40.0),

                                                  Center(
                                                    child: SizedBox(
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
              WillPopScope(
                onWillPop: onBackPressed,
                child: Container(),
              ),
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

  void _navigateToLoginOTP() {
    _mobileNo = mobileNoController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginMobileOTP(_countryCode, _mobileNo)),
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

    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        submitFlag = true;
        _mobileNo = mobileNoController.text.trim();
        //_password = passwordController.text.trim();
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

  void callLoginOTPApi() async {
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
        '?mobile=$_mobileNo&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}';
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

          Toast.show(loginResponse.responseMessage, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _navigateToLoginOTP();

        } else if (jsonResponseMap.containsKey("error")) {
          Toast.show("${loginResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (response.statusCode == 400) {
        Toast.show(loginResponse.responseMessage, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (response.statusCode == 401) {
        Toast.show(loginResponse.responseMessage, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print("statusCode error....");
        Toast.show("error code::: ${loginResponse.responseMessage}", context,
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


 /* void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      callLoginOTPApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
    }
  }*/
  void _validateInputs() {
    if (Validation.validateMobile(
        mobileNoController.text) ==
        null) {
      setState(() {
        this.hasError = false;
      });
      callLoginOTPApi();
    } else {
      setState(() {
        this.hasError = true;
      });
      _isSubmitPressed = false;
    }
  }

  Future<bool> onBackPressed() async {
    //print('onBackPressed called');
    Navigator.of(context).pop();
    /*final resultData = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOptions()),
    );
    return true;*/

  }
}
