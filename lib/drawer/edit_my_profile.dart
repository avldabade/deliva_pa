import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:async/async.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/delivery_request/aws_policy_helper.dart';
import 'package:deliva_pa/detailPages/edit_operation_page_ad.dart';
import 'package:deliva_pa/home_screen/dashboard.dart';
import 'package:deliva_pa/login/login_options.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/podo/user_profile_data.dart';
import 'package:deliva_pa/services/image_picker_class.dart';
import 'package:deliva_pa/services/input_formatters.dart';
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
import 'package:http/http.dart' as http;

import '../constants/Constant.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;
class EditMyProfile extends StatefulWidget {
  final UserProfileResourceData data;

  EditMyProfile(this.data, {Key key}) : super(key: key);

  @override
  _EditMyProfileState createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
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

  File _imagePath;

  String _imageUrl='';

  int userId;

  /*AnimationController _animationController;
  Animation _animation;*/

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    String mobNo='';
    if(widget.data.countryCode != null && widget.data.countryCode != '') {
      mobNo = '+${widget.data.countryCode} ';
    }
    if(widget.data.mobile != null && widget.data.mobile != '') {
      //mobileNoController.text = "+${widget.data.mobile}";
      mobNo = mobNo + MobileNumberInputFormatter().getFormatedMobileNo(widget.data.mobile);
      print('mobile no:: $mobNo');//${MobileNumberInputFormatter().getFormatedMobileNo(widget.data.mobile)}');
      mobileNoController.text = mobNo;
    }
    if(widget.data.name != null && widget.data.name != '')
    fullNameController.text = "${widget.data.name}";
    if(widget.data.email != null && widget.data.email != '')
    emailController.text = "${widget.data.email}";
    if(widget.data.address != null && widget.data.address != '')
    addressController.text = "${widget.data.address}";
    if(widget.data.profileImageUrl != null && widget.data.profileImageUrl != '')
    _imageUrl=widget.data.profileImageUrl;
    if(widget.data.userId != null && widget.data.userId != '')
    userId=widget.data.userId;
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
                      child:Card(
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
                            Padding(
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
                            ),

                            Center(
                              child: Text(
                                '${StringValues.editProfile.toUpperCase()}',
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
                                    Container(height: 16.0,),
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 35.0,
                                          child: ClipOval(
                                            child: _imagePath != null ?
                                            Image(
                                              image: new FileImage(
                                                  _imagePath),
                                              width: 65.0,
                                              height: 65.0,
                                              fit: BoxFit.cover,
                                            ) : _imageUrl !='' && _imageUrl != null ?
                                            Image.network(
                                              _imageUrl,
                                              width: 65,
                                              height: 65,
                                              fit: BoxFit.cover,
                                            )
                                            : Image(
                                              image: new AssetImage(
                                                  "assets/images/user_img.png"),
                                              width: 65.0,
                                              height: 65.0,
                                            ),
                                            /*Image.network(
                                                      'https://via.placeholder.com/150',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),*/
                                          ),
                                          backgroundColor: Colors.transparent,

                                        ),
                                        Container(width: 4.0,),
                                        GestureDetector(
                                          onTap: _takePhoto,
                                          child: Image(
                                            image: new AssetImage(
                                                "assets/images/edit_profile_dash.png"),
                                            width: 120.0,
                                            //height: 40.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(height: 16.0,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          StringValues.personalInfo,
                                          style: TextStyle(
                                              color: Color(ColorValues
                                                  .primaryColor),
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(primaryColor: Color(ColorValues.text_view_theme),
                                        splashColor: Colors.transparent,
                                        inputDecorationTheme: new InputDecorationTheme(
                                          contentPadding:
                                          new EdgeInsets.only(top: 16.0),),
                                        //Theme.of(context).copyWith(splashColor: Colors.transparent),

                                      ),
                                      child:  TextFormField(
                                        controller: mobileNoController,
                                        focusNode: _mobileNoFocus,
                                        keyboardType: TextInputType.phone,
                                        //maxLength: 13,
                                        enabled: false,
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter.digitsOnly,
                                          new LengthLimitingTextInputFormatter(11),
                                          new MobileNumberInputFormatter(),
                                          // Fit the validating format.
                                          //_phoneNumberFormatter,
                                        ],
                                        //to block space character
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                          color: Color(ColorValues.black_light),
                                        ),
                                        //autofocus: true,
                                        decoration: InputDecoration(
                                          counterText: ' ',
                                          //labelText: StringValues.TEXT_MOBILE_NO,
                                          hintText: StringValues.TEXT_MOBILE_NO,
                                          //border: InputBorder.none,
                                          disabledBorder:
                                          UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(ColorValues.black_light))),
                                          helperText: ' ',
                                          prefixIcon: /*Padding(
                                            padding:
                                            const EdgeInsets.all(0.0),
                                            child: Transform.scale(
                                              scale: 0.55,
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: new Image.asset(
                                                    "assets/images/phone_icon.png"),
                                              ),
                                            ),
                                          ),*/
                                          Container(
                                            width: 0,
                                            height: 0,
                                            alignment: Alignment(-0.99, 0.0),
                                            child: Image.asset("assets/images/phone_icon.png",width: 22,),
                                          ),
                                          /*errorText:
                                                                  submitFlag ? _validateEmail() : null,*/
                                        ),
                                      ),
                                    ),
                                /*    Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0),
                                      child: new Container(
                                        height: 1.0,
                                        color: Colors.black,
                                      ),
                                    ),*/

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
                                          data: Theme.of(context).copyWith(primaryColor: Color(ColorValues.text_view_theme),
                                              splashColor: Colors.transparent,
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          //Theme.of(context).copyWith(splashColor: Colors.transparent),

                                          ),
                                          child: TextFormField(
                                            controller: fullNameController,
                                            focusNode: _fullNameFocus,
                                            maxLength: 35,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              //fillColor: Colors.white,
                                              //filled: true,
                                              counterText: ' ',
                                              //labelText: StringValues.TEXT_FULL_NAME,
                                              hintText: StringValues.TEXT_FULL_NAME,
                                              //border: InputBorder.none,
                                              suffixIcon: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: (){
                                                      fullNameController.clear();
                                                      //emptyField();
                                                    },
                                                    icon: Image.asset( 'assets/images/img_cross_icon_old.png'),
                                                  ),
                                                ),
                                              ),
                                              prefixIcon: /*Padding(
                                                padding:
                                                const EdgeInsets.all(0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: new Image.asset(
                                                        "assets/images/user_name.png"),
                                                  ),
                                                ),
                                              ),*/
                                              Container(
                                                width: 0,
                                                height: 0,
                                                alignment: Alignment(-0.99, 0.0),
                                                child: Image.asset("assets/images/user_name.png",width: 22,),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                              /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                            ),

                                            onFieldSubmitted: (_) {
                                              Utils.fieldFocusChange(context,
                                                  _fullNameFocus, _emailFocus);
                                            },
                                            validator: (String arg) {
                                              String val =
                                                  Validation.validateName(arg);
                                              //setState(() {
                                              if (val != null)
                                                isNameError = true;
                                              else
                                                isNameError = false;
                                              //});
                                              return val;
                                            },
                                            onChanged: (String arg){
                                              String val =
                                              Validation.validateName(arg);
                                              //setState(() {
                                              if (val != null)
                                                isNameError = true;
                                              else
                                                isNameError = false;
                                              //});
                                              setState(() {
                                              });
                                            },
                                            onSaved: (value) {
                                              //print('email value:: $value');
                                              _fullName = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*Stack(
                                      children: <Widget>[
                                        *//*Positioned(
                                          top:0,
                                          left: 0,
                                          child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),*//*
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
                                            splashColor: Colors.transparent,
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: TextFormField(
                                            controller: fullNameController,
                                            focusNode: _fullNameFocus,
                                            maxLength: 35,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                            TextInputAction.next,
                                            textCapitalization:
                                            TextCapitalization.words,

                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              //labelText: StringValues.TEXT_EMAIL,
                                              hintText: StringValues.TEXT_FULL_NAME,
                                              //border: InputBorder.none,
                                              helperText: ' ',
                                              prefixIcon: Padding(
                                                padding:
                                                const EdgeInsets.all(0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: new Image.asset(
                                                        "assets/images/user_name.png"),
                                                  ),
                                                ),
                                              ),

                                             *//* suffixIcon: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: (){
                                                      //emailController.text='';
                                                      emailController.clear();
                                                    },
                                                    icon: Image.asset( 'assets/images/img_cross_icon.png'),
                                                  ),
                                                ),
                                              ),*//*
                                              focusedBorder:
                                              UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              *//*errorText:
                                                                              submitFlag ? _validateEmail() : null,*//*
                                            ),

                                            onFieldSubmitted: (_) {
                                              Utils.fieldFocusChange(context,
                                                  _fullNameFocus, _emailFocus);
                                            },
                                            validator: (String arg) {
                                              String val =
                                              Validation.validateName(arg);
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
                                      ],
                                    ),*/

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
                                            splashColor: Colors.transparent,
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: TextFormField(
                                            controller: emailController,
                                            focusNode: _emailFocus,
                                            maxLength: 35,
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            textInputAction:
                                            TextInputAction.next,

                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              //labelText: StringValues.TEXT_EMAIL,
                                              hintText: StringValues.TEXT_EMAIL,
                                              //border: InputBorder.none,
                                              helperText: ' ',
                                              prefixIcon: /*Padding(
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
                                              Container(
                                                width: 0,
                                                height: 0,
                                                alignment: Alignment(-0.99, 0.0),
                                                child: Image.asset("assets/images/email_icon.png",width: 22,),
                                              ),
                                              suffixIcon: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: (){
                                                      //emailController.text='';
                                                      emailController.clear();
                                                    },
                                                    icon: Image.asset( 'assets/images/img_cross_icon_old.png'),
                                                  ),
                                                ),
                                              ),
                                              focusedBorder:
                                              UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
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
                                            onChanged: (String arg){
                                              String val =
                                              Validation.isEmail(arg);
                                              //setState(() {
                                              if (val != null)
                                                isEmailError = true;
                                              else
                                                isEmailError = false;
                                              //});
                                              setState(() {

                                              });
                                            },
                                            onSaved: (value) {
                                              //print('email value:: $value');
                                              _email = value;
                                            },
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
                                              splashColor: Colors.transparent,
                                            inputDecorationTheme: new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets.only(top: 16.0),),
                                          ),
                                          child: TextFormField(
                                            controller: addressController,
                                            focusNode: _addressFocus,
                                            maxLength: 100,
                                            maxLines: null,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.done,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.all(0.0),
                                              counterText: '',
                                              //labelText: StringValues.TEXT_ADDRESS,
                                              hintText: StringValues.TEXT_ADDRESS,
                                              //border: InputBorder.none,
                                              helperText: ' ',
                                              prefixIcon: /*Padding(
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
                                              ),*/
                                              Container(
                                                width: 0,
                                                height: 0,
                                                alignment: Alignment(-0.99, 0.0),
                                                child: Image.asset("assets/images/location_ic.png",width: 22,),
                                              ),
                                              suffixIcon: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 0.0),
                                                child: Transform.scale(
                                                  scale: 0.65,
                                                  child: IconButton(
                                                    onPressed: (){
                                                      //addressController.text='';
                                                      this.setState((){
                                                        addressController.clear();
                                                      });
                                                    },
                                                    icon: Image.asset( 'assets/images/img_cross_icon_old.png'),
                                                  ),
                                                ),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),

                                              /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                            ),

                                            onFieldSubmitted: (_) {
                                              _addressFocus.unfocus();
                                              validateMyProfile();
                                            },
                                            validator: (String arg) {
                                              String val =
                                                  Validation.validateAddress(arg);
                                              //setState(() {
                                              if (val != null)
                                                isAddressError = true;
                                              else
                                                isAddressError = false;
                                              //});
                                              return val;
                                            },
                                            onChanged: (String arg){
                                              String val =
                                              Validation.validateAddress(arg);
                                              //setState(() {
                                              if (val != null)
                                                isAddressError = true;
                                              else
                                                isAddressError = false;
                                              //});
                                              setState(() {

                                              });
                                            },
                                            onSaved: (value) {
                                              //print('email value:: $value');
                                              _address = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      height: 0.0,
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
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: GestureDetector(
                                        onTap: _navigateToEditOperationalHours,
                                        child: Card(
                                          color: Color(ColorValues.white),
                                          elevation: 0,
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color(ColorValues.greyCardBorder),
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              '${StringValues.changeOperationalHours}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(ColorValues.black_light),
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20.0, top: 0.0)),
                                    Row(
                                      //mainAxisSize: MainAxisSize.max,
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              confirmBack();
                                            },
                                            child: Container(
                                              //width: screenWidth / 3.2,
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                borderRadius: new BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                //color: Color(ColorValues.primaryColor),
                                                //Color(ColorValues.primaryColor),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: Color(ColorValues.black_light),
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    '${StringValues.TEXT_CANCEL}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(ColorValues.black_light),
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(width: 16.0,),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              validateMyProfile();
                                            },
                                            child: Container(
                                              //width: screenWidth / 3.2,
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                borderRadius: new BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color: Color(ColorValues.primaryColor),
                                                //Color(ColorValues.primaryColor),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: Color(ColorValues.primaryColor),
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    '${StringValues.TEXT_SAVE}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        *//*SizedBox(
                                            width: 130.0,
                                            height: 45.0,
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  side: BorderSide(
                                                      color: Color(ColorValues
                                                          .black_light))),
                                              onPressed: () {
                                                //validateMyProfile();
                                                //getAlertDialog(context);
                                                isPublished = false;
                                                validateDeliveryRequest();
                                              },
                                              color: Color(ColorValues.white),
                                              textColor: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Text(
                                                    StringValues.TEXT_SAVE
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(ColorValues
                                                            .black_light))),
                                              ),
                                            ),
                                          ),*//*
                                        GestureDetector(
                                          onTap: () {
                                            print('save clicked');
                                            confirmBack();
                                          },
                                          child: Container(
                                            width: 130.0,
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              //color: Color(ColorValues.primaryColor),
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(ColorValues
                                                    .black_light),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.0),
                                              child: Center(
                                                child: Text(
                                                  StringValues.TEXT_CANCEL
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Color(ColorValues
                                                        .black_light),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //validateMyProfile();
                                            //getAlertDialog(context);
                                            print('save_publish clicked');
                                            validateMyProfile();
                                          },
                                          child: Container(
                                            width: 130.0,
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: Color(
                                                  ColorValues.primaryColor),
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(ColorValues
                                                    .primaryColor),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.0),
                                              child: Center(
                                                child: Text(
                                                  StringValues.TEXT_SAVE
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        *//*SizedBox(
                                            width: 130.0,
                                            height: 45.0,
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  side: BorderSide(
                                                      color: Color(ColorValues
                                                          .accentColor))),
                                              onPressed: () {
                                                //validateMyProfile();
                                                //getAlertDialog(context);

                                                isPublished = true;
                                                validateDeliveryRequest();
                                              },
                                              color:
                                                  Color(ColorValues.accentColor),
                                              textColor: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Text(
                                                    StringValues.save_publish
                                                        .toUpperCase(),
                                                    style: TextStyle(fontSize: 12)),
                                              ),
                                            ),
                                          ),*//*
                                      ],
                                    ),*/
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

  void callUpdateMyProfileApi() async {

    Map<String, dynamic> requestJson = {
      "address": _address,
      "email": _email,
      "mobile": widget.data.mobile,
      "name": _fullName,
      "profileImageUrl": _imageUrl,
      "userId": userId
    };

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
        Constants.BASE_URL + Constants.update_user_profile_info;
    print("Profile URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
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

      if (response.statusCode == 200) {
        print("statusCode 200....");
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

        if (apiResponse.resourceData == null && apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("profile updated successfully!!!");

          SharedPreferencesHelper.setPrefString(SharedPreferencesHelper.NAME, _fullName);
          SharedPreferencesHelper.setPrefString(SharedPreferencesHelper.USER_EMAIL, _email);
          SharedPreferencesHelper.setPrefString(SharedPreferencesHelper.USER_IMAGE_URL, _imageUrl);

          final OKButtonSelection okAction = await new CustomAlertDialog()
              .getOKAlertDialog(
              context, StringValues.profileUpdateSuccess, "",'assets/images/check_mark.png');

          if (okAction == OKButtonSelection.OK) {
            Navigator.of(context).pop('refresh');

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
    }else {
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

  Future _validateInputs() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
      if(_imagePath != null){
        setState(() {
          _isInProgress = true;
        });
        _imageUrl = await getUploadUrlFromAWS(_imagePath);
        callUpdateMyProfileApi();
      }else
      callUpdateMyProfileApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }

  Future<String> getUploadUrlFromAWS(File imageFile) async {
    String uploadedImageUrl = '';
    String awsAccessKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_ACCESS_KEY);
    awsAccessKey = Utils.decodeStringFromBase64(awsAccessKey);
    String awsSecretKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_SECRET_KEY);
    awsSecretKey = Utils.decodeStringFromBase64(awsSecretKey);

    print('awsSecretKey::: $awsSecretKey');
    print('awsAccessKey::: $awsAccessKey');

    const _region = 'us-east-2'; //'ap-southeast-1';
    const _s3Endpoint = Constants.USER_PROFILE_UPLOAD_URL;
    //'https://bucketname.s3-ap-southeast-1.amazonaws.com';

    final file = imageFile;
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    /*final policy = Policy.fromS3PresignedPost('uploaded/square-cinnamon.jpg',
        'bucketname', awsAccessKey, 15, length,
        region: _region);*/

    String imageNameNew = await Utils.getFileNameWithExtension(_imagePath);
    final policy = Policy.fromS3PresignedPost('$userId/$imageNameNew',
        Constants.AWS_USER_PROFILE_BUCKET_NAME, awsAccessKey, 15, length,
        region: _region);

    final key =
    SigV4.calculateSigningKey(awsSecretKey, policy.datetime, _region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());
    req.files.add(multipartFile);

    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();
      print('uploaded images response:: $res');
      print('response status::: ${res.statusCode}');
      print('response stream::: ${res.stream}');
      if (res.statusCode == 204) {
        //Toast.show(StringValues.imageUploadSuccess, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        uploadedImageUrl =
        '${Constants.USER_PROFILE_UPLOAD_URL}${userId}/${imageNameNew}';
        print('uploaded images uploadedImageUrl:: $uploadedImageUrl');
        return uploadedImageUrl;
      }else{
        setState(() {
          _isInProgress = false;
        });
        _isSubmitPressed=false;
      }
    } catch (e) {
      print('exception::: ${e.toString()}');
      return uploadedImageUrl;
    }
    return uploadedImageUrl;
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

  Future _takePhoto() async {
    final ImageSelectionAction
    action =
        await new CustomAlertDialog()
        .getImageSelectorAlertDialog(
        context);
    if (action ==
        ImageSelectionAction
            .GALLERY) {
      _imagePath =
          await ImagePickerUtility
          .getImageFromGallery();
      if (_imagePath != null) {
        setState(() {
          _imagePath=_imagePath;
        });
      }
    } else if (action ==
        ImageSelectionAction
            .CAMERA) {
      _imagePath =
          await ImagePickerUtility
          .getImageFromCamera();
      if (_imagePath != null) {
        setState(() {
          _imagePath=_imagePath;
        });
      }
    }
  }

  void emptyField() {
    setState(() {
      fullNameController.text='';
    });
  }


  Future _navigateToEditOperationalHours() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditOperationPageNew()),
    );
  }
}
