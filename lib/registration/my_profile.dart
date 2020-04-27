import 'dart:convert';
import 'dart:io';

import 'package:deliva/home_screen/dashboard.dart';
import 'package:deliva/login/login_options.dart';
import 'package:deliva/podo/login_response.dart';
import 'package:deliva/services/number_text_input_formator.dart';
import 'package:deliva/podo/api_response.dart';
import 'package:deliva/registration/registration.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  final passwordController = TextEditingController();

  //final confirmPasswordController = TextEditingController();

  //final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _password;

  //String _confirmPassword;

  bool _obscureText = true;
  bool _obscureTextCon = true;

  final mobileNoController = TextEditingController();
  final FocusNode _mobileNoFocus = FocusNode();
  String _mobileNo;

  final fullNameController = TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();
  String _fullName;

  final emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  String _email;

  final addressController = TextEditingController();
  final FocusNode _addressFocus = FocusNode();
  String _address;

  NumberTextInputFormatter _phoneNumberFormatter = NumberTextInputFormatter(1);

  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool isPasswordError = false;

  bool isNameError = false;
  bool isEmailError = false;
  bool isAddressError = false;

  /*AnimationController _animationController;
  Animation _animation;*/

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    mobileNoController.text = "+${widget.countryCode} ${widget.mobileNo}";

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
    mobileNoController.dispose();
    _mobileNoFocus.dispose();
    fullNameController.dispose();
    _fullNameFocus.dispose();
    emailController.dispose();
    _emailFocus.dispose();
    addressController.dispose();
    _addressFocus.dispose();
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
                              StringValues.TEXT_MY_PROFILE,
                              style: TextStyle(
                                  color: Color(ColorValues.black),
                                  fontSize: 20.0,
                                  fontFamily: StringValues.customSemiBold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Image(
                              image: new AssetImage('assets/images/step_2.png'),
                              width: 50.0,
                              height: 40.0,
                              //fit: BoxFit.cover,
                            ),
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
                  //Container(height: 16.0,),
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
                                        color:
                                            Color(ColorValues.text_view_theme),
                                        fontSize: 18.0,
                                        fontFamily: StringValues.customLight,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Image(
                                          image: new AssetImage(
                                              'assets/images/phone_black.png'),
                                          width: 16.0,
                                          height: 16.0,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Container(
                                        width: 12.0,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: mobileNoController,
                                          focusNode: _mobileNoFocus,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 13,
                                          enabled: false,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            // Fit the validating format.
                                            //_phoneNumberFormatter,
                                          ],
                                          //to block space character
                                          textInputAction: TextInputAction.next,

                                          //autofocus: true,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            //labelText: StringValues.TEXT_MOBILE_NO,
                                            hintText:
                                                StringValues.TEXT_MOBILE_NO,
                                            border: InputBorder.none,
                                            /*errorText:
                                                                    submitFlag ? _validateEmail() : null,*/
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      /*Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Text(
                                          StringValues.TEXT_NEW_PASSWORD,
                                          style: TextStyle(
                                              color: Color(
                                                  ColorValues.primaryColor),
                                              fontSize: 17.0),
                                        ),
                                      ),*/
                                      isPasswordError
                                          ? Positioned(
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
                                            )
                                          : Container(),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          primaryColor: Color(
                                              ColorValues.text_view_theme),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 14.0),
                                          child: SizedBox(
                                            height: 65.0,
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
                                              decoration: InputDecoration(
                                                helperText: ' ',
                                                //labelText: StringValues.TEXT_PASSWORD,
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
                                                    _fullNameFocus);
                                              },
                                              validator: (String arg) {
                                                String val =
                                                    Validation.validatePassword(
                                                        arg);
                                                //setState(() {
                                                if (val != null)
                                                  isPasswordError = true;
                                                else
                                                  isPasswordError = false;
                                                //});
                                                return val;
                                              },

                                              onSaved: (value) {
                                                _password = value;
                                              },
                                            ),
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
                                      isNameError
                                          ? Positioned(
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
                                            )
                                          : Container(),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          primaryColor: Color(
                                              ColorValues.text_view_theme),
                                        ),
                                        child: SizedBox(
                                          height: 65.0,
                                          child: TextFormField(
                                            controller: fullNameController,
                                            focusNode: _fullNameFocus,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,

                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.all(0.0),
                                              helperText: ' ',
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: new Image.asset(
                                                        "assets/images/name_icon.png"),
                                                  ),
                                                ),
                                              ),
                                              //icon: Icon(Icons.lock_outline),
                                              counterText: '',
                                              //labelText: StringValues.TEXT_FIRST_NAME,
                                              hintText: StringValues
                                                  .TEXT_FIRST_NAME,
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
                                                  _fullNameFocus,
                                                  _emailFocus);
                                            },
                                            validator: (String arg) {
                                              String val =
                                                  Validation.validateName(
                                                      arg);
                                              //setState(() {
                                              if (val != null)
                                                isNameError = true;
                                              else
                                                isNameError = false;
                                              //});
                                              return val;
                                            },
                                            onSaved: (value) {
                                              //print('email value:: $value');
                                              _fullName = value;
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
                                      isEmailError
                                          ? Positioned(
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
                                            )
                                          : Container(),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          primaryColor: Color(
                                              ColorValues.text_view_theme),
                                        ),
                                        child: SizedBox(
                                          height: 65.0,
                                          child: TextFormField(
                                            controller: emailController,
                                            focusNode: _emailFocus,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,

                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.all(0.0),
                                              helperText: ' ',
                                              prefixIcon: Padding(
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
                                              ),
                                              //icon: Icon(Icons.lock_outline),
                                              counterText: '',
                                              //labelText: StringValues.TEXT_EMAIL,
                                              hintText:
                                                  StringValues.TEXT_EMAIL,
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
                                              Utils.fieldFocusChange(context,
                                                  _emailFocus, _addressFocus);
                                            },
                                            validator: (String arg) {
                                              String val =
                                                  Validation.isEmail(arg);
                                              //setState(() {
                                              if (val != null)
                                                isEmailError = true;
                                              else
                                                isEmailError = false;
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
                                  /*   Row(
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            'assets/images/email_icon.png'),
                                        width: 16.0,
                                        height: 16.0,
                                        //fit: BoxFit.fitHeight,
                                      ),
                                      Container(width: 12.0,),
                                      Expanded(
                                        child: TextFormField(
                                          controller: emailController,
                                          focusNode: _emailFocus,
                                          keyboardType: TextInputType.emailAddress,
                                          */ /*inputFormatters: [
                                          WhitelistingTextInputFormatter.digitsOnly,
                                          // Fit the validating format.
                                          //_phoneNumberFormatter,
                                        ],*/ /*
                                          //to block space character
                                          textInputAction: TextInputAction.next,

                                          //autofocus: true,
                                          decoration: InputDecoration(
                                            labelText: StringValues.TEXT_EMAIL,
                                            hintText: StringValues.TEXT_EMAIL,
                                            border: InputBorder.none,
                                            */ /*errorText:
                                                                    submitFlag ? _validateEmail() : null,*/ /*
                                          ),
                                          onFieldSubmitted: (_) {
                                            Utils.fieldFocusChange(
                                                context, _emailFocus, _addressFocus);
                                          },
                                          validator: Validation.isEmail,
                                          onSaved: (value) {
                                            _email = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      ),
                                  ),*/
                                  Stack(
                                    children: <Widget>[
                                      /*Positioned(
                                        top:0,
                                        left: 0,
                                        child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*/
                                      isAddressError
                                          ? Positioned(
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
                                            )
                                          : Container(),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          primaryColor: Color(
                                              ColorValues.text_view_theme),
                                        ),
                                        child: SizedBox(
                                          height: 65.0,
                                          child: TextFormField(
                                            controller: addressController,
                                            focusNode: _addressFocus,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.done,

                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.all(0.0),
                                              helperText: ' ',
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: new Image.asset(
                                                        "assets/images/location_ic.png"),
                                                  ),
                                                ),
                                              ),
                                              //icon: Icon(Icons.lock_outline),
                                              counterText: '',
                                              //labelText: StringValues.TEXT_ADDRESS,
                                              hintText:
                                                  StringValues.TEXT_ADDRESS,
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
                                              _addressFocus.unfocus();
                                              validateMyProfile();
                                            },
                                            validator: (String arg) {
                                              String val =
                                                  Validation.validateAddress(
                                                      arg);
                                              //setState(() {
                                              if (val != null)
                                                isAddressError = true;
                                              else
                                                isAddressError = false;
                                              //});
                                              return val;
                                            },
                                            onSaved: (value) {
                                              //print('email value:: $value');
                                              _address = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /*Row(
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            'assets/images/location_ic.png'),
                                        width: 16.0,
                                        height: 16.0,
                                        //fit: BoxFit.fitHeight,
                                      ),
                                      Container(width: 12.0,),
                                      Expanded(
                                        child: TextFormField(
                                          controller: addressController,
                                          focusNode: _addressFocus,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          */ /*inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                // Fit the validating format.
                                _phoneNumberFormatter,
                              ],*/ /*
                                          //to block space character
                                          textInputAction: TextInputAction.done,

                                          //autofocus: true,
                                          decoration: InputDecoration(
                                            labelText: StringValues.TEXT_ADDRESS,
                                            hintText: StringValues.TEXT_ADDRESS,
                                            border: InputBorder.none,
                                            */ /*errorText:
                                                                    submitFlag ? _validateEmail() : null,*/ /*
                                          ),
                                          onFieldSubmitted: (value) {
                                            _addressFocus.unfocus();
                                            validateMyProfile();
                                          },
                                          validator: Validation.validateAddress,
                                          onSaved: (value) {
                                            _address = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),*/
                                  Container(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String currentLocation = await new Utils()
                                          .getUserLocationNew();
                                      setState(() {
                                        addressController.text =
                                            currentLocation;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Image(
                                          image: new AssetImage(
                                              'assets/images/location_yello.png'),
                                          width: 20.0,
                                          height: 20.0,
                                          //fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            StringValues.TEXT_USE_CUR_LOC,
                                            style: TextStyle(
                                              color: Color(
                                                  ColorValues.primaryColor),
                                              fontSize: 15.0,
                                              fontFamily:
                                                  StringValues.customLight,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 30.0, top: 15.0)),
                                  SizedBox(
                                    width: 250.0,
                                    height: 52.0,
                                    child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                          side: BorderSide(
                                              color: Color(
                                                  ColorValues.yellow_light))),
                                      onPressed: () {
                                        validateMyProfile();
                                        //getAlertDialog(context);
                                      },
                                      color: Color(ColorValues.yellow_light),
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
              //WillPopScope(child: Container(), onWillPop: onBackPressed),
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
                            BorderSide(color: Color(ColorValues.yellow_light))),
                    onPressed: () {},
                    color: Color(ColorValues.yellow_light),
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
    print('widget.userId::: ${widget.userId}');
    Map<String, dynamic> requestJson = {
      "address": _address,
      "email": _email,
      "name": _fullName,
      "password": Utils.encodeStringToBase64(_password),
      "timezone": "GMT+5:30",
      "userId": widget.userId
    };
    /* Map<String, dynamic> requestJson = {
      "address": addressController.text.trim(),
      "email": emailController.text.trim(),
      "name": fullNameController.text.trim(),
      "password": passwordController.text.trim(),
      "timezone": "GMT+5:30",
      "userId": widget.userId
    };*/
    print("requestJson::: ${requestJson}");
    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    //Map<String, dynamic> requestJson1 = {"mobile": "7000543895"};
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
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);
      print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

      if (response.statusCode == 200) {
        print("statusCode 200....");
        if (apiResponse.resourceData == null && apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("Registration Successfull!!!");
          /*Toast.show("Registration Successfull!!!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
          //_navigateToLogin();
          //callLoginApi();

          SharedPreferencesHelper.setPrefString(
              SharedPreferencesHelper.NAME, _fullName);

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
        Toast.show("statusCode error....", context,
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

  Future _performLogin() async {
    // This is just a demo, so no actual login here.
    //_saveLoginState();
    //if(widget.from == 'Dashboard'){
    SharedPreferencesHelper.setPrefBool(
        SharedPreferencesHelper.IS_PROFILE_COMPLETE, true);
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
      callMyProfileApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }

  Future<bool> onBackPressed() async {
    print('onBackPressed called');
    //Navigator.of(context).pop(Constants.popScreen);
    /*final resultData = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOptions()),
    );*/
    return true;
  }
/*void callLoginApi() async {
    String encodedPassword = Utils.encodeStringToBase64(_password);
    print("login _password::: $_password \n_email:: $_email \n_countryCode::: ${widget.countryCode} ");
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
        '?grant_type=password&username=$_email&password=$encodedPassword&countryCode=${widget.countryCode}&roleId=${Constants.ROLE_ID}&loginBy=${Constants.loginByEmail}';
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
  }*/
}
