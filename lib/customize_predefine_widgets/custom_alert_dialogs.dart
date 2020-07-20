import 'dart:ui';

import 'package:deliva_pa/drawer/Rating.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

enum ImageSelectionAction { GALLERY, CAMERA, CANCEL }
enum TwoButtonSelection { First, Second }
enum OKButtonSelection { OK }

class CustomAlertDialog {
  bool isCommentError = false;

  String _comment = '';

  final commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  double _rating;

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

  Future<OKButtonSelection> getOKAlertDialog(
      BuildContext context, String alertTitleMsg, String alertDescriptionMsg, String alertImage) {
    /*BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: ,
    )*/
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 35.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: new AssetImage('$alertImage'),
                      width: 57.0,
                      height: 57.0,
                      //fit: BoxFit.cover,
                    ),
                    new Padding(
                        padding:
                            new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: new Text(
                          alertTitleMsg,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorValues.black)),
                        )),
                    alertDescriptionMsg != ''
                        ? new Padding(
                            padding:
                                new EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 20.0),
                            child: new Text(
                              '$alertDescriptionMsg',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 18.0,
                                  color: alertDescriptionMsg.contains(StringValues.DocketNumberLabel) ? Color(ColorValues.accentColor) : Color(ColorValues.grey_light_header)),
                            ))
                        : Container(),
                    alertDescriptionMsg != '' ? Container(): Container(height: 20.0,),
                    SizedBox(
                      width: 140.0,
                      height: 45,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            side: BorderSide(
                                color: Color(ColorValues.accentColor))),
                        onPressed: () {
                          //Navigator.of(context).pop();
                          Navigator.pop(context, OKButtonSelection.OK);
                          //Navigator.of(context).pop();
                        },
                        color: Color(ColorValues.accentColor),
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              alertTitleMsg == StringValues.paymentSuccess ?
                              StringValues.goTOHome :
                              StringValues.TEXT_OKAY.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorValues.white))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<OKButtonSelection> getOKAlertDialogForDeliverdToOPC(
      BuildContext context, String alertTitleMsg, String alertDescriptionMsg, String alertImage, String subAlertDescMsg) {
    /*BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: ,
    )*/
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 35.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: new AssetImage('$alertImage'),
                      width: 57.0,
                      height: 57.0,
                      //fit: BoxFit.cover,
                    ),
                    new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: new Text(
                          alertTitleMsg,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorValues.black)),
                        )),
                    alertDescriptionMsg != ''
                        ? new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
                        child: new Text(
                          '$alertDescriptionMsg',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 18.0,
                              color: alertDescriptionMsg.contains(StringValues.DocketNumberLabel) ? Color(ColorValues.accentColor) : Color(ColorValues.grey_light_header)),
                        ))
                        : Container(),
                    alertDescriptionMsg != '' ? Container(): subAlertDescMsg != '' ? Container() : Container(height: 40.0,),
                    subAlertDescMsg != ''
                        ? new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(24.0, 2.0, 24.0, 20.0),
                        child: new Text(
                          '$subAlertDescMsg',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 15.0,
                              color: Color(ColorValues.ligthhelpTextColor)),
                        ))
                        : Container(),
                    subAlertDescMsg != '' ? Container(): Container(height: 20.0,),
                    SizedBox(
                      width: 140.0,
                      height: 45,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            side: BorderSide(
                                color: Color(ColorValues.accentColor))),
                        onPressed: () {
                          //Navigator.of(context).pop();
                          Navigator.pop(context, OKButtonSelection.OK);
                          //Navigator.of(context).pop();
                        },
                        color: Color(ColorValues.accentColor),
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              alertTitleMsg == StringValues.paymentSuccess ?
                              StringValues.goTOHome :
                              StringValues.TEXT_OKAY.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorValues.white))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<TwoButtonSelection> getTwoBtnAlertDialog(
      BuildContext context,
      String alertTitleMsg,
      String firstButtonText,
      String secondButtonText,
      String alertDescriptionMsg) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: new AssetImage('assets/images/check_mark.png'),
                      width: 57.0,
                      height: 57.0,
                      //fit: BoxFit.cover,
                    ),
                    new Padding(
                        padding:
                            new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                        child: new Text(
                          alertTitleMsg,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorValues.black)),
                        )),
                    alertDescriptionMsg != ''
                        ? new Padding(
                            padding:
                                new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                            child: new Text(
                              StringValues.TEXT_REGISTRATION_MSG,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 18.0,
                                  color: Color(ColorValues.grey_light_header)),
                            ))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        //mainAxisSize: MainAxisSize.max,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, TwoButtonSelection.First);
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
                                      firstButtonText.toUpperCase(),
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
                          ),
                          Container(width: 16.0,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, TwoButtonSelection.Second);
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
                                      secondButtonText.toUpperCase(),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: missing_return
  Future<ImageSelectionAction> getImageSelectorAlertDialog(
      BuildContext context) {
    return showDialog(
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
                Radius.circular(20.0),
                //bottomLeft: Radius.circular(32.0),
                //bottomRight: Radius.circular(32.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                      padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
                      child: new Text(
                        StringValues.select_picture,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontFamily: StringValues.customRegular,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorValues.black)),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, ImageSelectionAction.GALLERY);
                        },
                        child: Image(
                          image: new AssetImage('assets/images/gallery.png'),
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.width / 3.5 - 10,
                          //fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, ImageSelectionAction.CAMERA);
                        },
                        child: Image(
                          image:
                              new AssetImage('assets/images/camera_picker.png'),
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.width / 3.5 - 10,
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 140.0,
                    height: 45,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: Color(ColorValues.accentColor))),
                      onPressed: () {
                        Navigator.pop(context, ImageSelectionAction.CANCEL);
                      },
                      color: Color(ColorValues.accentColor),
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(StringValues.TEXT_CANCEL.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(ColorValues.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<ImageSelectionAction> getCameraImageSelectorAlertDialog(
      BuildContext context) {
    return showDialog(
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
                Radius.circular(20.0),
                //bottomLeft: Radius.circular(32.0),
                //bottomRight: Radius.circular(32.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                      padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
                      child: new Text(
                        StringValues.select_picture,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontFamily: StringValues.customRegular,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorValues.black)),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     /* GestureDetector(
                        onTap: () {
                          Navigator.pop(context, ImageSelectionAction.GALLERY);
                        },
                        child: Image(
                          image: new AssetImage('assets/images/gallery.png'),
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.width / 3.5 - 10,
                          //fit: BoxFit.cover,
                        ),
                      ),*/
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, ImageSelectionAction.CAMERA);
                        },
                        child: Image(
                          image:
                          new AssetImage('assets/images/camera_picker.png'),
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.width / 3.5 - 10,
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 140.0,
                    height: 45,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: Color(ColorValues.accentColor))),
                      onPressed: () {
                        Navigator.pop(context, ImageSelectionAction.CANCEL);
                      },
                      color: Color(ColorValues.accentColor),
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(StringValues.TEXT_CANCEL.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(ColorValues.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Future<Rating> ratingAlertDialog(BuildContext context, String full_form, String sub_title_msg,double initialRating,String initialComment) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    commentController.text=initialComment;
    _rating=initialRating;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 16.0),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image:
                                new AssetImage('assets/images/rating_alert_icon.png'),
                            width: 57.0,
                            height: 57.0,
                            //fit: BoxFit.cover,
                          ),
                          new Padding(
                              padding:
                                  new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                              child: new Text(
                                '$full_form',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontFamily: StringValues.customRegular,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorValues.black)),
                              )),
                          new Padding(
                              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                              child: new Text(
                                '$sub_title_msg',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontFamily: StringValues.customRegular,
                                    fontSize: 14.0,
                                    color: Color(ColorValues.text_view_hint)),
                              )),
                          Card(
                            margin: EdgeInsets.only(bottom: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RatingBar(
                                initialRating: initialRating,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Image(
                                    image: new AssetImage(
                                        'assets/images/start_gold_rate.png'),
                                  ),
                                  //half: _image('assets/heart_half.png'),
                                  empty: Image(
                                    image: new AssetImage(
                                        'assets/images/start_blank_rate.png'),
                                  ),

                                ),
                                itemSize: 30.0,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                onRatingUpdate: (rating) {
                                  _rating=rating;
                                  print('rating::: $rating');
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 12.0,
                          ),
                          Stack(
                            children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Text(
                                  StringValues.comments,
                                  style: TextStyle(
                                      color: Color(ColorValues.text_view_theme),
                                      fontSize: 16.0),
                                ),
                              ),
                              isCommentError
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
                                  primaryColor: Color(ColorValues.text_view_theme),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    controller: commentController,
                                    focusNode: _commentFocus,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    maxLength: 100,
                                    /*inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      // Fit the validating format.
                                    ],*/
                                    //to block space character
                                    textInputAction: TextInputAction.done,

                                    //autofocus: true,
                                    decoration: InputDecoration(
                                      //labelText: StringValues.description,
                                      hintText: initialComment,
                                      //border: InputBorder.none,
                                      counterText: '',
                                      /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                    ),
                                    /*onFieldSubmitted: (_) {
                                                      Utils.fieldFocusChange(
                                                          context, _valueFocus, _emailFocus);
                                                    },*/
                                    //validator: Validation.validateTextField,
                                    validator: (String arg) {
                                      String val = Validation.validateTextField(arg);
                                      //setState(() {
                                      if (val != null) {
                                        isCommentError = true;
                                        val = StringValues.commentErrorMsg;
                                      } else
                                        isCommentError = false;
                                      //});
                                      return val;
                                    },
                                    onSaved: (value) {
                                      _comment = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, null);
                                },
                                child: Container(
                                  width: screenWidth / 3,
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
                                        '${StringValues.notNow}',
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
                              GestureDetector(
                                onTap: () {
                                  Rating rating=new Rating('${commentController.text}',_rating.round() , TwoButtonSelection.Second);
                                  Navigator.pop(context,rating);

                                },
                                child: Container(
                                  width: screenWidth / 3,
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
                                        '${StringValues.TEXT_SUBMIT}',
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Rating> rejectAlertDialog(BuildContext context, String title, String sub_title_msg, String hintText) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 16.0),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image:
                            new AssetImage('assets/images/cancel_alert_img.png'),
                            width: 57.0,
                            height: 57.0,
                            //fit: BoxFit.cover,
                          ),
                          new Padding(
                              padding:
                              new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 4.0),
                              child: new Text(
                                '$title',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontFamily: StringValues.customRegular,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorValues.black)),
                              )),
                          new Padding(
                              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                              child: new Text(
                                '$sub_title_msg',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontFamily: StringValues.customRegular,
                                    fontSize: 18.0,
                                    color: Color(ColorValues.text_view_hint)),
                              )),
                          new Padding(
                              padding: new EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 8.0),
                              child: new Text(
                                '$hintText',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontFamily: StringValues.customRegular,
                                    fontSize: 18.0,
                                    color: Color(ColorValues.ligthhelpTextColor)),
                              )),

                          Container(
                            height: 8.0,
                          ),
                          Stack(
                            children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Text(
                                  StringValues.comments,
                                  style: TextStyle(
                                      color: Color(ColorValues.text_view_theme),
                                      fontSize: 16.0),
                                ),
                              ),
                              isCommentError
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
                                  primaryColor: Color(ColorValues.text_view_theme),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    controller: commentController,
                                    focusNode: _commentFocus,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    maxLength: 100,
                                    /*inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      // Fit the validating format.
                                    ],*/
                                    //to block space character
                                    textInputAction: TextInputAction.done,

                                    //autofocus: true,
                                    decoration: InputDecoration(
                                      //labelText: StringValues.description,
                                      //hintText: '${StringValues.comments}',
                                      //border: InputBorder.none,
                                      counterText: '',
                                      /*errorText:
                                                                              submitFlag ? _validateEmail() : null,*/
                                    ),
                                    /*onFieldSubmitted: (_) {
                                                      Utils.fieldFocusChange(
                                                          context, _valueFocus, _emailFocus);
                                                    },*/
                                    //validator: Validation.validateTextField,
                                    validator: (String arg) {
                                      String val = Validation.validateTextField(arg);
                                      //setState(() {
                                      if (val != null) {
                                        isCommentError = true;
                                        val = StringValues.commentErrorMsg;
                                      } else
                                        isCommentError = false;
                                      //});
                                      return val;
                                    },
                                    onSaved: (value) {
                                      _comment = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 35.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, null);
                                },
                                child: Container(
                                  width: screenWidth / 3,
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
                              GestureDetector(
                                onTap: () {
                                  Rating rating=new Rating('${commentController.text}',0 , TwoButtonSelection.Second);
                                  Navigator.pop(context,rating);

                                },
                                child: Container(
                                  width: screenWidth / 3,
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
                                        '${StringValues.TEXT_OKAY}',
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<TwoButtonSelection> getTwoBtnCancelAlertDialog(
      BuildContext context,
      String alertTitleMsg,
      String firstButtonText,
      String secondButtonText,
      String alertDescriptionMsg,
      String alertWarningMsg,
      String imageName
      ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: new AssetImage('$imageName'),
                      width: 57.0,
                      height: 57.0,
                      //fit: BoxFit.cover,
                    ),
                    new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: new Text(
                          alertTitleMsg,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorValues.black)),
                        )),
                    alertDescriptionMsg != ''
                        ? new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                        child: new Text(
                          '$alertDescriptionMsg',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 18.0,
                              color: Color(ColorValues.text_view_theme)),
                        ))
                        : Container(),
                    alertWarningMsg != ''
                        ? new Padding(
                        padding:
                        new EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                        child: new Text(
                          '$alertWarningMsg',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontFamily: StringValues.customRegular,
                              fontSize: 16.0,
                              color: Color(ColorValues.warning_red)),
                        ))
                        : Container(),
                    Container(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        //mainAxisSize: MainAxisSize.max,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, TwoButtonSelection.First);
                              },
                              child: Container(
                                //width: screenWidth / 3,
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
                                      firstButtonText.toUpperCase(),
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
                          ),
                          Container(width: 16.0,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, TwoButtonSelection.Second);
                              },
                              child: Container(
                                //width: screenWidth / 3,
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
                                      secondButtonText.toUpperCase(),
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
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<OKButtonSelection> getRefundOKAlertDialog(BuildContext context) {
    /*BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: ,
    )*/
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
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
                  Radius.circular(20.0),
                  //bottomLeft: Radius.circular(32.0),
                  //bottomRight: Radius.circular(32.0)
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context, OKButtonSelection.OK);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: new AssetImage('assets/images/cross_icon.png'),
                          width: 18.0,
                          height: 18.0,
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: new AssetImage('assets/images/refund_alert_img.png'),
                          width: 55.0,
                          height: 55.0,
                          //fit: BoxFit.cover,
                        ),
                        new Padding(
                            padding:
                            new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                            child: new Text(
                              '{StringValues.refundPolicy}',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorValues.black)),
                            )),
                        new Padding(
                            padding:
                            new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: new Text(
                              'StringValues.amountRefundIn',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 18.0,
                                  color: Color(ColorValues.text_view_theme)),
                            )),
                        new Padding(
                            padding:
                            new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: new Text(
                              'StringValues.moreInformation',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 15.0,
                                  color: Color(ColorValues.greyDividerColor)),
                            )),
                        new Padding(
                            padding:
                            new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                            child: new Text(
                              'StringValues.refundPolicyUnder',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 18.0,
                                  color: Color(ColorValues.black)),
                            )),
                        new Padding(
                            padding:
                            new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
                            child: new Text(
                              StringValues.termsConditions,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: StringValues.customRegular,
                                  fontSize: 18.0,
                                  color: Color(ColorValues.accentColor)),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}
