import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/services/number_text_input_formator.dart';
import 'package:deliva_pa/podo/api_response.dart';
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
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../constants/Constant.dart';
import 'package:toast/toast.dart';

class MyProfile extends StatefulWidget {
  final String countryCode;
  final String mobileNo;
  final int userId;
  final String from;

  MyProfile(this.countryCode, this.mobileNo, this.userId, this.from, {Key key})
      : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  //} with SingleTickerProviderStateMixin {


  var latitude,longitude;
  bool _obscureText = true;
  bool _obscureTextCon = true;

  bool passError=false;
  final passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  String _password;

  bool bCompanyError=false;
  final businessNameController = TextEditingController();
  final FocusNode _businessNameFocus = FocusNode();
  String _businessName;

  bool bTypeError=false;
  final businessTypeController = TextEditingController();
  final FocusNode _businessTypeFocus = FocusNode();
  String _businessType;

  bool emailError=false;
  final emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  String _email;

  bool bRegNumError=false;
  final businessRegistrationNumController = TextEditingController();
  final FocusNode _brnumFocus = FocusNode();
  String _brnumber;

  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool _checkedValue = false;

  /*AnimationController _animationController;
  Animation _animation;*/

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getUserLocationNew();
    /*  _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    passwordController.dispose();
    _passwordFocus.dispose();
    businessNameController.dispose();
    _businessNameFocus.dispose();
    businessTypeController.dispose();
    _businessTypeFocus.dispose();
    emailController.dispose();
    _emailFocus.dispose();
    businessRegistrationNumController.dispose();
    _brnumFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
    return Material(
      //resizeToAvoidBottomPadding: false,
      /*appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image(
              image: new AssetImage('assets/images/step_2.png'),
              width: 50.0,
              height: 40.0,
              //fit: BoxFit.cover,
            ),
          ),
        ],
        backgroundColor: Color(ColorValues.white),
        title: Text(
          StringValues.TEXT_MY_PROFILE,
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
      child:  WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
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
                        //elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            widget.from != 'Dashboard'
                                ? Padding(
                        padding: const EdgeInsets.only(top:4.0,left: 16.0),
                        child: GestureDetector(
                          onTap: (){
                            confirmBack();
                          },
                          child: Image(
                            image: new AssetImage(
                                'assets/images/left_black_arrow.png'),
                            width: 20.0,
                            height: 24.0,
                            //fit: BoxFit.fitHeight,
                          ),
                        ),
                      ):
                            IconButton(
                              icon: new Icon(
                                Icons.arrow_back_ios,
                                color: Colors.transparent,
                              ),

                            ),
                            Center(
                              child: Text(
                                StringValues.TEXT_MY_PROFILE,
                                style: TextStyle(
                                    color: Color(ColorValues.black),
                                    fontSize: 20.0,
                                    fontFamily: StringValues.customSemiBold),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(width: 20.0,)
                            ),
                            /*IconButton(
                        icon: new Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),*/
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      //color: Colors.red,
                      child: ListView(
                        //scrollDirection: ,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 24.0, right: 24.0, bottom: 24.0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  children: <Widget>[

                                    Image(
                                      image: new AssetImage(
                                          'assets/images/profile_img_girl.png'),
                                      width: 175.0,
                                      height: 124.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 24.0),
                                      child: Text(
                                        StringValues.TEXT_PLZ_COMPLETE,
                                        style: TextStyle(
                                          color: Color(ColorValues.text_view_hint),
                                          fontSize: 18.0,
                                          fontFamily: StringValues.customLight,
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        /*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                        bCompanyError && _autoValidate
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
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: TextFormField(
                                              controller: businessNameController,
                                              focusNode: _businessNameFocus,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                              TextInputAction.next,

                                              //autofocus: true,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                helperText: ' ',
                                                /*prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/business.png"),
                                                    ),
                                                  ),
                                                ),*/
                                                prefixIcon: Container(
                                                  width: 0,
                                                  height: 0,
                                                  alignment: Alignment(-0.99, 0.0),
                                                  child: Image.asset("assets/images/business.png",width: 22,),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                counterText: '',
                                                //labelText: StringValues.TEXT_FIRST_NAME,
                                                hintText: StringValues
                                                    .TEXT_BUSINESS_NAME,
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                              ),

                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _businessNameFocus,
                                                    _businessTypeFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.validateTextField(
                                                    arg);
                                                //setState(() {
                                                if (val != null) {
                                                  bCompanyError = true;
                                                  val = StringValues.bNameErrorMsg;
                                                }
                                                else
                                                  bCompanyError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.validateTextField(
                                                    arg);
                                                //setState(() {
                                                if (val != null) {
                                                  bCompanyError = true;
                                                  val = StringValues.bNameErrorMsg;
                                                }
                                                else
                                                  bCompanyError = false;
                                                //});
                                                setState(() {});
                                              },
                                              onSaved: (value) {
                                                //print('email value:: $value');
                                                _businessName = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Stack(
                                      children: <Widget>[
                                        /*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                        bTypeError && _autoValidate
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
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: TextFormField(
                                              controller: businessTypeController,
                                              focusNode: _businessTypeFocus,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                              TextInputAction.next,

                                              //autofocus: true,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                helperText: ' ',
                                                /*prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/business.png"),
                                                    ),
                                                  ),
                                                ),*/
                                                prefixIcon: Container(
                                                  width: 0,
                                                  height: 0,
                                                  alignment: Alignment(-0.99, 0.0),
                                                  child: Image.asset("assets/images/business.png",width: 22,),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                counterText: '',
                                                //labelText: StringValues.TEXT_FIRST_NAME,
                                                hintText: StringValues
                                                    .TEXT_BUSINESS_TYPE,
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                              ),

                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _businessTypeFocus,
                                                    _brnumFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.validateTextField(
                                                    arg);
                                                //setState(() {
                                                if (val != null) {
                                                  bTypeError = true;
                                                  val=StringValues.bTypeErrorMsg;
                                                }
                                                else
                                                  bTypeError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.validateTextField(
                                                    arg);
                                                //setState(() {
                                                if (val != null) {
                                                  bTypeError = true;
                                                  val=StringValues.bTypeErrorMsg;
                                                }
                                                else
                                                  bTypeError = false;
                                                //});
                                                setState(() {});
                                              },
                                              onSaved: (value) {
                                                //print('email value:: $value');
                                                _brnumber = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        /*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                        bRegNumError && _autoValidate
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
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: TextFormField(
                                              controller: businessRegistrationNumController,
                                              focusNode: _brnumFocus,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                              TextInputAction.next,

                                              //autofocus: true,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                helperText: ' ',
                                                /*prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/business.png"),
                                                    ),
                                                  ),
                                                ),*/
                                                prefixIcon: Container(
                                                  width: 0,
                                                  height: 0,
                                                  alignment: Alignment(-0.99, 0.0),
                                                  child: Image.asset("assets/images/business.png",width: 22,),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                counterText: '',
                                                //labelText: StringValues.TEXT_FIRST_NAME,
                                                hintText: StringValues
                                                    .TEXT_BUSINESS_REGISTRATION_NUMBER,
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                              ),

                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _brnumFocus,
                                                    _emailFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.validateNumber(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  bRegNumError = true;
                                                else
                                                  bRegNumError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.validateNumber(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  bRegNumError = true;
                                                else
                                                  bRegNumError = false;
                                                //});
                                                setState(() {
                                                });
                                              },

                                              onSaved: (value) {
                                                //print('email value:: $value');
                                                _brnumber = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                    Stack(
                                      children: <Widget>[
                                        /*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                        emailError && _autoValidate
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
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: TextFormField(
                                              controller: emailController,
                                              focusNode: _emailFocus,
                                              keyboardType: TextInputType.emailAddress,
                                              textInputAction:
                                              TextInputAction.next,

                                              //autofocus: true,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                helperText: ' ',
                                                /*prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/email_icon.png"),
                                                    ),
                                                  ),
                                                ),*/
                                                prefixIcon: Container(
                                                  width: 0,
                                                  height: 0,
                                                  alignment: Alignment(-0.99, 0.0),
                                                  child: Image.asset("assets/images/email_icon.png",width: 22,),
                                                ),
                                                //icon: Icon(Icons.lock_outline),
                                                counterText: '',
                                                //labelText: StringValues.TEXT_FIRST_NAME,
                                                hintText: StringValues
                                                    .TEXT_Email_ID,
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                              ),

                                              onFieldSubmitted: (_) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _emailFocus,
                                                    _passwordFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                Validation.isEmail(arg);
                                                //setState(() {
                                                if (val != null)
                                                  emailError = true;
                                                else
                                                  emailError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.isEmail(arg);
                                                //setState(() {
                                                if (val != null)
                                                  emailError = true;
                                                else
                                                  emailError = false;
                                                //});
                                                setState(() {});
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

                                    Stack(
                                      children: <Widget>[
                                        /*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                        passError && _autoValidate
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
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: TextFormField(
                                              controller: passwordController,
                                              focusNode: _passwordFocus,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                              TextInputAction.next,
                                              obscureText: _obscureText,

                                              //autofocus: true,
                                              decoration: InputDecoration(
                                                //contentPadding: EdgeInsets.all(0.0),
                                                helperText: ' ',
                                                /*prefixIcon: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0.0),
                                                  child: Transform.scale(
                                                    scale: 0.65,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: new Image.asset(
                                                          "assets/images/password_ic.png"),
                                                    ),
                                                  ),
                                                ),*/
                                                prefixIcon: Container(
                                                  width: 0,
                                                  height: 0,
                                                  alignment: Alignment(-0.99, 0.0),
                                                  child: Image.asset("assets/images/password_ic.png",width: 22,),
                                                ),
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
                                                //icon: Icon(Icons.lock_outline),
                                                counterText: '',
                                                //labelText: StringValues.TEXT_FIRST_NAME,
                                                hintText: StringValues
                                                    .TEXT_PASSWORD,
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey)),
                                                /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                              ),


                                              validator: (String arg) {
                                                String val =
                                                Validation.validatePassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  passError = true;
                                                else
                                                  passError = false;
                                                //});
                                                return val;
                                              },
                                              onChanged: (String arg) {
                                                String val =
                                                Validation.validatePassword(
                                                    arg);
                                                //setState(() {
                                                if (val != null)
                                                  passError = true;
                                                else
                                                  passError = false;
                                                //});
                                                setState(() {});
                                              },
                                              onSaved: (value) {
                                                //print('email value:: $value');
                                                _password = value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                              /*      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5.0, top: 10.0)),
                                    Row(
                                      children: <Widget>[
                                        new Image.asset("assets/images/check.png",width: 20,height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: new Text(StringValues.TEXT_I_AGREE_TO,
                                            style: TextStyle(
                                                color: Color(ColorValues.text_view_hint),
                                                fontSize: 16.0
                                            ),
                                          ),
                                        ),
                                        new Text(StringValues.TEXT_TERM_AND_CONDITION,
                                          style: TextStyle(
                                              decoration:TextDecoration.underline ,
                                              color: Color(ColorValues.text_view_hint),
                                              fontSize: 16.0
                                          ),
                                        )
                                      ],
                                    ),*/
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      mainAxisSize:
                                      MainAxisSize.max,
                                      children: <Widget>[

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
                                            width: 26.0,
                                            height: 26.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  StringValues
                                                      .i_agree_to,
                                                  style: TextStyle(
                                                      color: Color(
                                                          ColorValues
                                                              .text_view_hint),
                                                      fontSize:
                                                      14.0),
                                                ),
                                                Text(
                                                  StringValues
                                                      .t_n_c,
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration
                                                          .underline,
                                                      color: Color(
                                                          ColorValues
                                                              .text_view_hint),
                                                      fontSize:
                                                      14.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 30.0, top: 10.0)),
                                    SizedBox(
                                      width: 250.0,
                                      height: 52.0,
                                      child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            new BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: Color(
                                                    ColorValues.primaryColor))),
                                        onPressed: () {
                                          validateMyProfile();
                                          //getAlertDialog(context);
                                        },
                                        color: Color(ColorValues.primaryColor),
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
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleCon() {
    setState(() {
      _obscureTextCon = !_obscureTextCon;
    });
  }

  Widget getAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0.0),
          elevation: 0.0,
          content: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            //margin: const EdgeInsets.only(left: 24.0, right: 24.0),
            decoration: new BoxDecoration(
              color: Color(ColorValues.white),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
                //bottomLeft: Radius.circular(32.0),
                //bottomRight: Radius.circular(32.0)
              ),
            ),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      //color: Color(ColorValues.primaryColor),
                      decoration: new BoxDecoration(
                        color: Color(ColorValues.primaryColor),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                          //bottomLeft: Radius.circular(32.0),
                          //bottomRight: Radius.circular(32.0)
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            //alignment: Alignment.topRight,
                            top: 0.0,
                            right: -10.0,
                            child: Image(
                              image: new AssetImage(
                                  'assets/images/top_alert_img.png'),
                              width: 55.0,
                              height: 55.0,
                              //fit: BoxFit.cover,
                            ),
                          ),
                          new Padding(
                              padding: new EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 20.0),
                              child: Center(
                                child: new Text(
                                  StringValues.TEXT_REGISTRATION_POPUP_HEADER,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontFamily: StringValues.customSemiBold,
                                      fontSize: 15.0,
                                      color: Color(ColorValues.white)),
                                ),
                              )),
                          Positioned(
                            bottom: 0.0,
                            left: -10.0,
                            //alignment: Alignment.bottomLeft,
                            child: Image(
                              image: new AssetImage(
                                  'assets/images/bottom_alert_img.png'),
                              width: 55.0,
                              height: 55.0,
                              //fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    child: new Text(
                      StringValues.TEXT_REGISTRATION_MSG,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontFamily: StringValues.customRegular,
                          fontSize: 15.0,
                          color: Color(ColorValues.grey_light_text)),
                    )),
                SizedBox(
                  width: 120.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side:
                        BorderSide(color: Color(ColorValues.accentColor))),
                    onPressed: () {},
                    color: Color(ColorValues.accentColor),
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(StringValues.TEXT_ALLOW.toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                new InkWell(
                  child: new Padding(
                      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                      child: new Text(
                        StringValues.TEXT_DONT_ALLOW,
                        style: new TextStyle(
                            fontFamily: StringValues.customSemiBold,
                            fontSize: 17.0),
                      )),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    //afterAnimation();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future validateMyProfile() async {
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

  void callMyProfileApi() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });

/*    {
      "businessName": "string",
    "businessRegistrationNumber": "string",
    "businessType": "string",
    "email": "string",
    "password": "string",
    "timezone": "string",
    "userId": 0
    }*/



    Map<String, dynamic> requestJson = {
      "businessName": businessNameController.text,
      "businessRegistrationNumber": businessRegistrationNumController.text,
      "businessType": businessTypeController.text,
      "email" : emailController.text,
      "timezone": "GMT+5:30",
      "password":  Utils.encodeStringToBase64(passwordController.text),
      "userId": widget.userId,
      "latitude":latitude,
      "longitude":longitude,
      "isAgree": _checkedValue
    };

    print("requestJson::: ${requestJson}");
    //Map<String, dynamic> requestJson1 = {"mobile": "7000543895"};
    String access_token= await SharedPreferencesHelper.getPrefString(SharedPreferencesHelper.ACCESS_TOKEN);


    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };

