import 'dart:convert';
import 'dart:io';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:async/async.dart';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/home_screen/aws_policy_helper.dart';
import 'package:deliva_pa/home_screen/verify_request_detail.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/request_detail.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/services/call_sms_email_service.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/image_picker_class.dart';
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
import 'package:path/path.dart' as path;

class DPCDeliverPackageToReceiver extends StatefulWidget {
  final String status;
  final String title;
  final int requestId;

  DPCDeliverPackageToReceiver(this.title, this.requestId, this.status, {Key key})
      : super(key: key);

  @override
  _DPCDeliverPackageToReceiverState createState() => _DPCDeliverPackageToReceiverState();
}

class _DPCDeliverPackageToReceiverState extends State<DPCDeliverPackageToReceiver> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  PackageResourceData _data = null;

  double screenWidth;

  double screenHeight;

  bool _isExpand = false;

  Coordinates coordinates;

  String _receiverMObile='+911234567890';


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

  bool isCodeVerify=false;
  bool isIDProofUploaded=false;

  String receiverName='Anne Walton';

  File _imagePath=null;

  List<File> imageList = new List();

  List<String> imageUrlList = new List();

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

                                                            Container(
                                                              height: 12.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                '${StringValues.ReceiverName}',
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
                                                                    text: '${Utils().firstLetterUpper(_data.recieverName)} ',
                                                                    //style: underlineStyle.copyWith(decoration: TextDecoration.none),
                                                                    style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      color: Color(
                                                                          ColorValues
                                                                              .black),
                                                                    ),
                                                                    children: [
                                                                      new TextSpan(
                                                                        text: '(${StringValues.Mobno}${_data.recieverMobile})',
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
                                                '${StringValues.ReceiverDetails}',
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
                                                  //padding: const EdgeInsets.only(left:12.0,top:16.0,right: 12.0,bottom: 24.0),
                                                  padding: const EdgeInsets.only(top:16.0,bottom: 24.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:12.0,right: 12.0),
                                                        child: Text(
                                                          '$receiverName',
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Color(
                                                                  ColorValues.black)),
                                                        ),
                                                      ), //
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 4.0,left:12.0,right: 12.0),
                                                        child: Text(
                                                          '$_receiverMObile',
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
                                                                  top: 0.0,left:12.0,right: 12.0),
                                                              child: Text(
                                                                '${StringValues.Pleaseenterthesecretcode}',
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Color(
                                                                      ColorValues
                                                                          .helpTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8.0,left:12.0,right: 12.0),
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
                                                                        obscureText: true,

                                                                        enabled: !isCodeVerify,
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
                                                                              .EnterSecretCode,
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
                                                            isCodeVerify ? Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 0.0,left:12.0,right: 12.0),
                                                                  child: Text(
                                                                    '${StringValues.UploadIDProof}',
                                                                    style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      color: Color(
                                                                          ColorValues
                                                                              .helpTextColor),
                                                                    ),
                                                                  ),
                                                                ),

                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 4.0,left:12.0,right: 12.0,bottom: 0.0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      GestureDetector(
                                                                        onTap: () async {

                                                                          if (imageList.length < 1) {
                                                                            //
                                                                            //
                                                                            //
                                                                            // (context);

                                                                            final ImageSelectionAction
                                                                            action =
                                                                            await new CustomAlertDialog()
                                                                                .getImageSelectorAlertDialog(
                                                                                context);
                                                                            print(
                                                                                "Image Action::: $action");
                                                                            if (action ==
                                                                                ImageSelectionAction
                                                                                    .GALLERY) {
                                                                              _imagePath = await ImagePickerUtility
                                                                                  .getImageFromGallery();
                                                                              if (imageList == null)
                                                                                imageList = new List();
                                                                              if (_imagePath != null) {
                                                                                setState(() {
                                                                                  imageList.add(_imagePath);
                                                                                });
                                                                              }
                                                                              print(
                                                                                  'imageList size:: ${imageList.length}');
                                                                            } else if (action ==
                                                                                ImageSelectionAction
                                                                                    .CAMERA) {
                                                                              _imagePath = await ImagePickerUtility.getImageFromCamera();
                                                                              if (imageList == null)
                                                                                imageList = new List();
                                                                              if (_imagePath != null) {
                                                                                setState(() {
                                                                                  imageList
                                                                                      .add(_imagePath);
                                                                                });
                                                                              }
                                                                              print(
                                                                                  'imageList size:: ${imageList.length}');
                                                                            }
                                                                          } else
                                                                            Toast.show(
                                                                                "${StringValues.imageLimit}",
                                                                                context,
                                                                                duration:
                                                                                Toast.LENGTH_LONG,
                                                                                gravity: Toast.BOTTOM);
                                                                        },
                                                                        child: Image(
                                                                          image: new AssetImage(
                                                                              'assets/images/add_id_proof.png'),
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
                                                                            itemCount:
                                                                            imageList.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return getRecord(index, imageList[index]);
                                                                            },
                                                                          )
                                                                              : Container(),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),

                                                                Padding(
                                                                  padding: const EdgeInsets.only(top:16.0),
                                                                  child: GestureDetector(
                                                                    onTap: () async {
                                                                      print('uploadIDProofImage Code');
                                                                      if(!isIDProofUploaded && isCodeVerify) {
                                                                       if(_imagePath != null)
                                                                        uploadIDProofImage();
                                                                       else {
                                                                         Toast.show(StringValues.TEXT_id_IMAGES, context,
                                                                             duration: Toast.LENGTH_LONG);
                                                                         //_isSubmitPressed = false;
                                                                       }
                                                                      }
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
                                                                            '${StringValues.TEXT_SAVE.toUpperCase()}',
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
                                                                ) ,
                                                              ],
                                                            ): Container(),
                                                          ],
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 56.0, right: 56.0, top: 40.0,bottom: 24.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            print('Varify Package');
                                            if(isCodeVerify && isIDProofUploaded)
                                              //callDeliverToAgentApi();
                                              showConfirmAlert();
                                            else
                                              validateCode();
                                            //showConfirmAlert();
                                          },
                                          child: Container(
                                            //width: 100.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(Radius.circular(30.0)),
                                              color: !isCodeVerify ? Color(ColorValues.primaryColor) :
                                              !isIDProofUploaded ? Color( ColorValues.grey_hint_color) :  Color(ColorValues.primaryColor) ,
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: !isCodeVerify ? Color(ColorValues.primaryColor) :
                                                !isIDProofUploaded ? Color( ColorValues.grey_hint_color) :  Color(ColorValues.primaryColor) ,
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                isCodeVerify ? '${StringValues.DELIVEREDTOReceiver.toUpperCase()}' : '${StringValues.TEXT_SUBMIT.toUpperCase()}',
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

  Widget getRecord(int index, File imageListFile) {
    return Container(
      //color: Colors.black,
      child: Stack(
        children: <Widget>[
          Padding(
            //padding: const EdgeInsets.only(right: 10.0, top: 8.0, bottom: 5.0),
            padding: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 5.0),
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
                /*width: 20.0,
                height: 20.0,*/
                width: 18.0,
                height: 18.0,
                //fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleDropDown() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  void getScreenFields() {
    setState(() {
      _data = _data;
      if(_data.recieverName != null && _data.recieverName != '')
      receiverName=Utils().firstLetterUpper(_data.recieverName);
      if (_data.recieverMobile != null && _data.recieverMobile != '')
        _receiverMObile = _data.recieverMobile ;


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
            isCodeVerify=true;
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

  Future uploadIDProofImage() async {
    setState(() {
      _isInProgress = true;
    });
    for (int i = 0; i < imageList.length; i++) {
      String imageUrl = await getUploadUrlFromAWS(imageList[i]);
      imageUrlList.add(imageUrl);
      print('imageUrlList $i :: $imageUrlList');
    }
    if (imageUrlList != null && imageUrlList.length > 0) {
      saveRecieverIdentificationDetail();
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
    //http://deliva-identity-proof.s3-website.us-east-2.amazonaws.com/receiver-identity/{request-id}
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
    //final policy = Policy.fromS3PresignedPost('${widget.requestId}/${StringValues.rcImageFolderName}/${imageNameNew}',
    final policy = Policy.fromS3PresignedPost('${StringValues.rcImageFolderName2}/${widget.requestId}/${imageNameNew}',
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
        //'${Constants.MEDIA_UPLOAD_URL_WITH_REGION}${widget.requestId}/${StringValues.rcImageFolderName}/${imageNameNew}';
        '${Constants.MEDIA_UPLOAD_URL_WITH_REGION}${StringValues.rcImageFolderName2}/${widget.requestId}/${imageNameNew}';
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


  void saveRecieverIdentificationDetail() async {
    if (!mounted) return;
    /*setState(() {
      _isInProgress = true;
    });*/

    String access_token = await SharedPreferencesHelper.getPrefString(SharedPreferencesHelper.ACCESS_TOKEN);

    Map<String, dynamic> requestJson = {
      "mediaUrl": imageUrlList,
      "requestId": widget.requestId,
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.saveRecieverIdentificationDetail;
    print("Add URL::: $dataURL");
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

        if (apiResponse.status == 200) {
          print("${apiResponse.responseMessage}");
          //Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          setState(() {
            isIDProofUploaded = true;
          });
          _isSubmitPressed=false;
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

}
