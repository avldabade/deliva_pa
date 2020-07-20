import 'dart:convert';
import 'dart:io';
import 'package:deliva_pa/detailPages/get_business_location_on_google_map.dart';
import 'package:deliva_pa/forgot_password/forgot_otp.dart';
import 'package:deliva_pa/home_screen/AddressObject.dart';
import 'package:deliva_pa/home_screen/dashboard.dart';
import 'package:deliva_pa/podo/api_response.dart';
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
import 'package:geocoder/geocoder.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';

class BusinessAddressPage extends StatefulWidget {
  String address='',state='',zipcode='',city='',aptNumber='',country="";
  bool apiCall;
  BusinessAddressPage(this.address,this.state,this.zipcode,this.city,this.aptNumber,this.country,this.apiCall);
  @override
  BusinessAddressPageState createState() =>
      BusinessAddressPageState();
}

class BusinessAddressPageState
    extends State<BusinessAddressPage> {




  bool _isInProgress = false;
  bool _isSubmitPressed = false;
  bool _autoValidate = false;
  bool isLocationError = false;
  final locationController = TextEditingController();
  final FocusNode locationFocus = FocusNode();
  String location=StringValues.Text_Location;

  bool isApartmentError = false;
  final apartmentController = TextEditingController();
  final FocusNode apartmentFocus = FocusNode();
  String apartmentNumber;

  bool isStateError = false;
  final stateController = TextEditingController();
  final FocusNode stateFocus = FocusNode();
  String state;

  bool isZipCodeError = false;
  final zipCodeController = TextEditingController();
  final FocusNode zipCodeFocus = FocusNode();
  String zipCode;

  bool isCountryError = false;
  final countryController = TextEditingController();
  final FocusNode countryFocus = FocusNode();
  String country;

  bool isCityError = false;
  final cityController = TextEditingController();
  final FocusNode cityFocus = FocusNode();
  String city;


  String statetext = "State";
  String stateBlank = '';

  List<String> stateList = [
   "State",
    "Andra Pradesh","Madhya Pradesh","Maharashtra","Gujrat",
  ];

  String cityText = "City";
  String cityBlank = '';

  List<String> cityList = [
    "City",
    "Hydrabad","Indore","Mumbai","Ahmdabad",
  ];

  String countryText = "Country";
  String countryBlank = '';

  List<String> countryList = [
    "Country",
    "India","USA","South Africa","Australia",
  ];


  bool hasError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationController.text=widget.address==""?"":widget.address;
    apartmentController.text=widget.aptNumber==""?"":widget.aptNumber;
    //statetext=widget.state==""?"State":widget.state;
    stateController.text=widget.state==""?"":widget.state;
    //cityText=widget.city==""?"City":widget.city;
    cityController.text=widget.city==""?"":widget.city;
    zipCodeController.text=widget.zipcode==""?"":widget.zipcode;
    //countryText=widget.country==""?"Country":widget.country;
    countryController.text=widget.country==""?"":widget.country;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));

    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[

                  Utils().commonAppBar(StringValues.Text_Business_Adress,context),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(24.0),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                       /* isLocationError && _autoValidate
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
                                            : Container(),*/
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: InkWell(
                                                onTap: () async {
                                                  //navigate to another screen
                                                  _navigateToMap();
                                                },
                                                child: TextFormField(
                                                  controller:
                                                  locationController,
                                                  enabled: false,
                                                  keyboardType:
                                                  TextInputType.text,

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
                                                              "assets/businessAddress/location.png"),
                                                        ),
                                                      ),
                                                    ),
                                                    //icon: Icon(Icons.lock_outline),
                                                   /* suffixIcon: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 0.0),
                                                      child: Transform.scale(
                                                        scale: 0.65,
                                                        child: IconButton(
                                                          onPressed: () {},
                                                          icon: Image.asset(
                                                              'assets/identificationIcon/drop.png'),
                                                        ),
                                                      ),
                                                    ),*/
                                                    counterText: '',
                                                    hintText:
                                                    StringValues.Text_Location,
                                                    focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                            color: Colors
                                                                .grey)),
                                                    /*errorText:
                                                                                  submitFlag ? _validateEmail() : null,*/
                                                  ),

                                                  /*validator: (String arg) {
                                                    String val = Validation
                                                        .validateLocation(arg);
                                                    //setState(() {
                                                    if (val != null)
                                                      isLocationError = true;
                                                    else
                                                      isLocationError = false;
                                                    //});
                                                    return val;
                                                  },*/

                                                  onSaved: (value) {
                                                    location = value;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      //mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            print(
                                                "geo clicked");
                                            _navigateToMap();
                                          },
                                          child: Container(
                                            color: Colors
                                                .transparent,
                                            child: Row(
                                              children: <
                                                  Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top:
                                                      10.0,
                                                      bottom:
                                                      10.0),
                                                  child: Text(
                                                    location ==
                                                        ""
                                                        ? StringValues.Text_Location
                                                        : location,
                                                    style:
                                                    TextStyle(
                                                      color: Color(
                                                          ColorValues.text_view_hint),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  bottom:
                                                  10.0),
                                              child:
                                              new Container(
                                                height: 1.0,
                                                color: isLocationError
                                                    ? Color(ColorValues
                                                    .error_red)
                                                    : Colors
                                                    .grey,
                                              ),
                                            ),
                                            Visibility(
                                              child: Align(
                                                alignment:
                                                Alignment
                                                    .centerLeft,
                                                child:
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top:
                                                      5.0),
                                                  child: Text(
                                                    StringValues
                                                        .source_error,
                                                    style: TextStyle(
                                                        color: Color(ColorValues
                                                            .error_red),
                                                        fontSize:
                                                        12.0),
                                                  ),
                                                ),
                                              ),
                                              visible:
                                              isLocationError,
                                            ),
                                            isLocationError && _autoValidate
                                                ? Positioned(
                                              right:
                                              0.0,
                                              bottom:
                                              0.0,
                                              //alignment: Alignment.bottomRight,
                                              child:
                                              Image(
                                                image: new AssetImage(
                                                    'assets/images/error_icon_red.png'),
                                                width: 17.0,
                                                height: 17.0,
                                                //fit: BoxFit.fitHeight,
                                              ),
                                            )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),*/
                                    Stack(
                                      children: <Widget>[
                                        isApartmentError && _autoValidate
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                apartmentController,

                                                keyboardType:
                                                TextInputType.text,

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
                                                            "assets/businessAddress/apartment.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Apartment,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateAppartment(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isApartmentError = true;
                                                  else
                                                    isApartmentError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateAppartment(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isApartmentError = true;
                                                  else
                                                    isApartmentError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  apartmentNumber = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        isZipCodeError && _autoValidate
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                zipCodeController,

                                                keyboardType:
                                                TextInputType.number,
                                                maxLength: 6,
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
                                                            "assets/businessAddress/pincode.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Zip_Code,

                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateZipCode(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isZipCodeError = true;
                                                  else
                                                    isZipCodeError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateZipCode(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isZipCodeError = true;
                                                  else
                                                    isZipCodeError = false;
                                                  //});
                                                  setState(() {

                                                  });
                                                },

                                                onSaved: (value) {
                                                  zipCode = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        isCityError && _autoValidate
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                cityController,

                                                keyboardType:
                                                TextInputType.text,

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
                                                            "assets/businessAddress/city.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_City,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateCity(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isCityError = true;
                                                  else
                                                    isCityError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateCity(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isCityError = true;
                                                  else
                                                    isCityError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  city = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        isStateError && _autoValidate
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                stateController,

                                                keyboardType:
                                                TextInputType.text,

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
                                                            "assets/businessAddress/state.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_State,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateState(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isStateError = true;
                                                  else
                                                    isStateError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateState(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isStateError = true;
                                                  else
                                                    isStateError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  stateBlank = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Stack(
                                      children: <Widget>[
                                        isCountryError && _autoValidate
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller: countryController,

                                                keyboardType:
                                                TextInputType.text,
                                                //maxLength: 6,
                                                /*inputFormatters: [
                                                  BlacklistingTextInputFormatter(
                                                      new RegExp('[\\ ]'))
                                                ],*/
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
                                                            "assets/businessAddress/country.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Country,

                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateCountry(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isCountryError = true;
                                                  else
                                                    isCountryError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateCountry(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isCountryError = true;
                                                  else
                                                    isCountryError = false;
                                                  //});
                                                  setState(() {

                                                  });
                                                },

                                                onSaved: (value) {
                                                  country = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(height:35.0),

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
                                                          .accentColor))),
                                          onPressed: () {
                                            print("button click....");
                                            validateDetail();
                                          },
                                          color: Color(ColorValues
                                              .accentColor),
                                          textColor: Colors.white,
                                          child: Padding(
                                            padding:


                                            const EdgeInsets
                                                .all(10.0),
                                            child: Text(
                                                widget.apiCall?"SAVE":   StringValues
                                                    .TEXT_SUBMIT
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 20)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
  void _validateInputs() {
    //if (_formKey.currentState.validate()&& statetext!="" && cityBlank!="" && countryBlank!="") {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);

        print("validate details");
     widget.apiCall? updateBusinessAddressApiCall():saveBusinessAdressApiCall();

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
         /*this.isStateError=true;
         this.isCityError=true;
         this.isCountryError=true;*/
        _autoValidate = true;
      });
      _isSubmitPressed = false;
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }
  Future validateDetail() async {
    if (!_isSubmitPressed) {
      try {
        print("press");
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
  void saveBusinessAdressApiCall() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    print("call api");
    setState(() {
      _isInProgress = true;
    });
    int userId=await SharedPreferencesHelper.getPrefInt(SharedPreferencesHelper.USER_ID);
    print(userId);

    Map<String, dynamic> requestJson = {
      "address": locationController.text ,
      "aptNumber": apartmentController.text,
      //"country": countryText,
      "country": countryController.text,
      //"state": statetext,
      "state": stateController.text,
      //"city": cityText,
      "city": cityController.text,
      "userId": userId,
      "zipcode": zipCodeController.text
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
        Constants.BASE_URL + Constants.Processing_Agent_SaveAdress;
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
          print("Submit Sucesfull!!!");
          Navigator.pop(context,'refresh');
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (jsonResponseMap.containsKey("error")){
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
  void updateBusinessAddressApiCall() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    print("call api");
    setState(() {
      _isInProgress = true;
    });
    int userId=await SharedPreferencesHelper.getPrefInt(SharedPreferencesHelper.USER_ID);
    print(userId);

    Map<String, dynamic> requestJson = {
      "address": locationController.text ,
      "aptNumber": apartmentController.text,
      //"country": countryText,
      "country": countryController.text,
      //"state": statetext,
      "state": stateController.text,
      //"city": cityText,
      "city": cityController.text,
      "userId": userId,
      "zipcode": zipCodeController.text
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
        Constants.BASE_URL + Constants.Processing_Agent_UPDATEAdress;
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
      print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

      if (response.statusCode == 200) {
        print("statusCode 200....");
        if (apiResponse.resourceData == null && apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("Submit Sucesfull!!!");
          Navigator.pop(context,'refresh');
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (jsonResponseMap.containsKey("error")){
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

  Future _navigateToMap() async {
    //print('inside _navigateToMap');
    Coordinates currentCoordinates = await Utils().getUserLatLong();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetBusinessLocationOnMap(currentCoordinates)),
    );
    if (result != null) {
      //refreshPage
      //print('back from PackageDetails result:: $result');
      AddressObject addressObject = result;

      final coordinates = new Coordinates(addressObject.updatedPositionOfMarker.latitude, addressObject.updatedPositionOfMarker.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      /*print('first.adminArea::: ${first.adminArea}');// State
      print('first.subAdminArea::: ${first.subAdminArea}');// district
      print('first.featureName::: ${first.featureName}'); // house no
      print('first.countryName::: ${first.countryName}'); // country name
      print('first.locality::: ${first.locality}');//city name
      print('first.postalCode::: ${first.postalCode}');//pin zip code
      print('first.countryCode::: ${first.countryCode}');// country code
      print('first.coordinates::: ${first.coordinates}');//lat lang {22.2524299,76.03384559999999}
      print('first.subLocality::: ${first.subLocality}');//null
      print('first.addressLine::: ${first.addressLine}');// full address (k56, Kanwar Colony, Barwaha, Madhya Pradesh 451115, India)
      print('first.subThoroughfare::: ${first.subThoroughfare}');//null
      print('first.thoroughfare::: ${first.thoroughfare}');//null*/

      setState(() {
        locationController.text = '${addressObject.updatedPositionOfMarker.latitude.toStringAsFixed(4)}${StringValues.degreeN}, ${addressObject.updatedPositionOfMarker.longitude.toStringAsFixed(4)}${StringValues.degreeE}';
        apartmentController.text = first.addressLine;
        zipCodeController.text = first.postalCode;
        cityController.text = first.locality;
        stateController.text = first.adminArea;
        countryController.text = first.countryName;
      });

    }
  }

}
