import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:deliva/constants/Constant.dart';
import 'package:deliva/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva/delivery_request/aws_policy_helper.dart';
import 'package:deliva/delivery_request/location_selector.dart';
import 'package:deliva/podo/api_response.dart';
import 'package:deliva/podo/delivery_request_response.dart';
import 'package:deliva/podo/pa_location_response.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/image_picker_class.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

//import 'package:aws_client/aws_client.dart';
import 'package:toast/toast.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

class DeliveryRequest extends StatefulWidget {
  @override
  _DeliveryRequestState createState() => _DeliveryRequestState();
}

class _DeliveryRequestState extends State<DeliveryRequest> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final weightController = TextEditingController();
  final FocusNode _weightFocus = FocusNode();

  final sourceController = TextEditingController();
  final FocusNode _sourceFocus = FocusNode();
  String _source;

  final destinationController = TextEditingController();
  final FocusNode _destinationFocus = FocusNode();
  String _destination;

  final valueController = TextEditingController();
  final FocusNode _valueFocus = FocusNode();

  final heightController = TextEditingController();
  final FocusNode _heightFocus = FocusNode();

  final titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  String _title;
  final descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  String _description;
  final lengthController = TextEditingController();
  final FocusNode _lengthFocus = FocusNode();

  final widthController = TextEditingController();
  final FocusNode _widthFocus = FocusNode();

  bool _checkedLocFixedValue = true;
  bool _checkedInsValue = true;
  bool _checkedTCValue = true;

  String _weight="", _value="";
  String _width="", _height="";
  String _length="";

  File _imagePath;

  bool isPublished;

  String _addressS = "", _addressD = "";

  DateTime selectedDate = DateTime.now();
  DateTime _readyDate; // = DateTime.now(); //var _readyDate, _deliveryDate;
  DateTime _deliveryDate; // = DateTime.now();
  static const platform = const MethodChannel('samples.flutter.io/battery');

  int userId;

  String strAzureImageUploadPath;
  List<File> imageList = new List();
  List<String> imageUrlList = new List();

  String dimenUnit = StringValues.cm;

  Color inchBgColor;

  Color inchTextColor;

  Color cmBgColor;
  Color cmTextColor;

  //LIst for weightUnit dropdown
  List<String> wUnitList = [
    "LBS",
    "KG",
    "GRAM",
  ];
  String weightUnit = 'LBS';

  bool hasSourceError = false, hasDestinationError = false;

  bool hasDeliveryDateError = false, hasReadyDateError = false;

  bool hasSourceData = false;
  bool hasDestinationData = false;
  PAResourceData sourceData;
  PAResourceData destinationData;

  int sourcePAID;
  int destionationPAID;

  int deliveryRequestId = 0;

  String access_token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Utils().getUserLocationNew();
    //getDimenUnit();
    inchBgColor = Color(ColorValues.primaryColor);
    inchTextColor = Color(ColorValues.white);
    cmBgColor = Color(ColorValues.white);
    cmTextColor = Color(ColorValues.primaryColor);
    getAsyncData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    weightController.dispose();
    sourceController.dispose();
    destinationController.dispose();
    valueController.dispose();
    heightController.dispose();
    widthController.dispose();
    lengthController.dispose();
    descriptionController.dispose();
    _titleFocus.dispose();
    _weightFocus.dispose();
    _sourceFocus.dispose();
    _descriptionFocus.dispose();
    _destinationFocus.dispose();
    _valueFocus.dispose();
    _lengthFocus.dispose();
    _widthFocus.dispose();
    _heightFocus.dispose();
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
                              StringValues.TEXT_DELIVA_REQUEST.toUpperCase(),
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
                              //Navigator.pop(context);
                            },
                          ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  /*Image(
                                    image: new AssetImage(
                                        'assets/images/profile_img_girl.png'),
                                    width: 175.0,
                                    height: 124.0,
                                    fit: BoxFit.cover,
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 24.0),
                                    child: Text(
                                      StringValues.packageDetailText,
                                      style: TextStyle(
                                        color: Color(
                                            ColorValues.grey_light_header),
                                        fontSize: 16.0,
                                        fontFamily: StringValues.customLight,
                                      ),
                                    ),
                                  ),
                                  !hasSourceData && !hasDestinationData
                                      ? IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Image(
                                                image: new AssetImage(
                                                    'assets/images/source_destination_img.png'),
                                                width: 23.0,
                                                //height: 124.0,
                                                //fit: BoxFit.fitHeight,
                                              ),
                                              /* Padding(
                                            padding:
                                            EdgeInsets.only(
                                                left: 16.0)),*/
                                              Flexible(
                                                child: Container(
                                                  //color: Colors.red,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Column(
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
                                                                "Source clicked");
                                                            _navigateToLocationPickerS(
                                                                StringValues
                                                                    .pickupLocation,
                                                                StringValues
                                                                    .selectPALocation);
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
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10.0),
                                                                  child: Text(
                                                                    _addressS ==
                                                                            ""
                                                                        ? StringValues
                                                                            .Source
                                                                        : _addressS,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          ColorValues
                                                                              .text_view_hint),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          child: Text(
                                                            "Select Source",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          visible:
                                                              hasSourceError,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0.0),
                                                          child: new Container(
                                                            height: 1.0,
                                                            color: Colors.grey,
                                                            //width: MediaQuery.of(context).size.width - 75,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                "Destination clicked");
                                                            _navigateToLocationPickerD(
                                                                StringValues
                                                                    .deliveryLocation,
                                                                StringValues
                                                                    .selectPALocation);
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
                                                                      top: 20.0,
                                                                      bottom:
                                                                          10.0),
                                                                  child: Text(
                                                                    _addressD ==
                                                                            ""
                                                                        ? StringValues
                                                                            .destination
                                                                        : _addressD,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          ColorValues
                                                                              .text_view_hint),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          child: Text(
                                                            "Select Destination",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          visible:
                                                              hasDestinationError,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0.0),
                                                          child: new Container(
                                                            height: 1.0,
                                                            color: Colors.grey,
                                                            //width: MediaQuery.of(context).size.width - 75,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            hasSourceData
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        StringValues
                                                            .pickupLocationS,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Color(
                                                              ColorValues
                                                                  .black),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Source clicked");
                                                          _navigateToLocationPickerS(
                                                              StringValues
                                                                  .pickupLocation,
                                                              StringValues
                                                                  .selectPALocation);
                                                        },
                                                        child: Card(
                                                          elevation: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Positioned(
                                                                  top: 0.0,
                                                                  right: 0.0,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            0.0),
                                                                    child: Text(
                                                                      '0.4 Mile',
                                                                      style: TextStyle(
                                                                          color: Color(ColorValues
                                                                              .accentColor),
                                                                          fontSize:
                                                                              16.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        sourceData
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5.0),
                                                                        child:
                                                                            Text(
                                                                          sourceData
                                                                              .email,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Color(ColorValues.grey_light),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 12.0),
                                                                        child:
                                                                            Text(
                                                                          'Address: ${sourceData.city}, ${sourceData.country}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Color(ColorValues.grey_light_header),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            16.0,
                                                                      ),
                                                                      Container(
                                                                        //width: 127.0,
                                                                        //height: 30.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              new BorderRadius.circular(5.0),
                                                                          //color: Color(ColorValues.grey_hint_color),
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(ColorValues.primaryColor),
                                                                            width:
                                                                                1,
                                                                            style:
                                                                                BorderStyle.solid,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Image(
                                                                                image: new AssetImage('assets/images/direction_icon.png'),
                                                                                width: 15.0,
                                                                                height: 15.0,
                                                                                //fit: BoxFit.fitHeight,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Get Directions".toUpperCase(), style: TextStyle(fontSize: 13, color: Color(ColorValues.black))),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/source.png'),
                                                        width: 24.0,
                                                        height: 24.0,
                                                        //fit: BoxFit.fitHeight,
                                                      ),
                                                      Container(
                                                        width: 12.0,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Source clicked");
                                                                _navigateToLocationPickerS(
                                                                    StringValues
                                                                        .pickupLocation,
                                                                    StringValues
                                                                        .selectPALocation);
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
                                                                              20.0,
                                                                          bottom:
                                                                              20.0),
                                                                      child:
                                                                          Text(
                                                                        _addressS ==
                                                                                ""
                                                                            ? StringValues.Source
                                                                            : _addressS,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(ColorValues.text_view_hint),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              child: Text(
                                                                "Select Source",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              visible:
                                                                  hasSourceError,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          0.0),
                                                              child:
                                                                  new Container(
                                                                height: 1.0,
                                                                color:
                                                                    Colors.grey,
                                                                //width: MediaQuery.of(context).size.width - 75,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            hasDestinationData
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 16.0,
                                                      ),
                                                      Text(
                                                        StringValues
                                                            .deliveryLocationS,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Color(
                                                              ColorValues
                                                                  .black),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Destination clicked");
                                                          _navigateToLocationPickerD(
                                                              StringValues
                                                                  .deliveryLocation,
                                                              StringValues
                                                                  .selectPALocation);
                                                        },
                                                        child: Card(
                                                          elevation: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Positioned(
                                                                  top: 0.0,
                                                                  right: 0.0,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            0.0),
                                                                    child: Text(
                                                                      '0.4 Mile',
                                                                      style: TextStyle(
                                                                          color: Color(ColorValues
                                                                              .accentColor),
                                                                          fontSize:
                                                                              16.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        destinationData
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5.0),
                                                                        child:
                                                                            Text(
                                                                          destinationData
                                                                              .email,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Color(ColorValues.grey_light),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 12.0),
                                                                        child:
                                                                            Text(
                                                                          'Address: ${destinationData.city}, ${destinationData.country}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Color(ColorValues.grey_light_header),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            16.0,
                                                                      ),
                                                                      Container(
                                                                        //width: 127.0,
                                                                        //height: 30.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              new BorderRadius.circular(5.0),
                                                                          //color: Color(ColorValues.grey_hint_color),
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(ColorValues.primaryColor),
                                                                            width:
                                                                                1,
                                                                            style:
                                                                                BorderStyle.solid,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Image(
                                                                                image: new AssetImage('assets/images/direction_icon.png'),
                                                                                width: 15.0,
                                                                                height: 15.0,
                                                                                //fit: BoxFit.fitHeight,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text("Get Directions".toUpperCase(), style: TextStyle(fontSize: 13, color: Color(ColorValues.black))),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      Image(
                                                        image: new AssetImage(
                                                            'assets/images/destination.png'),
                                                        width: 24.0,
                                                        height: 24.0,
                                                        //fit: BoxFit.fitHeight,
                                                      ),
                                                      Container(
                                                        width: 12.0,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Destination clicked");
                                                                _navigateToLocationPickerD(
                                                                    StringValues
                                                                        .deliveryLocation,
                                                                    StringValues
                                                                        .selectPALocation);
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
                                                                              20.0,
                                                                          bottom:
                                                                              20.0),
                                                                      child:
                                                                          Text(
                                                                        _addressD ==
                                                                                ""
                                                                            ? StringValues.destination
                                                                            : _addressD,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(ColorValues.text_view_hint),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              child: Text(
                                                                "Select Destination",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              visible:
                                                                  hasDestinationError,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          0.0),
                                                              child:
                                                                  new Container(
                                                                height: 1.0,
                                                                color:
                                                                    Colors.grey,
                                                                //width: MediaQuery.of(context).size.width - 75,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                  Container(
                                    height: 32.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*  Checkbox(

                                        //checkColor: Color(ColorValues.sea_green_blue_light),
                                        //tristate: true,
                                        //activeColor: Color(ColorValues.white),
                                        value: _checkedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _checkedValue =
                                                value;
                                          });
                                        },
                                      ),*/
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _checkedLocFixedValue =
                                                !_checkedLocFixedValue;
                                          });
                                        },
                                        child: Image(
                                          image: _checkedLocFixedValue
                                              ? new AssetImage(
                                                  'assets/images/select_checkbox.png')
                                              : new AssetImage(
                                                  'assets/images/unselect_checkbox.png'),
                                          width: 24.0,
                                          height: 24.0,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            StringValues.pickupLocFixed,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.blueTheme),
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                  ),
                                  TextFormField(
                                    controller: titleController,
                                    focusNode: _titleFocus,
                                    keyboardType: TextInputType.text,
                                    //enabled: false,
                                    //to block space character
                                    textInputAction: TextInputAction.next,
                                    //autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: StringValues.title,
                                      hintText: StringValues.title,
                                      border: InputBorder.none,
                                    ),
                                    validator: Validation.validateTextField,
                                    onSaved: (value) {
                                      _title = value;
                                    },
                                    onFieldSubmitted: (_) {
                                      Utils.fieldFocusChange(
                                          context, _titleFocus, _lengthFocus);
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                print("inch clicked");
                                                getDimenUnit();
                                              },
                                              child: Container(
                                                width: 100.0,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20.0)),
                                                  color: inchBgColor,
                                                  //Color(ColorValues.grey_hint_color),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: Color(ColorValues
                                                        .primaryColor),
                                                    width: 1,
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    StringValues.inch,
                                                    style: TextStyle(
                                                      color:
                                                          inchTextColor, //Color(ColorValues.primaryColor)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print("CM clicked");
                                                getDimenUnit();
                                              },
                                              child: Container(
                                                width: 100.0,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20.0)),
                                                  color: cmBgColor,
                                                  //Color(ColorValues.primaryColor),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: Color(ColorValues
                                                        .primaryColor),
                                                    width: 1,
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    StringValues.cm,
                                                    style: TextStyle(
                                                      color:
                                                          cmTextColor, //Color(ColorValues.white)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image(
                                                    image: new AssetImage(
                                                        'assets/images/length.png'),
                                                    width: 20.0,
                                                    height: 20.0,
                                                    //fit: BoxFit.fitHeight,
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          lengthController,
                                                      focusNode: _lengthFocus,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //to block space character
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            StringValues.length,
                                                        hintText:
                                                            StringValues.length,
                                                        border:
                                                            InputBorder.none,
                                                        //errorText: submitFlag ? _validateEmail() : null,
                                                      ),
                                                      onFieldSubmitted: (_) {
                                                        Utils.fieldFocusChange(
                                                            context,
                                                            _lengthFocus,
                                                            _widthFocus);
                                                      },
                                                      validator: Validation
                                                          .validateTextField,
                                                      /*(value){
                                                        print('field name:: ${StringValues.length} value:: $value');
                                                        Validation.validateTextField(StringValues.length,value);
                                                      },*/

                                                      onSaved: (value) {
                                                        _length = value;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: new Container(
                                                  height: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Image(
                                                    image: new AssetImage(
                                                        'assets/images/width.png'),
                                                    width: 20.0,
                                                    height: 20.0,
                                                    //fit: BoxFit.fitHeight,
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          widthController,
                                                      focusNode: _widthFocus,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //to block space character
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            StringValues.width,
                                                        hintText:
                                                            StringValues.width,
                                                        border:
                                                            InputBorder.none,
                                                        //errorText: submitFlag ? _validateEmail() : null,
                                                      ),
                                                      onFieldSubmitted: (_) {
                                                        Utils.fieldFocusChange(
                                                            context,
                                                            _widthFocus,
                                                            _heightFocus);
                                                      },
                                                      validator: Validation
                                                          .validateTextField,
                                                      onSaved: (value) {
                                                        _width = value;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: new Container(
                                                  height: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Image(
                                                    image: new AssetImage(
                                                        'assets/images/height.png'),
                                                    width: 20.0,
                                                    height: 20.0,
                                                    //fit: BoxFit.fitHeight,
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          heightController,
                                                      focusNode: _heightFocus,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //to block space character
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            StringValues.height,
                                                        hintText:
                                                            StringValues.height,
                                                        border:
                                                            InputBorder.none,
                                                        //errorText: submitFlag ? _validateEmail() : null,
                                                      ),
                                                      onFieldSubmitted: (_) {
                                                        Utils.fieldFocusChange(
                                                            context,
                                                            _heightFocus,
                                                            _weightFocus);
                                                      },
                                                      validator: Validation
                                                          .validateTextField,
                                                      onSaved: (value) {
                                                        _height = value;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: new Container(
                                                  height: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            'assets/images/weight.png'),
                                        width: 20.0,
                                        height: 20.0,
                                        //fit: BoxFit.fitHeight,
                                      ),
                                      Container(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: weightController,
                                          focusNode: _weightFocus,
                                          keyboardType: TextInputType.number,
                                          //to block space character
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText: StringValues.weight,
                                            hintText: StringValues.weight,
                                            border: InputBorder.none,
                                            //errorText: submitFlag ? _validateEmail() : null,
                                          ),
                                          onFieldSubmitted: (_) {
                                            Utils.fieldFocusChange(context,
                                                _weightFocus, _valueFocus);
                                          },
                                          validator:
                                              Validation.validateTextField,
                                          onSaved: (value) {
                                            _weight = value;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 60.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          //color: Color(ColorValues.grey_hint_color),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Color(
                                                ColorValues.grey_hint_color),
                                            width: 1,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: DropdownButton<String>(
                                              value: weightUnit,
                                              icon: Image(
                                                image: new AssetImage(
                                                    'assets/images/down_arrow.png'),
                                                width: 7.0,
                                                height: 7.0,
                                                //fit: BoxFit.fitHeight,
                                              ),
                                              //Icon(Icons.arrow_drop_down),
                                              //iconSize: 24,
                                              elevation: 16,

                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal),
                                              /*underline: Container(
                                                  height: 2,
                                                  color: Colors.deepPurpleAccent,
                                                ),*/
                                              onChanged: (String data) {
                                                setState(() {
                                                  weightUnit = data;
                                                });
                                              },
                                              items: wUnitList.map<
                                                  DropdownMenuItem<
                                                      String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Image(
                                        image: new AssetImage(
                                            'assets/images/value.png'),
                                        width: 20.0,
                                        height: 20.0,
                                        //fit: BoxFit.fitHeight,
                                      ),
                                      Container(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          textCapitalization:
                                              TextCapitalization.words,
                                          controller: valueController,
                                          focusNode: _valueFocus,
                                          keyboardType: TextInputType.number,
                                          /*inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                // Fit the validating format.
                              ],*/
                                          //to block space character
                                          textInputAction: TextInputAction.next,

                                          //autofocus: true,
                                          decoration: InputDecoration(
                                            labelText: StringValues.value,
                                            hintText: StringValues.value,
                                            border: InputBorder.none,
                                            /*errorText:
                                                                    submitFlag ? _validateEmail() : null,*/
                                          ),
                                          onFieldSubmitted: (_) {
                                            Utils.fieldFocusChange(context,
                                                _valueFocus, _descriptionFocus);
                                          },
                                          /*validator:
                                              Validation.validateTextField,*/
                                          onSaved: (value) {
                                            _value = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      /*  Checkbox(

                                        //checkColor: Color(ColorValues.sea_green_blue_light),
                                        //tristate: true,
                                        //activeColor: Color(ColorValues.white),
                                        value: _checkedLocFixedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _checkedLocFixedValue =
                                                value;
                                          });
                                        },
                                      ),*/
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _checkedInsValue =
                                                !_checkedInsValue;
                                          });
                                        },
                                        child: Image(
                                          image: _checkedInsValue
                                              ? new AssetImage(
                                                  'assets/images/select_checkbox.png')
                                              : new AssetImage(
                                                  'assets/images/unselect_checkbox.png'),
                                          width: 24.0,
                                          height: 24.0,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            StringValues.insurance,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.blueTheme),
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 16.0,
                                  ),

                                  GestureDetector(
                                    onTap: () async {
                                      print("ready date clicked");
                                      _readyDate = await _selectDate(
                                          context, StringValues.readyDate);
                                      setState(() {});
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                'assets/images/date_picker_icon.png'),
                                            width: 20.0,
                                            height: 20.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                          Container(
                                            width: 8.0,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                child: Text(
                                                  _readyDate == null
                                                      ? StringValues.readyDate
                                                      : "${_readyDate.toLocal()}"
                                                          .split(' ')[0],
                                                  style: TextStyle(
                                                    color: Color(ColorValues
                                                        .text_view_hint),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    child: Text(
                                      "Select Ready Date",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    visible: hasReadyDateError,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      //width: MediaQuery.of(context).size.width - 75,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print("deliver date clicked");
                                      _deliveryDate = await _selectDate(
                                          context, StringValues.deliverDate);
                                      setState(() {});
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                'assets/images/date_picker_icon.png'),
                                            width: 20.0,
                                            height: 20.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                          Container(
                                            width: 8.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 20.0),
                                            child: Text(
                                              _deliveryDate == null
                                                  ? StringValues.deliverDate
                                                  : "${_deliveryDate.toLocal()}"
                                                      .split(' ')[0],
                                              style: TextStyle(
                                                color: Color(
                                                    ColorValues.text_view_hint),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    child: Text(
                                      "Select Delivery Date",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    visible: hasDeliveryDateError,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      //width: MediaQuery.of(context).size.width - 75,
                                    ),
                                  ),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: descriptionController,
                                    focusNode: _descriptionFocus,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    /*inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                // Fit the validating format.
                              ],*/
                                    //to block space character
                                    textInputAction: TextInputAction.next,

                                    //autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: StringValues.description,
                                      hintText: StringValues.description,
                                      border: InputBorder.none,
                                      /*errorText:
                                                              submitFlag ? _validateEmail() : null,*/
                                    ),
                                    /*onFieldSubmitted: (_) {
                                      Utils.fieldFocusChange(
                                          context, _valueFocus, _emailFocus);
                                    },*/
                                    validator: Validation.validateTextField,
                                    onSaved: (value) {
                                      _description = value;
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: new Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          /* _imagePath = await ImagePickerUtility.getImageFromGallery();
                                          setState(() {
                                            _imagePath=_imagePath;
                                          });*/
                                          if (imageList.length < 5)
                                            getAlertDialog(context);
                                          else
                                            Toast.show(
                                                "${StringValues.maxImageLimit}",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                        },
                                        child: Image(
                                          image: new AssetImage(
                                              'assets/images/add_img.png'),
                                          width: 95.0,
                                          height: 95.0,
                                          //fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 8.0,
                                      ),
                                      /*_imagePath == null
                                          ? Text('No image selected.')
                                          : Image.file(
                                              _imagePath,
                                              width: 95.0,
                                              height: 95.0,
                                            ),*/
                                      Expanded(
                                        child: new Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          height: 95.0,
                                          child: imageList != null
                                              ? ListView.builder(
                                                  //physics: NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: imageList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return getRecord(index,
                                                        imageList[index]);
                                                  },
                                                )
                                              : Container(),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 15.0,
                                  ),
                                  /*  imageList != null
                                      ? ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: imageList.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Container(
                                              height: 50,
                                              margin: EdgeInsets.all(2),
                                              color: index % 2 == 0
                                                  ? Colors.blue[400]
                                                  : Colors.grey,
                                              child: Center(
                                                  child: Text(
                                                '$index:: ${imageList[index]}',
                                                style:
                                                    TextStyle(fontSize: 12),
                                              )),
                                            );
                                          })
                                      : Container(),
                                  Container(
                                    height: 15.0,
                                  ),*/

                                  Container(
                                    height: 15.0,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      /*  Checkbox(

                                        //checkColor: Color(ColorValues.sea_green_blue_light),
                                        //tristate: true,
                                        //activeColor: Color(ColorValues.white),
                                        value: _checkedLocFixedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _checkedLocFixedValue =
                                                value;
                                          });
                                        },
                                      ),*/
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _checkedTCValue = !_checkedTCValue;
                                          });
                                        },
                                        child: Image(
                                          image: _checkedTCValue
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
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            StringValues.agree_t_n_c,
                                            style: TextStyle(
                                                color: Color(
                                                    ColorValues.text_view_hint),
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 30.0, top: 15.0)),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      /*SizedBox(
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
                                      ),*/
                                      GestureDetector(
                                        onTap: () {
                                          //validateMyProfile();
                                          //getAlertDialog(context);
                                          print('save clicked');
                                          isPublished = false;
                                          validateDeliveryRequest();
                                        },
                                        child: Container(
                                          width: 130.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            //color: Color(ColorValues.primaryColor),
                                            //Color(ColorValues.primaryColor),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: Color(
                                                  ColorValues.black_light),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Center(
                                              child: Text(
                                                StringValues.TEXT_SAVE
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(
                                                      ColorValues.black_light),
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
                                          isPublished = true;
                                          validateDeliveryRequest();
                                        },
                                        child: Container(
                                          width: 130.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color:
                                                Color(ColorValues.primaryColor),
                                            //Color(ColorValues.primaryColor),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: Color(
                                                  ColorValues.primaryColor),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Center(
                                              child: Text(
                                                StringValues.save_publish
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*SizedBox(
                                        width: 130.0,
                                        height: 45.0,
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                              side: BorderSide(
                                                  color: Color(ColorValues
                                                      .yellow_light))),
                                          onPressed: () {
                                            //validateMyProfile();
                                            //getAlertDialog(context);

                                            isPublished = true;
                                            validateDeliveryRequest();
                                          },
                                          color:
                                              Color(ColorValues.yellow_light),
                                          textColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text(
                                                StringValues.save_publish
                                                    .toUpperCase(),
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ),
                                      ),*/
                                    ],
                                  ),
                                  //getSpinnerDialog(),
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
    );
  }

  Future _navigateToLocationPickerS(String title, String locationMsg) async {
    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationSelector(title, locationMsg)),
    );
    print('resultData::: $resultData');
    if (resultData != null) {
      setState(() {
        PAResourceData data = resultData as PAResourceData;
        hasSourceError = false;
        print('Source resultData::: ${data.city}');
        sourcePAID = data.userId;
        hasSourceData = true;
        sourceData = data;
        _addressS = data.city;
      });
    }
  }

  Future _navigateToLocationPickerD(String title, String locationMsg) async {
    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationSelector(title, locationMsg)),
    );
    print('resultData::: $resultData');
    if (resultData != null) {
      setState(() {
        PAResourceData data = resultData as PAResourceData;
        hasDestinationError = false;
        print('Destination resultData::: ${data.city}');
        destionationPAID = data.userId;
        hasDestinationData = true;
        destinationData = data;
        _addressD = data.city;
      });
    }
  }

  Widget getAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                //Container(child: _imagePath!= null? _imagePath:null),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Take a picture"),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera),
                        SizedBox(width: 5),
                        Text('Gallery'),
                      ],
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      _imagePath =
                          await ImagePickerUtility.getImageFromGallery();
                      if (imageList == null) imageList = new List();

                      if (_imagePath != null) {
                        setState(() {
                          imageList.add(_imagePath);
                        });
                      }

                      print('imageList size:: ${imageList.length}');
                    }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(width: 5),
                        Text('Camera'),
                      ],
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      _imagePath =
                          await ImagePickerUtility.getImageFromCamera();
                      if (imageList == null) imageList = new List();
                      if (_imagePath != null) {
                        setState(() {
                          imageList.add(_imagePath);
                        });
                      }
                      print('imageList size:: ${imageList.length}');
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  callDeliveryRequestApi() async {
    print("callDeliveryRequestApi::::: ");
    //if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });

    Map<String, dynamic> requestJson = {
      "agree": _checkedTCValue,
      "customerId": userId,
      "deliveryBeforeDate": "${_deliveryDate.toLocal()}".split(' ')[0],
      // "2020-04-14T11:37:48.501Z",
      "description": _description,
      "destinationPaId": destionationPAID,
      "dmUnit": dimenUnit,
      //"string",
      "height": double.parse(_height),
      "insured": _checkedInsValue,
      "isPublished": isPublished,
      "length": double.parse(_length),
      "pkgCost": double.parse(_value),
      "readyForPickupDate": "${_readyDate.toLocal()}".split(' ')[0],
      // "2020-04-14T11:37:48.501Z",
      "sourceLocFixed": _checkedLocFixedValue,
      "sourcePaId": sourcePAID,
      "title": _title,
      "userId": userId,
      "weight": double.parse(_weight),
      "width": double.parse(_width),
      "wtUnit": weightUnit
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.CREATE_DELIVERY_REQ_API;
    //dataURL = dataURL + "/India";
    print('requestJson::: ${requestJson}');
    print("PA location URL::: $dataURL");
    try {
      http.Response response = await http.post(dataURL,
          headers: headers, body: json.encode(requestJson));
      //headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        /*setState(() {
          _isInProgress = false;
        });*/
        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        DeliveryRequestResponse apiResponse =
            new DeliveryRequestResponse.fromJson(jsonResponseMap);
        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          //paLocaionList=apiResponse.resourceData;
          SharedPreferencesHelper.setPrefInt(
              SharedPreferencesHelper.DELIVERY_ID,
              apiResponse.resourceData.requestId);

          deliveryRequestId = apiResponse.resourceData.requestId;

          if (imageList != null &&
              imageList.length > 0 &&
              deliveryRequestId != 0) {
            uploadAllImagesOnAws();
          }
          //Toast.show("${apiResponse.responseMessage}", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //return paLocaionList;
        } else {
          _isSubmitPressed = false;
          setState(() {
            _isInProgress = false;
          });
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else {
        _isSubmitPressed = false;
        print("statusCode error....");
        Toast.show("status error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          _isInProgress = false;
        });
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
    //return paLocaionList;
  }

  Future<DateTime> _selectDate(BuildContext context, String dateType) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (dateType == StringValues.readyDate)
          hasReadyDateError = false;
        else
          hasDeliveryDateError = false;
      });
    }
    print("picked::: $picked");
    return picked;
  }

  Widget getRecord(int index, File imageListFile) {
    return Container(
      //color: Colors.black,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 8.0, bottom: 5.0),
            child:
                /*Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png")
                    )
                ),
              width: 95.0,
              height: 95.0,
              child: Image.file(
                imageListFile,
                //width: 95.0,
                //height: 95.0,
                fit: BoxFit.fill,
              ),
            ),*/
                Container(
                    //padding: EdgeInsets.all(30.0),
                    width: 95.0,
                    height: 95.0,
                    //color: Colors.red,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.file(
                        imageListFile,
                        //width: 95.0,
                        //height: 95.0,
                        fit: BoxFit.cover,
                      ),
                    )),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageList.removeAt(index);
                });
              },
              child: Image(
                image: new AssetImage('assets/images/img_cross_icon.png'),
                width: 20.0,
                height: 20.0,
                //fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  void getDimenUnit() {
    setState(() {
      if (dimenUnit == StringValues.inch) {
        dimenUnit = StringValues.cm;
        inchBgColor = Color(ColorValues.white);
        inchTextColor = Color(ColorValues.primaryColor);
        cmBgColor = Color(ColorValues.primaryColor);
        cmTextColor = Color(ColorValues.white);

        _length = Utils.convertInchToCM(double.parse(lengthController.text)).toString();
        lengthController.text=_length.toString();
        _width = Utils.convertInchToCM(double.parse(widthController.text)).toString();
        widthController.text=_width.toString();
        _height = Utils.convertInchToCM(double.parse(heightController.text)).toString();
      } else {
        dimenUnit = StringValues.inch;
        inchBgColor = Color(ColorValues.primaryColor);
        inchTextColor = Color(ColorValues.white);
        cmBgColor = Color(ColorValues.white);
        cmTextColor = Color(ColorValues.primaryColor);

        _length = Utils.convertCMTOInch(double.parse(lengthController.text)).toString();
        lengthController.text=_length.toString();
        _width = Utils.convertCMTOInch(double.parse(widthController.text)).toString();
        widthController.text=_width.toString();
        _height = Utils.convertCMTOInch(double.parse(heightController.text)).toString();
        heightController.text=_height.toString();
      }
      print("dimenUnit:: $dimenUnit");
    });
  }

