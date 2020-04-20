import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:path/path.dart' as path;
//import 'package:geocoder/geocoder.dart';

class Utils {
  static String appName;
  static String packageName;
  static String version;
  static String buildNumber;

  //To check valid email
  static bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }

  /*static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }*/

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print("in isInternetConnected result: $result");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  static void showRedSnackBar(String msg, final scaffoldKey) {
    final snackbar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 1),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static void showGreenSnackBar(String msg, final scaffoldKey) {
    final snackbar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 1),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static void showAlertDialog(context) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //appName = packageInfo.appName;
    if (Platform.isAndroid) {
      // Android-specific code
      appName = packageInfo.appName;
    } else if (Platform.isIOS) {
      // iOS-specific code
      appName = "SPMS";
    }

    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.APP_NAME, appName);
    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.APP_PACKAGE_NAME, packageName);
    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.APP_VERSION, version);
    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.APP_BUILD_NUMBER, buildNumber);
    //print('appName======== $appName');
    //print('appName packageName======== $packageName');
    //print('appName version======== $version');
    //print('appName buildNumber======== $buildNumber');
  }

  static Future saveLogoutState() async {
    SharedPreferencesHelper.setPrefBool(
        SharedPreferencesHelper.IS_LOGGED_IN, false);
    SharedPreferencesHelper.setPrefBool(
        SharedPreferencesHelper.IS_LOGGED_OUT, true);

    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN, '');
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.ACCESS_TOKEN);
  }

  static String encodeStringToBase64(String stringToEncode) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded =
        stringToBase64.encode(stringToEncode); // dXNlcm5hbWU6cGFzc3dvcmQ=
    return encoded;
  }

  static String decodeStringFromBase64(String stringToDecode) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(stringToDecode); // username:password
    return decoded;
  }

  static String encodeStringURLToBase64(String stringToEncode) {
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded =
        stringToBase64Url.encode(stringToEncode); // dXNlcm5hbWU6cGFzc3dvcmQ=
    return encoded;
  }

  static String decodeStringURLFromBase64(String stringToDecode) {
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String decoded =
        stringToBase64Url.decode(stringToDecode); // username:password
    return decoded;
  }

  /* static Future launchURL(String url) async {
    //const url = 'https://advantaltechnologies.com/';
    print('launchURL url:::: $url');
    if (await canLaunch(url)) {
      //await launch(url,forceSafariVC: true,forceWebView: true);
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

/*  static getDeviceToken() async{
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.getToken().then((token){
      print("getDeviceToken() Firebase token:: $token");
      SharedPreferencesHelper.setPrefString(SharedPreferencesHelper.DEVICE_TOKEN,token);
      //updatePush(token);
    });
  }*/
  static String validateMobileNo(TextEditingController mobileNoController) {
    if (mobileNoController.text.isEmpty || mobileNoController.text == '') {
      return StringValues.ENTER_MOBILE;
    } else if (mobileNoController.text.trim().length < 10) {
      return StringValues.ENTER_10_MOBILE_NO;
    } else
      return null;
  }

  //==================== Route navigation
  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static Future<String> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = (await location.getLocation()) as Map<String, double>;
      print("currentLocation::::::: $currentLocation");
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      print("latitude::::::: $lat ,longitude::::::: $lng ");
      //final center = LatLng(lat, lng);
      return "$lat,$lng";
    } on Exception {
      print("in exception::::::::::");
      currentLocation = null;
      return null;
    }
  }

  static Future<String> getCurrentLocation() async {
    var location = new Location();
    var currentLocation = <String, double>{};
    String curAddress = '';
    try {
      currentLocation = (await location.getLocation()) as Map<String, double>;
      var lat = currentLocation["latitude"];
      var long = currentLocation["longitude"];
      print("lat:: $lat , long:: $long");
      currentLocation["accuracy"];
      currentLocation["altitude"];
      currentLocation["speed"];
      currentLocation["speed_accuracy"]; //Not for iOS

      curAddress =
          "${currentLocation["latitude"]} ${currentLocation["longitude"]}";
    } catch (e) {
      curAddress = null;
    }
    return curAddress;
  }

  Future<String> getUserLocationNew() async {
    //call this async method from whereever you need
    print("getUserLocationNew()");
    String address="";
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    var currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

    address='${first.addressLine},${first.featureName},${first.subAdminArea},${first.adminArea}';
    print('Address:: $address');
    return address;
  }

  getAddressFromCoordinates(){

  }
  static Future<String> getFileNameWithExtension(File file)async{

    if(await file.exists()){
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      //return path.basename(file.path);

      //return only extension
      String imageExt = path.extension(file.path);

      var timeStamp=new DateTime.now().millisecondsSinceEpoch;
      var randomNo=Utils.getRandomNo();
      String imageNameNew='deliva_${randomNo}_${timeStamp}${imageExt}';
      print('Complete img name:: ${imageNameNew}');

      return imageNameNew;
    }else{
      return null;
    }
  }
  static int getRandomNo(){
    var rng = new Random();
    int randomNo=rng.nextInt(100000)+10000;
    print('randomNo::: $randomNo');
    return randomNo;
  }
  static double convertInchToCM(double num){
    print('convertInchToCM num:: $num');
    if(num != 0){
    double numConverted=num*2.54;
    //numConverted.round();
    print('convertInchToCM numConverted:: $numConverted');
    return numConverted;
    }
    else
    return 0;
  }
  static double convertCMTOInch(double num){
    print('convertInchToCM num:: $num');
    if(num != 0){
    double numConverted=num/2.54;
    print('convertCMTOInch numConverted:: $numConverted');
    return numConverted;
    }
    return 0;
  }
}
