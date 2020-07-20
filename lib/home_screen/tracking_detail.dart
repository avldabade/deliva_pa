import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/podo/tracking_response.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class TrackingDetail extends StatefulWidget {
  //final String status;
  final String title;
  final int requestId;

  TrackingDetail(this.title, this.requestId, {Key key}) : super(key: key);

  @override
  _TrackingDetailState createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  TrackingResourceData _data = null;

  double screenWidth;

  double screenHeight;

  bool _isExpand = true;

  List<String> imageList = new List();
  List<MediaUrls> imageOPCList = new List();
  List<MediaUrls> imageDAList = new List();
  List<MediaUrls> imageDPCList = new List();
  List<MediaUrls> imageRCList = new List();

  String _estimatedDate = '';

  String _OPCDate='',_DADate='',_DPCDate='',_RCDate='';
  String _OPC_DA_Image = 'assets/images/right_semi_circle_grey.png';
  String _DA_DPC_Image = 'assets/images/left_semi_circle_grey.png';
  String _DPC_RC_Image = 'assets/images/right_semi_circle_grey.png';




  @override
  void initState() {
    // TODO: implement initState
    checkConnection();

    super.initState();
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
    double _horizontalPadding= (screenWidth - (2*65) - (2*16) - (2*16) - 144)/2;
    print('_horizontalPadding:: $_horizontalPadding');
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
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 8.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: //_data != null ?
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 16.0,
                                ),
                                Center(
                                  child: Image(
                                    width: screenWidth/2.4,
                                    image: new AssetImage(
                                        "assets/images/scan_agent_code.png"),

                                  ),
                                ),
                                Container(
                                  height: 16.0,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              StringValues.docketNumber,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color:
                                                      Color(ColorValues.black)),
                                            ),
                                            /*Image(
                                              image: new AssetImage(
                                                  'assets/images/down_expanded_arrow.png'),
                                              width: 15.0,
                                              height: 15.0,
                                              //fit: BoxFit.fitHeight,
                                            ),*/
                                            SizedBox(
                                              width: 30.0,
                                              height: 30.0,
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '${StringValues.beforeDateLabel}${_estimatedDate}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color(ColorValues
                                                  .greyTextColorLight),
                                            ),
                                          ),
                                        ),
                                        _isExpand
                                            ? Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12.0),
                                                      child: Container(
                                                        color: Color(ColorValues
                                                            .unselected_tab_text_color),
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                    Stack(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      16.0,
                                                                  horizontal:
                                                                  _horizontalPadding,
                                                                      //75.0
                                                              ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 65.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child: Text(
                                                                        '${_OPCDate}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              3.0),
                                                                      child: Text(
                                                                        '${StringValues.deliverToPA}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: _OPCDate != '' ? Color(ColorValues.accentColor) :Color(ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 10.0,
                                                                    ),
                                                                    Center(
                                                                      child: imageOPCList !=
                                                                                  null &&
                                                                          imageOPCList.length >
                                                                                  0
                                                                          ? new Container(
                                                                        //color: Colors.red,
                                                                              height:
                                                                                  30.0,
                                                                              child: imageOPCList != null
                                                                                  ? ListView.builder(
                                                                                      //physics: NeverScrollableScrollPhysics(),
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      shrinkWrap: true,
                                                                                      itemCount: imageOPCList.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        return getRecord(index, imageOPCList[index]);
                                                                                      },
                                                                                    )
                                                                                  : Container(),
                                                                            )
                                                                          : Container(height: 30.0,),
                                                                    ),
                                                                  ],
                                                                ),
                                                               Container(height:15.0,),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child: Text(
                                                                        '$_DADate',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              3.0),
                                                                      child: Text(
                                                                        '${StringValues.deliverToDA}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                              color: _DADate != '' ? Color(ColorValues.accentColor) :Color(ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 10.0,
                                                                    ),
                                                                    Center(
                                                                      child: imageDAList !=
                                                                          null &&
                                                                          imageDAList.length >
                                                                              0
                                                                          ? new Container(
                                                                        //color: Colors.red,
                                                                        height:
                                                                        30.0,
                                                                        child: imageDAList != null
                                                                            ? ListView.builder(
                                                                          //physics: NeverScrollableScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          shrinkWrap: true,
                                                                          itemCount: imageDAList.length,
                                                                          itemBuilder: (context, index) {
                                                                            return getRecord(index, imageDAList[index]);
                                                                          },
                                                                        )
                                                                            : Container(),
                                                                      )
                                                                          : Container(height: 30.0,),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 15.0,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child: Text(
                                                                        '$_DPCDate',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              3.0),
                                                                      child: Text(
                                                                        '${StringValues.deliverToDPA}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                              color: _DPCDate != '' ? Color(ColorValues.accentColor) :Color(ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 10.0,
                                                                    ),
                                                                    Center(
                                                                      child: imageDPCList !=
                                                                          null &&
                                                                          imageDPCList.length >
                                                                              0
                                                                          ? new Container(
                                                                        //color: Colors.red,
                                                                        height:
                                                                        30.0,
                                                                        child: imageDPCList != null
                                                                            ? ListView.builder(
                                                                          //physics: NeverScrollableScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          shrinkWrap: true,
                                                                          itemCount: imageDPCList.length,
                                                                          itemBuilder: (context, index) {
                                                                            return getRecord(index, imageDPCList[index]);
                                                                          },
                                                                        )
                                                                            : Container(),
                                                                      )
                                                                          : Container(height: 30.0,),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 15.0,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child: Text(
                                                                        '$_RCDate',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5.0),
                                                                      child: Text(
                                                                        '${StringValues.deliverToReciver}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                              color: _RCDate != '' ? Color(ColorValues.accentColor) :Color(ColorValues.greyTextColorLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 10.0,
                                                                    ),
                                                                    Center(
                                                                      child: imageRCList !=
                                                                          null &&
                                                                          imageRCList.length >
                                                                              0
                                                                          ? new Container(
                                                                        //color: Colors.red,
                                                                        height:
                                                                        30.0,
                                                                        child: imageRCList != null
                                                                            ? ListView.builder(
                                                                          //physics: NeverScrollableScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          shrinkWrap: true,
                                                                          itemCount: imageRCList.length,
                                                                          itemBuilder: (context, index) {
                                                                            return getRecord(index, imageRCList[index]);
                                                                          },
                                                                        )
                                                                            : Container(),
                                                                      )
                                                                          : Container(height: 30.0,),
                                                                    ),
                                                                  ],
                                                                ),

                                                                //Container(height: 5.0,),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          //right: 12,
                                                          right: _horizontalPadding,
                                                          top: 55,
                                                          //bottom: 0,
                                                          //width: 1.0,
                                                          child:
                                                              //Container(color: ColorInfo.BLUE)),
                                                              Image(
                                                            image: new AssetImage(
                                                                '$_OPC_DA_Image'),
                                                            width: 65.0,
                                                            height: 110.0,
                                                            //fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          //left: 12,
                                                          left: _horizontalPadding,
                                                          top: 165,
                                                          //bottom: 0,
                                                          //width: 1.0,
                                                          child:
                                                              //Container(color: ColorInfo.BLUE)),
                                                              Image(
                                                            image: new AssetImage(
                                                                '$_DA_DPC_Image'),
                                                            width: 65.0,
                                                            height: 110.0,
                                                            //fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          //right: 12,
                                                          right: _horizontalPadding,
                                                          top: 285,
                                                          //bottom: 0,
                                                          //width: 1.0,
                                                          child:
                                                              //Container(color: ColorInfo.BLUE)),
                                                              Image(
                                                            image: new AssetImage(
                                                                '$_DPC_RC_Image'),
                                                            width: 65.0,
                                                            height: 110.0,
                                                            //fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8.0,
                                ),
                              ], //colijm,c,kadsm AD
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

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      _data = await callGetTrackingDetail();
      if (_data != null) getScreenFields();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<TrackingResourceData> callGetTrackingDetail() async {
    setState(() {
      _isInProgress = true;
    });

    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);
    Map<String, dynamic> requestJson = {
      /*   "countryCode": widget.countryCode,
      "mobile": widget.mobileNo,
      "otp": "1234",
      "roleId": Constants.ROLE_ID*/
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };

    //http://103.76.253.133:8711/request/deliveryRequest/getTrackingDetail/3
    String dataURL = Constants.BASE_URL + Constants.trackingRequestAPI;
    dataURL = dataURL + "/${widget.requestId}";

    print("get request tracking URL::: $dataURL");
    try {
      http.Response response = await http.get(dataURL, headers: headers);
      print("response::: ${response.body}");

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      TrackingResponse apiResponse =
          new TrackingResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
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
        margin: EdgeInsets.only(right: 4.0),
        width: 30.0,
        height: 30.0,
        //color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            //imageListFile,
            imageListFile.thumbnailUrl80X80,
            //width: 95.0,
            //height: 95.0,
            fit: BoxFit.cover,
          ),
        ));
  }
  Widget getRecordS(int index, String imageListFile) {
    return Container(
        //padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.only(right: 4.0),
        width: 30.0,
        height: 30.0,
        //color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.asset(
            imageListFile,
            //imageListFile.thumbnailUrl80X80,
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
      ///--------------------------
      imageList.add('assets/images/marker_icon.png');
      imageList.add('assets/images/marker_pa.png');
      imageList.add('assets/images/marker_icon.png');
      imageList.add('assets/images/marker_pa.png');
      imageList.add('assets/images/marker_icon.png');

      //_DADate='abc sdvf sdv';
      //_DPCDate='abc';
      //_RCDate='abc';
      ///--------------------------


      if (_data.expectedDeliveryDate != null && _data.expectedDeliveryDate != '')
        _estimatedDate = Utils().formatDateInMonthNameFull(_data.expectedDeliveryDate);

      //for OPC
      if (_data.opcDetail != null){
        if(_data.opcDetail.transitDate != null && _data.opcDetail.transitDate != '')
          _OPCDate = Utils().formatDateInMonthNameFullTime(_data.opcDetail.transitDate);
        if(_data.opcDetail.mediaUrls != null && _data.opcDetail.mediaUrls.length > 0)
          imageOPCList.addAll(_data.opcDetail.mediaUrls);
      }

      ///--------------------------
      //imageDAList=imageOPCList;
      //imageDPCList=imageOPCList;
      //imageRCList=imageOPCList;
      ///--------------------------
      //for DA
      if (_data.daDetail != null){
        if(_data.daDetail.transitDate != null && _data.daDetail.transitDate != '')
          _DADate = Utils().formatDateInMonthNameFullTime(_data.daDetail.transitDate);
        if(_data.daDetail.mediaUrls != null && _data.daDetail.mediaUrls.length > 0)
          imageDAList.addAll(_data.daDetail.mediaUrls);
      }
      //for DPC
      if (_data.dpcDetail != null){
        if(_data.dpcDetail.transitDate != null && _data.dpcDetail.transitDate != '')
          _DPCDate = Utils().formatDateInMonthNameFullTime(_data.dpcDetail.transitDate);
        if(_data.dpcDetail.mediaUrls != null && _data.dpcDetail.mediaUrls.length > 0)
          imageDPCList.addAll(_data.dpcDetail.mediaUrls);
      }
      //for RC
      if (_data.rcDetail != null){
        if(_data.rcDetail.transitDate != null && _data.rcDetail.transitDate != '')
          _RCDate = Utils().formatDateInMonthNameFullTime(_data.rcDetail.transitDate);
        if(_data.rcDetail.mediaUrls != null && _data.rcDetail.mediaUrls.length > 0)
          imageRCList.addAll(_data.rcDetail.mediaUrls);
      }

      //set image conditions
      if(_OPCDate == '' && _DADate == '' && _DPCDate == '' && _RCDate == ''){
        _OPC_DA_Image ='assets/images/right_semi_circle_grey.png';
        _DA_DPC_Image ='assets/images/left_semi_circle_grey.png';
        _DPC_RC_Image ='assets/images/right_semi_circle_grey.png';
      }
      if(_OPCDate != '' && _DADate == '' && _DPCDate == '' && _RCDate == ''){
        _OPC_DA_Image ='assets/images/right_semi_circle_yellow_grey.png';
        _DA_DPC_Image ='assets/images/left_semi_circle_grey.png';
        _DPC_RC_Image ='assets/images/right_semi_circle_grey.png';
      }
      if(_OPCDate != '' && _DADate != '' && _DPCDate == '' && _RCDate == ''){
        _OPC_DA_Image ='assets/images/right_semi_circle_yellow.png';
        _DA_DPC_Image ='assets/images/left_semi_circle_yellow_grey.png';
        _DPC_RC_Image ='assets/images/right_semi_circle_grey.png';
      }
      if(_OPCDate != '' && _DADate != '' && _DPCDate != '' && _RCDate == ''){
        _OPC_DA_Image ='assets/images/right_semi_circle_yellow.png';
        _DA_DPC_Image ='assets/images/left_semi_circle_yellow.png';
        _DPC_RC_Image ='assets/images/right_semi_circle_yellow_grey.png';
      }
      if(_OPCDate != '' && _DADate != '' && _DPCDate != '' && _RCDate != ''){
        _OPC_DA_Image ='assets/images/right_semi_circle_yellow.png';
        _DA_DPC_Image ='assets/images/left_semi_circle_yellow.png';
        _DPC_RC_Image ='assets/images/right_semi_circle_yellow.png';
      }

    });
  }
}