    String dataURL =
        Constants.BASE_URL + Constants.REGISTRATION_PROFILE_STEP2_API;
    print("Profile URL::: $dataURL");
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
      ResponsePodo apiResponse = new ResponsePodo.fromJson(jsonResponseMap);
      print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

      if (response.statusCode == 200) {
        print("statusCode 200....");
        if (apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("Registration Successfull!!!");
          Toast.show("Registration Successfull!!!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
          //callLoginApi();
          _performLogin();
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print("statusCode error....");
        Toast.show(apiResponse.message, context,
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

  /*void _navigateToLogin() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/loginOptions', (Route<dynamic> route) => false);
  }*/

  /* void fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }*/

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
      //callMyProfileApi();
      if (_checkedValue) {
        callMyProfileApi();
      } else {
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
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }
  Future<String> getUserLocationNew() async {
//call this async method from whereever you need
    print("getUserLocationNew()");
    String address = "";
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    var currentLocation = myLocation;
    final coordinates =
    new Coordinates(myLocation.latitude, myLocation.longitude);
     latitude=myLocation.latitude;
     longitude=myLocation.longitude;
    print("latitude---"+myLocation.latitude.toString());
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

    address =
    '${first.addressLine},${first.featureName},${first.subAdminArea},${first.adminArea}';
    print('Address:: $address');
    return address;
  }

  void callLoginApi() async {
    String encodedPassword = Utils.encodeStringToBase64(_password);
    print("login _password::: $_password \n_email:: $_email \n_countryCode::: ${widget.countryCode} ");
    print("login encodedPassword::: $encodedPassword");
    /*  if (!mounted) return;
    setState(() {
      _isInProgress = true;
    })*/;

    String access_token= await SharedPreferencesHelper.getPrefString(SharedPreferencesHelper.ACCESS_TOKEN);

//http://103.76.253.133:8751/userauth/oauth/token?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    print(headers);
    String email="abcd@yopmail.com";
    String dataURL = Constants.BASE_URL +
        Constants.LOGIN_API +
        //"?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2";
        '?grant_type=password&username=$email&password=$encodedPassword&countryCode=${widget.countryCode}&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByEmail}';
    //"?grant_type=password&username=$_email&password=$encodedPassword&countryCode=$_countryCode&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByMobile}";
    print(dataURL);
    try {
      http.Response response = await http.post(dataURL,
          headers: headers);


      //if (!mounted) return;
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;
      print("response::: ${response.body}");

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
      }

      else {
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
    //if(widget.from == 'Dashboard'){
    SharedPreferencesHelper.setPrefBool(
        SharedPreferencesHelper.IS_REGISTRATION_COMPLETE, true);
    //}

    /*final result =
    await Navigator.of(context).pushReplacementNamed('/dashboard');*/
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);

    /*final resultData = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );*/
    print('_performLogin belo push');
    //Navigator.of(context).pop(Constants.popScreen);
    print('_performLogin belo pop');
  }

  Future<bool> _onBackPressed() async {
    final TwoButtonSelection action = await new CustomAlertDialog()
        .getTwoBtnAlertDialog(context, StringValues.TEXT_GOBACK_MESSAGE,
        StringValues.TEXT_NO, StringValues.TEXT_YES, '');
    if (action == TwoButtonSelection.Second) {
      //Navigator.of(context).pop();
      return true;
    }else {
      //Navigator.of(context).pop(false);
      return false;
    }
  }

  Future confirmBack() async {

    final TwoButtonSelection action = await new CustomAlertDialog()
        .getTwoBtnAlertDialog(context, StringValues.TEXT_GOBACK_MESSAGE,
        StringValues.TEXT_NO, StringValues.TEXT_YES, '');
    if (action == TwoButtonSelection.Second) {
      Navigator.pop(context);
    }
  }
}
