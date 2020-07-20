import 'dart:convert';
import 'dart:io';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/home_screen/verify_request_detail.dart';
import 'package:deliva_pa/podo/request_detail.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/services/call_sms_email_service.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/model.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class OPCDeliverPackageToAgent extends StatefulWidget {
  final String status;
  final String title;
  final int requestId;

  OPCDeliverPackageToAgent(this.title, this.requestId, this.status, {Key key})
      : super(key: key);

  @override
  _OPCDeliverPackageToAgentState createState() => _OPCDeliverPackageToAgentState();
}

class _OPCDeliverPackageToAgentState extends State<OPCDeliverPackageToAgent> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  PackageResourceData _data = null;

  double screenWidth;

  double screenHeight;

  bool _isExpand = false;

  List<MediaUrls> imageList = new List();

  List<BidDetails> bidDetailList = new List();

  Coordinates coordinates;

  String _currency;
  String _bidCurrency;

  String firstHalf;
  String secondHalf;
  bool flag = true;
  String description =
      "Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";


  String mobileNumber = '1234567890';
  String emailId = 'test123@gmail.com';
  bool _checkedValue = false;

  final codeController= TextEditingController();
  final FocusNode _codeFocus = FocusNode();

  bool codeError=false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _codeValue='';

  bool isDeliverToAgent=false;

  String DANAme='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                  Utils().commonAppBar(widget.title,context),
                  Expanded(
                    //color: Colors.red,
                    child: ListView(
                      //scrollDirection: ,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: _data != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 12.0,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                         //'${StringValues.DocketNumber}',
                                                         '${_data.docketNumber}',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Color(
                                                                  ColorValues.black)),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              top: 4.0),
                                                          child: Text(
                                                            '${StringValues.date}${Utils().formatDateInMonthNameTime(_data.currentDate)}',
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(ColorValues
                                                                  .greyTextColorLight),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 33.0,
                                                      height: 33.0,
                                                      child: new IconButton(
                                                        onPressed: _toggleDropDown,
                                                        icon: Image.asset(_isExpand
                                                            ? 'assets/images/up_expanded_arrow.png'
                                                            : 'assets/images/down_expanded_arrow.png'),
                                                        //color:Color(ColorValues.accentColor),
                                                        //iconSize: 24.0,
                                                      ),
                                                    )
                                                  ],
                                                ), //

                                                _isExpand
                                                    ? Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12.0),
                                                              child: Container(
                                                                color: Color(
                                                                    ColorValues
                                                                        .unselected_tab_text_color),
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: Text(
                                                                '${StringValues.Customer}',
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .greyTextColorLight),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5.0),
                                                              child: Text(
                                                                '${Utils().firstLetterUpper(_data.customer)}',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 12.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: Text(
                                                                '${StringValues.DeliveryAgent}',
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .greyTextColorLight),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: new RichText(
                                                                text:
                                                                new TextSpan(
                                                                    text: '${Utils().firstLetterUpper(_data.deliveryAgent)} ',
                                                                    //style: underlineStyle.copyWith(decoration: TextDecoration.none),
                                                                    style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      color: Color(
                                                                          ColorValues
                                                                              .black),
                                                                    ),
                                                                    children: [
                                                                      new TextSpan(
                                                                        text: '(${StringValues.id}${_data.deliveryAgentId})',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            15.0,
                                                                            color:
                                                                            Color(ColorValues.greyTextColorLight)),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ),
                                                            /*Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5.0),
                                                              child: Text(
                                                                '${Utils().firstLetterUpper(_data.deliveryAgent)} (${StringValues.id}${_data.deliveryAgentId})',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),*/
                                                            Container(
                                                              height: 12.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                '${StringValues.DeliveryagentpickupDate}',
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .greyTextColorLight),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Text(
                                                                '${Utils().formatDateInMonthName(_data.expectedDeliveryDate)}',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 12.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                '${StringValues.destination}',
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .greyTextColorLight),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5.0),
                                                              child: Text(
                                                                '${Utils().firstLetterUpper(_data.destination)}',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 12.0,
                                                            ),

                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 8.0,
                                      ),

                                      Container(
                                        color: Color(ColorValues.accentColor).withOpacity(0.1),
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0,top: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 16.0),
                                              child: Text(
                                                '${StringValues.DeliveryAgentDetails}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  //fontWeight: FontWeight.w600,
                                                  color: Color(ColorValues
                                                      .black_light_new), //Color(ColorValues.white)
                                                ),
                                              ),
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              elevation: 2,
                                              child: Form(
                                                key: _formKey,
                                                autovalidate: _autoValidate,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:12.0,top:16.0,right: 12.0,bottom: 24.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        '$DANAme',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Color(
                                                                ColorValues.black)),
                                                      ), //
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 4.0),
                                                        child: Text(
                                                          '${StringValues.id}${_data.deliveryAgentId}',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(ColorValues
                                                                .helpTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                  12.0),
                                                              child: Container(
                                                                color: Color(
                                                                    ColorValues
                                                                        .unselected_tab_text_color),
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 0.0),
                                                              child: Text(
                                                                '${StringValues.scanQRCode}',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .helpTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8.0),
                                                              child: Stack(
                                                                children: <Widget>[
                                                                 codeError && _autoValidate
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
                                                                            top: 17.0),
                                                                      ),
                                                                    ),
                                                                    child: SizedBox(
                                                                      height: 65.0,
                                                                      child: TextFormField(
                                                                        controller: codeController,
                                                                        focusNode: _codeFocus,
                                                                        keyboardType: TextInputType.number,
                                                                        enabled: !isDeliverToAgent,
                                                                        obscureText: true,
                                                                        maxLength: 6,
                                                                        inputFormatters: [
                                                                          WhitelistingTextInputFormatter.digitsOnly,
                                                                        ],
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
                                                                                    "assets/images/sceret_code_icon.png"),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          //icon: Icon(Icons.lock_outline),
                                                                          counterText: '',
                                                                          //labelText: StringValues.TEXT_FIRST_NAME,
                                                                          hintText: StringValues
                                                                              .Enteragentcode,
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

                                                                        },
                                                                        validator: (String arg) {
                                                                          String val =
                                                                          Validation.validateSecretCodeTextField(
                                                                              arg);
                                                                          //setState(() {
                                                                          if (val != null) {
                                                                            codeError = true;
                                                                          }
                                                                          else
                                                                            codeError = false;
                                                                          //});
                                                                          return val;
                                                                        },
                                                                        onChanged: (String arg) {
                                                                          String val =
                                                                          Validation.validateSecretCodeTextField(
                                                                              arg);
                                                                          //setState(() {
                                                                          if (val != null) {
                                                                            codeError = true;
                                                                          }
                                                                          else
                                                                            codeError = false;
                                                                          //});
                                                                          setState(() {});
                                                                        },
                                                                        onSaved: (value) {
                                                                          //print('email value:: $value');
                                                                          _codeValue = value;
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top:16.0),
                                                              child: GestureDetector(
                                                                onTap: () async {
                                                                  print('Submit Code');
                                                                  if(!isDeliverToAgent)
                                                                  validateCode();
                                                                },
                                                                child: Center(
                                                                  child: Container(
                                                                    width: 140.0,
                                                                    height: 45.0,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      new BorderRadius.all(Radius.circular(20.0)),
                                                                      //color: Color(ColorValues.primaryColor),
                                                                      //Color(ColorValues.primaryColor),
                                                                      shape: BoxShape.rectangle,
                                                                      border: Border.all(
                                                                        color: Color(ColorValues.primaryColor),
                                                                        width: 1,
                                                                        style: BorderStyle.solid,
                                                                      ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        '${StringValues.TEXT_SUBMIT.toUpperCase()}',
                                                                        style: TextStyle(
                                                                          fontSize: 16.0,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Color(ColorValues
                                                                              .accentColor), //Color(ColorValues.white)
                                                                        ),
                                                                      ),
                                                                    ),
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
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 44.0, right: 44.0, top: 24.0,bottom: 24.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  print('Varify Package');
                                                  if(isDeliverToAgent)
                                                    callDeliverToAgentApi();
                                                  //showConfirmAlert();
                                                },
                                                child: Container(
                                                  //width: 100.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    new BorderRadius.all(Radius.circular(30.0)),
                                                    color: isDeliverToAgent ? Color(ColorValues.primaryColor) :Color( ColorValues.grey_hint_color),
                                                    //Color(ColorValues.primaryColor),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: isDeliverToAgent ? Color(ColorValues.primaryColor) :Color( ColorValues.grey_hint_color),
                                                      width: 1,
                                                      style: BorderStyle.solid,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${StringValues.DELIVERED_TO_AGENT.toUpperCase()}',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(ColorValues
                                                            .white), //Color(ColorValues.white)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ], //colijm,c,kadsm AD
                                  )
                                : Container(),
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

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      coordinates = await Utils().getUserLatLong();
      if(widget.requestId != null){
        _data = await callGetPackageDetail();
      }
      if (_data != null) getScreenFields();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<PackageResourceData> callGetPackageDetail() async {
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
    //http://3.7.49.123:8711/request/deliveryRequest/details/2/2/27
    ///deliveryRequest/details/{requestId}/{roleId}/{userId}
    coordinates = await Utils().getUserLatLong();
    String dataURL = Constants.BASE_URL + Constants.delivery_request_detail_API;
    dataURL = dataURL +
        "/${widget.requestId}/${Constants.ROLE_ID}/$userId/${coordinates.latitude}/${coordinates.longitude}";

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
      RequestDetailResponse apiResponse =
          new RequestDetailResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          imageList = apiResponse.resourceData.mediaUrls;
          bidDetailList = apiResponse.resourceData.bidDetails;
          print('imageList size:: ${imageList.length}');
          if (bidDetailList != null) {
            print('bidDetailList size:: ${bidDetailList.length}');
          }

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

  Widget getRecord(int index, MediaUrls imageListFile) {
    return Container(
        //padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.only(right: 8.0),
        width: 50.0,
        height: 50.0,
        //color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            imageListFile.thumbnailUrl80X80,
            //width: 95.0,
            //height: 95.0,
            fit: BoxFit.cover,
          ),
        ));
  }

  void _toggleDropDown() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  void getScreenFields() {
    setState(() {
      _data = _data;
      DANAme=Utils().firstLetterUpper(_data.deliveryAgent);
      if (_data.currency == StringValues.USD) {
        _currency = '\$';
      } else {
        _currency = StringValues.rupeeSign;
      }
    });
    //set more description
    description = _data.description;
    if (description.length > 150) {
      firstHalf = description.substring(0, 50);
      secondHalf = description.substring(50, description.length);
    } else {
      firstHalf = description;
      secondHalf = "";
    }

    print('_data.currentLocation::: ${_data.currentLocation}');

    emailId = _data.dpcEmail;
    mobileNumber = _data.dpcContactNo;


  }

  Future showConfirmAlert() async {
    final OKButtonSelection action = await CustomAlertDialog()
        .getOKAlertDialog(
        context,
        StringValues.ConfirmDelivery,
        '',
        'assets/images/like_orange.png');
    if (action == OKButtonSelection.OK) {
      //back to home
      //show OK Alert
      Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
    }
  }

  Future validateCode() async {
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

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //call verify code API
      callVerifyCodeApi();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      _isSubmitPressed = false;
    }
  }
  callVerifyCodeApi() async {
    setState(() {
      _isInProgress = true;
    });

    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    //http://103.76.253.133:8711/request/deliveryRequest/cancelRequest/1234

    String dataURL = Constants.BASE_URL + Constants.verifyPickupForDA;
    dataURL = dataURL + "/${widget.requestId}/${codeController.text}";

    print("get code verify URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL, headers: headers);
      print("response::: ${response.body}");

      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      ResponsePodo apiResponse =
      new ResponsePodo.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          setState(() {
            isDeliverToAgent=true;
          });
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

    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
    }
  }
  callDeliverToAgentApi() async {
    setState(() {
      _isInProgress = true;
    });

    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    //http://103.76.253.133:8711/request/deliveryRequest/cancelRequest/1234

    String dataURL = Constants.BASE_URL + Constants.packageDelivered;
    dataURL = dataURL + "/${widget.requestId}";

    print("deliver to DA URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL, headers: headers);
      print("response::: ${response.body}");

      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      ResponsePodo apiResponse =
      new ResponsePodo.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          showConfirmAlert();
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

    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
    }
  }

}
