import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/forgot_password/forgot_password.dart';
import 'package:deliva_pa/login/login_mobile_otp.dart';
import 'package:deliva_pa/login/login_options.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/login_response.dart';
import 'package:deliva_pa/podo/request_detail.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/podo/user_profile_data.dart';
import 'package:deliva_pa/registration/registration.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/input_formatters.dart';
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

import 'edit_my_profile.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
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

  var hasError = false;

  final businessName = TextEditingController();
  final FocusNode _businessNameFocus = FocusNode();
  String _fullName;

  final emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  String _email;

  final businessTypeController = TextEditingController();
  final FocusNode _businessTypeFocus = FocusNode();

  final businessRegistrationController = TextEditingController();
  final FocusNode _businessRegistrationFocus = FocusNode();
  String _address;

  UserProfileResourceData _data;

  String _imageUrl = '';
  String _PAName = '';

  @override
  void dispose() {
    // TODO: implement dispose
    mobileNoController.dispose();
    _mobileNoFocus.dispose();
    businessName.dispose();
    _businessNameFocus.dispose();
    emailController.dispose();
    _emailFocus.dispose();
    businessTypeController.dispose();
    _businessTypeFocus.dispose();
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

    checkConnection();
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
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 60.0,
                                      color: Color(ColorValues.primaryColor),
                                      //margin: EdgeInsets.only(top: 24.0),
                                      child: Card(
                                        margin: EdgeInsets.all(0.0),
                                        //elevation: 0,
                                        color: Color(ColorValues.primaryColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(0.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              icon:  Image(
                                                image: new AssetImage(
                                                    'assets/images/back_arrow_white.png'),
                                                width: 20.0,
                                                height: 24.0,
                                                //fit: BoxFit.fitHeight,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, null);
                                              },
                                            ),
                                            Center(
                                              child: Text(
                                                StringValues.TEXT_MY_PROFILE,
                                                style: TextStyle(
                                                    color: Color(
                                                        ColorValues.white),
                                                    fontSize: 20.0,
                                                    fontFamily: StringValues
                                                        .customSemiBold),
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
                                            margin: EdgeInsets.only(top: 70.0),
                                          ),
                                          Column(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 40.0,
                                                child: ClipOval(
                                                  child: _imageUrl != ''
                                                      ? Image.network(
                                                          _imageUrl,
                                                          width: 75.0,
                                                          height: 75.0,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image(
                                                          image: new AssetImage(
                                                              "assets/images/user_img.png"),
                                                          width: 80.0,
                                                          height: 80.0,
                                                        ),
                                                  /*Image.network(
                                                    'https://via.placeholder.com/150',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),*/
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8.0),
                                                  child: Text(
                                                    'asdfghjkl',
                                                    //'${_data.name}',
                                                    //textAlign: TextAlign.center,

                                                    style: TextStyle(
                                                        color: Color(
                                                            ColorValues.white),
                                                        fontSize: 25.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              /*Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Image(
                                                      image: new AssetImage(
                                                          "assets/images/pin_white.png"),
                                                      width: 20.0,
                                                      height: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      //Navigator.pop(context);
                                                      onBackPressed();
                                                    },
                                                  ),

                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width - 100,
                                                    child: Text('${businessTypeController.text}',
                                                      //"sfnjsnd wefm wefw wefwrgv wegfrwe",
                                                      maxLines: 1,
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Color(ColorValues.white),
                                                          fontSize: 18.0,
                                                          //fontFamily: StringValues.customRegular
                                                        ),
                                                    ),
                                                  ),

                                                ],
                                              ),*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _navigateToEditProfile,
                                      child: Card(
                                        margin:
                                            const EdgeInsets.only(top: 20.0),
                                        //, bottom: 90.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              width: 0.2,
                                              color:
                                              Color(ColorValues.unselected_tab_text_color)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 24.0),
                                          child: Text(
                                            '${StringValues.TEXT_edit_profile}',
                                            //textAlign: TextAlign.center,

                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.grey_light),
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      margin: const EdgeInsets.only(
                                          top: 20.0, left: 24.0, right: 24.0),
                                      //, bottom: 90.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              width: 0.5,
                                              color:
                                              Color(ColorValues.greyCardBorder)),
                                      ),
                                      elevation: 0,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    StringValues.personalInfo,
                                                    style: TextStyle(
                                                        color: Color(ColorValues
                                                            .primaryColor),
                                                        fontSize: 17.0),
                                                  ),
                                                  Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      primaryColor: Color(
                                                          ColorValues
                                                              .text_view_theme),
                                                    ),
                                                    child: SizedBox(
                                                      height: 65.0,
                                                      child: TextFormField(
                                                        controller:
                                                        emailController,
                                                        focusNode: _emailFocus,
                                                        maxLength: 35,
                                                        keyboardType:
                                                        TextInputType
                                                            .emailAddress,
                                                        textInputAction:
                                                        TextInputAction
                                                            .next,
                                                        enabled: false,
                                                        decoration:
                                                        InputDecoration(
                                                          counterText: '',
                                                          labelText:
                                                          StringValues
                                                              .TEXT_EMAIL,
                                                          hintText: StringValues
                                                              .TEXT_EMAIL,
                                                          focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                              BorderSide(
                                                                  color:
                                                                  Colors.grey)),

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      primaryColor: Color(
                                                          ColorValues
                                                              .text_view_theme),
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                          mobileNoController,
                                                      focusNode: _mobileNoFocus,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      maxLength: 13,
                                                      enabled: false,
                                                      inputFormatters: [
                                                        WhitelistingTextInputFormatter
                                                            .digitsOnly,
                                                        // Fit the validating format.
                                                        //_phoneNumberFormatter,
                                                      ],
                                                      //to block space character
                                                      textInputAction:
                                                          TextInputAction.next,

                                                      //autofocus: true,
                                                      decoration: InputDecoration(
                                                        counterText: '',
                                                        labelText: StringValues
                                                            .TEXT_MOBILE_NO,
                                                        hintText: StringValues
                                                            .TEXT_MOBILE_NO,
                                                        //border: InputBorder.none,
                                                        /*errorText:
                                                                submitFlag ? _validateEmail() : null,*/
                                                      ),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      primaryColor: Color(
                                                          ColorValues
                                                              .text_view_theme),
                                                    ),
                                                    child: SizedBox(
                                                      height: 65.0,
                                                      child: TextFormField(
                                                        controller:
                                                            businessName,
                                                        focusNode:
                                                            _businessNameFocus,
                                                        maxLength: 35,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        enabled: false,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          labelText: StringValues
                                                              .BusinesName,
                                                          hintText: StringValues
                                                              .BusinesName,
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey)),

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      primaryColor: Color(
                                                          ColorValues
                                                              .text_view_theme),
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                      businessTypeController,
                                                      focusNode: _businessTypeFocus,
                                                      maxLength: 100,
                                                      maxLines: null,
                                                      keyboardType:
                                                      TextInputType.text,
                                                      textInputAction:
                                                      TextInputAction.done,
                                                      textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                      enabled: false,
                                                      decoration:
                                                      InputDecoration(
                                                        helperText: ' ',
                                                        counterText: '',
                                                        labelText: StringValues
                                                            .BusinessType,
                                                        hintText: StringValues
                                                            .BusinessType,
                                                        focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey)),
                                                      ),

                                                    ),
                                                  ),

                                                  Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      primaryColor: Color(
                                                          ColorValues
                                                              .text_view_theme),
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                      businessRegistrationController,
                                                      focusNode: _businessRegistrationFocus,
                                                      maxLength: 100,
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        helperText: ' ',
                                                        counterText: '',
                                                        labelText: StringValues
                                                            .BusinessRegistrationNumber,
                                                        hintText: StringValues
                                                            .BusinessRegistrationNumber,
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                      ),

                                                    ),
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


  Future _navigateToEditProfile() async {
    final result=await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMyProfile(_data)),
    );
    if(result != null){
      //refreshPage
      print('back from edit request result:: $result');
      checkConnection();
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

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      _data = await getProfileData();
      if (_data != null) getScreenFields();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<UserProfileResourceData> getProfileData() async {
    setState(() {
      _isInProgress = true;
    });

    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };

    //http://3.7.49.123:8711/user/user/profile/{userid}/{roleid}
    String dataURL = Constants.BASE_URL + Constants.get_user_profile_info;
    dataURL = dataURL + "/$userId/${Constants.ROLE_ID}";

    print("get request detail URL::: $dataURL");
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      UserProfileData apiResponse =
          new UserProfileData.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          return apiResponse.resourceData;
        } else {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
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
    return _data;
  }

  void getScreenFields() {

    setState(() {
      if(_data.profileImageUrl != null && _data.profileImageUrl != '')
      _imageUrl = '${_data.profileImageUrl}';
      String mobileNo='';
      if(_data.countryCode != null && _data.countryCode != '')
        mobileNo='+${_data.countryCode} ';
      if(_data.mobile != null && _data.mobile != '')
        mobileNo='$mobileNo${MobileNumberInputFormatter().getFormatedMobileNo(_data.mobile)}';
      mobileNoController.text = mobileNo;//'+${_data.countryCode}${_data.mobile}';
      if(_data.name != null && _data.name != '')
        _PAName = '${_data.name}';

      if(_data.email != null && _data.email != '')
      emailController.text = '${_data.email}';

      if(_data.businessName != null && _data.businessName != '')
        businessName.text = '${_data.businessName}';

      if(_data.businessType != null && _data.businessType != '')
      businessTypeController.text = '${_data.businessType}';

      if(_data.businessRegistrationNumber != null && _data.businessRegistrationNumber != '')
      businessRegistrationController.text = '${_data.businessRegistrationNumber}';
    });
    print('image url::: $_imageUrl');
  }
}
