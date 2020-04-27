import 'dart:convert';
import 'dart:io';
import 'package:deliva/forgot_password/forgot_otp.dart';
import 'package:deliva/podo/api_response.dart';
import 'package:deliva/podo/response_podo.dart';
import 'package:deliva/registration/registration.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';

class ForgotPassword extends StatefulWidget {

  final String email;

  ForgotPassword(this.email, {Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  String _email;

  bool submitFlag = false;
  bool isSwitched = true;
  
  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  bool hasError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = widget.email;
    emailController.text = widget.email;
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
          StringValues.TEXT_FORGOT_PASSWORD,
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
                              StringValues.TEXT_FORGOT_PASSWORD,
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
                          margin:
                              const EdgeInsets.only(top: 24.0, bottom: 24.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              //alignment: Alignment.topCenter,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(24.0),
                                  child:Form(
                                    key: _formKey,
                                    autovalidate: _autoValidate,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                'assets/images/forgot_img.png'),
                                            width: 127.0,
                                            height: 174.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 32.0),
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top:0,
                                                left: 0,
                                                child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),
                                              hasError ? Positioned(
                                                right: 0.0,
                                                bottom: 5.0,
                                                //alignment: Alignment.bottomRight,
                                                child: Image(
                                                  image: new AssetImage(
                                                      'assets/images/error_icon_red.png'),
                                                  width: 16.0,
                                                  height: 16.0,
                                                  //fit: BoxFit.fitHeight,
                                                ),
                                              ):Container(),
                                              Theme(
                                                data: Theme.of(context)
                                                    .copyWith(primaryColor: Color(ColorValues.text_view_theme),),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 16.0),
                                                  child: TextFormField(
                                                    controller:
                                                    emailController,
                                                    focusNode:
                                                    _emailFocus,
                                                    keyboardType:
                                                    TextInputType
                                                        .emailAddress,
                                                    textInputAction:
                                                    TextInputAction
                                                        .done,

                                                    //autofocus: true,
                                                    decoration:
                                                    InputDecoration(
                                                      //contentPadding: EdgeInsets.all(0.0),

                                                      prefixIcon:
                                                      Padding(
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: Transform.scale(
                                                          scale: 0.65,
                                                          child: IconButton(
                                                            onPressed: (){},
                                                            icon: new Image.asset("assets/images/email_icon.png"),
                                                          ),
                                                        ),
                                                      ),
                                                      //icon: Icon(Icons.lock_outline),
                                                      counterText: '',
                                                      //labelText: StringValues.TEXT_EMAIL,
                                                      hintText: StringValues
                                                          .TEXT_EMAIL,
                                                      //border: InputBorder.none,
                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                                      /*errorText:
                                                                                  submitFlag ? _validateEmail() : null,*/
                                                    ),
                                                    onFieldSubmitted:
                                                        (_) {
                                                          _emailFocus
                                                              .unfocus();
                                                      validate();
                                                    },
                                                    validator: (String arg) {
                                                      String val=Validation.isEmail(arg);
                                                      //setState(() {
                                                      if(val != null)
                                                        hasError=true;
                                                      else
                                                        hasError=false;
                                                      //});
                                                      return val;
                                                    },
                                                    onSaved: (value) {
                                                      //print('email value:: $value');
                                                      _email = value;
                                                    },

                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 60.0),
                                          ),
                                          SizedBox(
                                            width: 250.0,
                                            height: 52.0,
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0),
                                                  side: BorderSide(
                                                      color: Color(ColorValues
                                                          .yellow_light))),
                                              onPressed: () {
                                                validate();
                                              },
                                              color:
                                                  Color(ColorValues.yellow_light),
                                              textColor: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                    StringValues.TEXT_SUBMIT
                                                        .toUpperCase(),
                                                    style: TextStyle(fontSize: 20)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /*Spacer(),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
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

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  void _navigateToForgotOTP() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgotOTP(_email)),
    );
  }

  void callGetGenerateOtpApi() async {
    _email = emailController.text.trim();
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });
    Map<String, dynamic> requestJson = {

      "email":_email,
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

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });

      //if (!mounted) return;
      print("response::: ${response.body}");
      final Map jsonResponseMap = json.decode(response.body);
      //final jsonResponse = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);

      if (response.statusCode == 200) {
        print("statusCode 200....");
        /*final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");*/
        if (apiResponse.status == 200) {
          _navigateToForgotOTP();
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
        }
      } else if(response.statusCode == 404){
        Toast.show(apiResponse.message, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (apiResponse.status == 500) {
        print("${apiResponse.message} \nServert Error, Try again.");
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else {
        print("statusCode error....");
        Toast.show("${apiResponse.message}", context,
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

  Future validate() async {

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
          Toast.show(StringValues.INTERNET_ERROR, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } catch (exception) {
        print('exception is: ${exception}');
      }
    }
  }

 /* void _validateInputs() {
    if (Validation.isEmail(
        emailController.text) ==
        null) {
      setState(() {
        this.hasError = false;
      });
      callGetGenerateOtpApi();
    } else {
      setState(() {
        this.hasError = true;
      });
      _isSubmitPressed = false;
    }
  }*/
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      callGetGenerateOtpApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
    }
  }
}