/* uploadImage() async {
    var httpClient = newHttpClient();
    var credentials = new Credentials(accessKey: 'MY_ACCESS_KEY', secretKey: 'MY_SECRET_KEY');
    var aws = new Aws(credentials: credentials, httpClient: httpClient);
    var queue = aws.sqs.queue('https://my-queue-url/number/queue-name');
    await queue.sendMessage('Hello from Dart client!');
    httpClient.close();
  }*/

  Future validateDeliveryRequest() async {
    if (!_isSubmitPressed) {
      try {
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        bool isConnected = await Utils.isInternetConnected();
        if (isConnected) {
          if (_addressS != "") {
            print('_addressD:: $_addressD');
            if (_addressD != "") {
              _validateInputs();
            } else {
              setState(() {
                this.hasDestinationError = true;
              });
              _isSubmitPressed = false;
            }
          } else {
            setState(() {
              this.hasSourceError = true;
            });
            _isSubmitPressed = false;
          }
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
      if (_readyDate != null) {
        if (_deliveryDate != null) {
          //if(_deliveryDate.difference(_readyDate).inMilliseconds < 0)
          if (imageList.length > 0) {
            if (_checkedTCValue)
              callDeliveryRequestApi();
            else {
              Toast.show(StringValues.TEXT_PLEASE_ACCEPT, context,
                  duration: Toast.LENGTH_LONG);
              _isSubmitPressed = false;
            }
          } else {
            Toast.show(StringValues.TEXT_SELECT_IMAGES, context,
                duration: Toast.LENGTH_LONG);
            _isSubmitPressed = false;
          }
        } else {
          setState(() {
            this.hasDeliveryDateError = true;
          });
          _isSubmitPressed = false;
        }
      } else {
        setState(() {
          this.hasReadyDateError = true;
        });
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

  //-------------------------------------Upload image on Azure --------------------------
  /*Future<String> uploadImgOnAzure(imagePath, prefixPath) async {
    String accessKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_ACCESS_KEY);
    String secretToken = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_SECRET_KEY);
    print("AccessKey encoded::: $accessKey");
    accessKey = Utils.decodeStringFromBase64(accessKey);
    secretToken = Utils.decodeStringFromBase64(secretToken);
    print("secretToken decoded::: $secretToken");
    print("AccessKey decoded::: $accessKey");
    try {
      var isConnect = await Utils.isInternetConnected();
      if (isConnect) {
        final String result = await platform.invokeMethod('getBatteryLevel', {
          "sasToken": accessKey, //widget.sasToken,//access-key
          "imagePath": imagePath,
          "uploadPath": Constants.MEDIA_UPLOAD_URL + prefixPath
        });

        print("image_path::: " + result);
        return result;
      } else {
        //ToastWrap.showToast(StringValues.INTERNET_ERROR, context);
        Toast.show(StringValues.INTERNET_ERROR, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      return "";
    } on Exception catch (e) {
      return "";
    }
  }*/

  Future<String> getUploadUrlFromAWS(File imageList) async {
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
    const _s3Endpoint = Constants.MEDIA_UPLOAD_URL_WITH_REGION;
    //'https://bucketname.s3-ap-southeast-1.amazonaws.com';

    final file = imageList;
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
        Constants.AWS_BUCKET_NAME, awsAccessKey, 15, length,
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
      if (res.statusCode == 204) {
        //Toast.show(StringValues.imageUploadSuccess, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        uploadedImageUrl =
            '${Constants.MEDIA_UPLOAD_URL_WITH_REGION}${userId}/${imageNameNew}';
        print('uploaded images uploadedImageUrl:: $uploadedImageUrl');
        return uploadedImageUrl;
      }
    } catch (e) {
      print('exception::: ${e.toString()}');
      return uploadedImageUrl;
    }
    return uploadedImageUrl;
  }

  clearAllFormData() {
    _addressS = "";
    _addressD = "";
    _title = "";
    _length = "";
    _width = "";
    _height = "";
    _value = "";
    _readyDate = null;
    _deliveryDate = null;
    imageList.clear();
    _description = "";
  }

  Future uploadAllImagesOnAws() async {
    for (int i = 0; i < imageList.length; i++) {
      String imageUrl = await getUploadUrlFromAWS(imageList[i]);
      imageUrlList.add(imageUrl);
      print('imageUrlList $i :: $imageUrlList');
    }
    if (imageUrlList != null && imageUrlList.length > 0) {
      callDeliveryRequestMediaUrl();
    }
  }

  void callDeliveryRequestMediaUrl() async {
    if (!mounted) return;
    /*setState(() {
      _isInProgress = true;
    });*/
    Map<String, dynamic> requestJson = {
      "mediaUrl": imageUrlList,
      "requestId": deliveryRequestId,
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.MEDIA_UPLOAD_API;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          headers: headers, body: json.encode(requestJson));

      //if (!mounted) return;
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
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
        if (apiResponse.status == 200) {
          print("${apiResponse.message}");
          //Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          new CustomAlertDialog().getOKAlertDialog(
              context, StringValues.alertDeliverySuccessTitle, "");
          //_showDeliverySuccessAlet();
        } else if (apiResponse.status == 404) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        } else if (apiResponse.status == 500) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        } else {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else {
        _isSubmitPressed = false;
        print("statusCode error....");
        setState(() {
          _isInProgress = false;
        });
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

  void _showDeliverySuccessAlet() {}

  Future getAsyncData() async {
    access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);
  }
}
