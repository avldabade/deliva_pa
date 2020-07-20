import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:async/async.dart';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/delivery_request/aws_policy_helper.dart';
import 'package:deliva_pa/drawer/Rating.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/request_detail.dart';
import 'package:deliva_pa/podo/verify_detail_response.dart';
import 'package:deliva_pa/services/call_sms_email_service.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/image_picker_class.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/model.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class VerifyPackageDetail extends StatefulWidget {
  final String title;
  final int requestId;

  VerifyPackageDetail(this.title, this.requestId, {Key key}) : super(key: key);

  @override
  _VerifyPackageDetailState createState() => _VerifyPackageDetailState();
}

class _VerifyPackageDetailState extends State<VerifyPackageDetail> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  double screenWidth;

  double screenHeight;

  //File _imagePath;

  File _CaptureIDProofImage = null;
  File _ProductimagesImage = null;
  File _PackageimagesImage = null;

  bool _checkedDimenValue=true;
  bool _checkedWeightValue=true;
  bool _checkedFragileValue=true;
  final CallsAndMessagesService _service = CallsAndMessagesService();

  VerifyResourceData _data=null;

  String _mobileNo='';
  String _weight='';
  String _dimen='';

  List<File> imageList = new List();
  List<String> imageUrlList = new List();

  List<Map<String, String>> urlJsonList=new List();

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
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    '${StringValues.ConfirmPackageDetails}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color(ColorValues.black),
                                    ),
                                  ),
                                ),
                               Container(height: 24.0,),
                                Container(
                                  width: screenWidth - 32,
                                  //height: 45.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    new BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: Color(
                                        ColorValues.primaryColor).withOpacity(0.6),
                                    //Color(ColorValues.primaryColor),
                                    shape: BoxShape.rectangle,
                                    /*border: Border.all(
                                      color: Color(
                                          ColorValues.primaryColor),
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),*/
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all( 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                StringValues.DimensionOK,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedDimenValue =
                                                            !_checkedDimenValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: _checkedDimenValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_YES,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(width: 16.0,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedDimenValue =
                                                            !_checkedDimenValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: !_checkedDimenValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_NO,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(height: 16.0,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            //width: screenWidth - 32-64,
                                            //height: 45.0,

                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: Color(
                                                  ColorValues.white),
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(
                                                    ColorValues.white),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Padding(padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 8.0,right: 8.0),
                                            child:  Text(
                                              'L: 250000cm, W: 250000cm, H: 100000cm',
                                              //'$_dimen',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: Color(ColorValues.accentColor).withOpacity(0.6),
                                              ),
                                              //maxLines: 1,
                                            ),
                                            ),
                                          ),
                                        ),
                                        Container(height: 24.0,),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                StringValues.WeightOK,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedWeightValue =
                                                            !_checkedWeightValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: _checkedWeightValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_YES,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(width: 16.0,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedWeightValue =
                                                            !_checkedWeightValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: !_checkedWeightValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_NO,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(height: 16.0,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            //width: screenWidth - 32-64,
                                            //height: 45.0,

                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: Color(
                                                  ColorValues.white),
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(
                                                    ColorValues.white),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Padding(padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 8.0,right: 8.0),
                                              child:  Text(
                                                //'50000.0LBS',
                                                '$_weight',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Color(ColorValues.accentColor).withOpacity(0.6),
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(height: 24.0,),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                StringValues.IsFragile,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedFragileValue =
                                                            !_checkedFragileValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: _checkedFragileValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_YES,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(width: 16.0,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _checkedFragileValue =
                                                            !_checkedFragileValue;
                                                          });
                                                        },
                                                        child: Image(
                                                          image: !_checkedFragileValue
                                                              ? new AssetImage(
                                                              'assets/images/selected_white.png')
                                                              : new AssetImage(
                                                              'assets/images/unselected_white.png'),
                                                          width: 22.0,
                                                          height: 22.0,
                                                          //fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              StringValues
                                                                  .TEXT_NO,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      ColorValues
                                                                          .white),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize:
                                                                  14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(width: 16.0,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(height: 16.0,),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 16.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        await takeImage(
                                            StringValues.CaptureIDProof);
                                      },
                                      child: _CaptureIDProofImage == null
                                          ? Image(
                                              image: new AssetImage(
                                                  'assets/images/select_id_proof.png'),
                                              width: (screenWidth - 48) / 3,
                                              //height: 95.0,
                                              //fit: BoxFit.cover,
                                            )
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0),
                                              width: (screenWidth - 48) / 3,
                                              height: (screenWidth - 48) / 3,
                                              //color: Colors.red,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: Image.file(
                                                  _CaptureIDProofImage,
                                                  //width: 95.0,
                                                  //height: 95.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await takeImage(
                                            StringValues.Productimages);
                                      },
                                      child: _ProductimagesImage == null
                                          ? Image(
                                              image: new AssetImage(
                                                  'assets/images/select_product_img.png'),
                                              width: (screenWidth - 48) / 3,
                                              //height: 95.0,
                                              //fit: BoxFit.cover,
                                            )
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0),
                                              width: (screenWidth - 48) / 3,
                                              height: (screenWidth - 48) / 3,
                                              //color: Colors.red,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: Image.file(
                                                  _ProductimagesImage,
                                                  //width: 95.0,
                                                  //height: 95.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await takeImage(
                                            StringValues.Packageimages);
                                      },
                                      child: _PackageimagesImage == null
                                          ? Image(
                                              image: new AssetImage(
                                                  'assets/images/select_package_img.png'),
                                              width: (screenWidth - 48) / 3,
                                              //height: 95.0,
                                              //fit: BoxFit.cover,
                                            )
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0),
                                              width: (screenWidth - 48) / 3,
                                              height: (screenWidth - 48) / 3,
                                              //color: Colors.red,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: Image.file(
                                                  _PackageimagesImage,
                                                  //width: 95.0,
                                                  //height: 95.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 16.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _service.call('$_mobileNo');
                                  },
                                  child: Container(
                                    //width: 130.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      //color: Color(ColorValues.primaryColor),
                                      //Color(ColorValues.primaryColor),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: Color(ColorValues.accentColor),
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                'assets/images/phone_orange.png'),
                                            width: 22.0,
                                            height: 22.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                          Container(
                                            width: 8.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              StringValues.CALLTOda,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                    ColorValues.accentColor),
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            print('cancel clicked');
                                            getRejectAlertDialog();
                                          },
                                          child: Center(
                                            child: Container(
                                              //width: screenWidth * 0.6,
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
                                                  color: Color(
                                                      ColorValues.black_light),
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    StringValues.REJECT
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 16,
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
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            print('Confirm clicked');
                                            _validateInputs();
                                          },
                                          child: Center(
                                            child: Container(
                                              //width: screenWidth * 0.6,
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
                                                  color: Color(
                                                      ColorValues.primaryColor),
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    StringValues.CONFIRM
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 16,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              //colijm,c,kadsm AD
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

  takeImage(String from) async {
    File _localImage;
    final ImageSelectionAction action =
        await new CustomAlertDialog().getCameraImageSelectorAlertDialog(context);
    print("Image Action::: $action");
    if (action == ImageSelectionAction.GALLERY) {
      _localImage = await ImagePickerUtility.getImageFromGallery();
    } else if (action == ImageSelectionAction.CAMERA) {
      _localImage = await ImagePickerUtility.getImageFromCamera();
    }
    setState(() {
      if (from == StringValues.CaptureIDProof) {
        _CaptureIDProofImage = _localImage;
      } else if (from == StringValues.Productimages) {
        _ProductimagesImage = _localImage;
      } else if (from == StringValues.Packageimages) {
        _PackageimagesImage = _localImage;
      }
    });
  }

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      if(widget.requestId != null){
        _data = await getPickupVerificationDetail();
      }
      if (_data != null) getScreenFields();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<VerifyResourceData> getPickupVerificationDetail() async {
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

    String dataURL = Constants.BASE_URL + Constants.getPickupVerificationDetail;
    dataURL = dataURL + "/${widget.requestId}";

    print("getPickupVerificationDetail URL::: $dataURL");
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
      VerifyDetailResponse apiResponse =
      new VerifyDetailResponse.fromJson(jsonResponseMap);
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

    //mobile
    if(_data.mobile != null && _data.mobile != '')
    _mobileNo=_data.mobile;

    //weight
    if(_data.weight != null)
      _weight =_data.weight.toStringAsFixed(0);
    if(_data.wtUnit != null && _data.wtUnit != '')
      _weight = _weight + _data.wtUnit.toString();

    //dimen
    String dUnit ='Inch';
    if(_data.dmUnit != null && _data.dmUnit != '')
      dUnit = _data.dmUnit.toString();

    if(_data.length != null)
      _dimen ='L: ${_data.length.toStringAsFixed(0)}$dUnit';
    if(_data.width != null)
      _dimen ='$_dimen, W: ${_data.width.toStringAsFixed(0)}$dUnit';
      if(_data.height != null)
      _dimen ='$_dimen, H: ${_data.height.toStringAsFixed(0)}$dUnit';
  }

  Future uploadAllImagesOnAws() async {
    if(_CaptureIDProofImage != null)
    imageList.add(_CaptureIDProofImage);
    if(_ProductimagesImage != null)
    imageList.add(_ProductimagesImage);
    if(_PackageimagesImage != null)
    imageList.add(_PackageimagesImage);

    setState(() {
      _isInProgress = true;
    });

    for (int i = 0; i < imageList.length; i++) {
      String imageUrl = await getUploadUrlFromAWS(imageList[i]);
      imageUrlList.add(imageUrl);
      print('imageUrlList $i :: $imageUrlList');
      String imageCode='';
      if(i==0){
        imageCode="PA_OPC_ID";
      }else if(i==1){
        imageCode="PA_OPC_PRODUCT";
      }else if(i==2){
        imageCode="PA_OPC_PACKAGE";
      }

      urlJsonList.add( {
        "imageCode": imageCode,
        "mediaUrl": imageUrlList[i]
      });
     /* Map<String, dynamic> urlJson2 = {
        "imageCode": "PA_OPC_PRODUCT",
        "mediaUrl": imageUrlList[1]
      };
      Map<String, dynamic> urlJson3 = {
        "imageCode": "PA_OPC_PACKAGE",
        "mediaUrl": imageUrlList[2]
      };*/
    }
    if (imageUrlList != null && imageUrlList.length > 0) {
      callVerifyRequestAPI();
    }
  }

  Future<String> getUploadUrlFromAWS(File imageList) async {
    String uploadedImageUrl = '';
    String awsAccessKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_ACCESS_KEY);
    awsAccessKey = Utils.decodeStringFromBase64(awsAccessKey);
    String awsSecretKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_SECRET_KEY);
    awsSecretKey = Utils.decodeStringFromBase64(awsSecretKey);
    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);

    print('awsSecretKey::: $awsSecretKey');
    print('awsAccessKey::: $awsAccessKey');

    const _region = 'us-east-2'; //'ap-southeast-1';
    const _s3Endpoint = Constants.MEDIA_UPLOAD_URL_WITH_REGION;
    //'https://bucketname.s3-ap-southeast-1.amazonaws.com';
//https://deliva-request-image-full.s3.us-east-2.amazonaws.com/{requestId}/opc-images/{filename}
    final file = imageList;
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();
    print('image file length:: $length');
    final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    /*final policy = Policy.fromS3PresignedPost('uploaded/square-cinnamon.jpg',
        'bucketname', awsAccessKey, 15, length,
        region: _region);*/
//{requestId}/opc-images/{filename}
    String imageNameNew = await Utils.getFileNameWithExtension(imageList);
    final policy = Policy.fromS3PresignedPost('${widget.requestId}/${StringValues.opcImageFolderName}/${imageNameNew}',
    //final policy = Policy.fromS3PresignedPost('${widget.requestId}/$imageNameNew',
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
        '${Constants.MEDIA_UPLOAD_URL_WITH_REGION}${widget.requestId}/${StringValues.opcImageFolderName}/${imageNameNew}';
        print('uploaded images uploadedImageUrl:: $uploadedImageUrl');
        return uploadedImageUrl;
      }else{

      }
    } catch (e) {
      print('exception::: ${e.toString()}');
      return uploadedImageUrl;
    }
    return uploadedImageUrl;
  }

  void callVerifyRequestAPI() async {
    if (!mounted) return;
    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);



      Map<String, dynamic> requestJson = {
        "dimOk": _checkedDimenValue,
        "fragile": _checkedFragileValue,
        "imageCode": "string",
        "matched": true,
        //"mediaUrl": imageUrlList,
        "packageOk": true,
        "requestId": widget.requestId,
        "userId": userId,
        "weightOk": _checkedWeightValue,
        "mediaUrlDetail": urlJsonList,
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.confirmPickupRequestAPI;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          headers: headers, body: json.encode(requestJson));

      print("response::: ${response.body}");

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);

      if (response.statusCode == 200) {
        print("statusCode 200....");
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
        if (apiResponse.status == 200) {
          print("${apiResponse.message}");
          //Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          String alertMsg='${StringValues.PackageConfirmed}';
          int backResult=2;

          final OKButtonSelection okAction = await new CustomAlertDialog()
              .getOKAlertDialogForDeliverdToOPC(
              context, alertMsg, "${StringValues.DocketNumberLabel}${apiResponse.resourceData.docketNo}",'assets/images/like_orange.png',StringValues.writeThisDocket);

          if (okAction == OKButtonSelection.OK) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/dashboard', (Route<dynamic> route) => false);
          }

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

  void _validateInputs() {
    if(_CaptureIDProofImage != null){
      if(_ProductimagesImage != null){
        if(_PackageimagesImage != null){
          uploadAllImagesOnAws();
        }else{
          Toast.show(StringValues.TEXT_SELECT_package_IMAGES, context,
              duration: Toast.LENGTH_LONG);
          _isSubmitPressed = false;
        }
      }else{
        Toast.show(StringValues.TEXT_SELECT_product_IMAGES, context,
            duration: Toast.LENGTH_LONG);
        _isSubmitPressed = false;
      }
    }else{
      Toast.show(StringValues.TEXT_SELECT_identity_IMAGES, context,
          duration: Toast.LENGTH_LONG);
      _isSubmitPressed = false;
    }
  }

  Future getRejectAlertDialog() async {
    final Rating rating = await CustomAlertDialog().rejectAlertDialog(
        context,
        StringValues.RejectPackage,
        StringValues.RejectPackageDetailmsg,
        StringValues.RejectPackageSubDetailmsg,
    );

    print("rating.comment::: ${rating.comment}");
    if (rating != null) {
      //int ratingValue=rating.rate;
      String comment =rating.comment;
      //call Rate API here
      callRejectRequestAPI(comment);
    }
  }

  void callRejectRequestAPI(String comment) async {
    setState(() {
      _isInProgress = true;
    });
    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);

    Map<String, dynamic> requestJson = {
        "comment": comment,
        "requestId": widget.requestId,
      "userId": userId,
      "dimOk": _checkedDimenValue,
      "fragile": _checkedFragileValue,
      "matched": true,
      "packageOk": true,
      "weightOk": _checkedWeightValue
    };

    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.rejectPickup;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          headers: headers, body: json.encode(requestJson));
      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });

      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);

      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

        if (apiResponse.status == 200) {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //back to home
          //show OK Alert
          final OKButtonSelection action = await CustomAlertDialog().getOKAlertDialog(context,StringValues.pickupRejectedSuccess,'','assets/images/check_mark.png');
          if (action == OKButtonSelection.OK) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/dashboard', (Route<dynamic> route) => false);
          }
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
  }

}
