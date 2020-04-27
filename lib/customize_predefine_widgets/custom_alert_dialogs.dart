import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';

enum ImageSelectionAction { GALLERY, CAMERA, CANCEL }
enum TwoButtonSelection { First, Second}

class CustomAlertDialog {
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

  Widget getOKAlertDialog(
      BuildContext context, String alertTitleMsg, String alertDescriptionMsg) {
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
                      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
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
                  SizedBox(
                    width: 140.0,
                    height: 45,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: Color(ColorValues.yellow_light))),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      color: Color(ColorValues.yellow_light),
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(StringValues.TEXT_OK.toUpperCase(),
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

  Future<TwoButtonSelection>  getTwoBtnAlertDialog(
      BuildContext context, String alertTitleMsg,String firstButtonText,String secondButtonText, String alertDescriptionMsg) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                  Image(
                    image: new AssetImage('assets/images/check_mark.png'),
                    width: 57.0,
                    height: 57.0,
                    //fit: BoxFit.cover,
                  ),
                  new Padding(
                      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, TwoButtonSelection.First);
                        },
                        child: Container(
                          width: screenWidth/3.2,
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
                                firstButtonText.toUpperCase(),
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
                          Navigator.pop(context, TwoButtonSelection.Second);
                        },
                        child: Container(
                          width: screenWidth/3.2,
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
                    ],
                  ),
                ],
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
                        onTap: (){
                            Navigator.pop(context, ImageSelectionAction.GALLERY);
                        },
                        child: Image(
                          image: new AssetImage(
                              'assets/images/gallery.png'),
                          width: MediaQuery.of(context).size.width/3.5,
                          height: MediaQuery.of(context).size.width/3.5 -10,
                          //fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context, ImageSelectionAction.CAMERA);
                        },
                        child: Image(
                          image: new AssetImage(
                              'assets/images/camera_picker.png'),
                          width: MediaQuery.of(context).size.width/3.5,
                          height: MediaQuery.of(context).size.width/3.5 -10,
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 20.0,),
                  SizedBox(
                    width: 140.0,
                    height: 45,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: Color(ColorValues.yellow_light))),
                      onPressed: () {
                          Navigator.pop(context, ImageSelectionAction.CANCEL);
                      },
                      color: Color(ColorValues.yellow_light),
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
}
