import 'dart:convert';
import 'dart:io';
import 'dart:math';


import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:package_info/package_info.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;
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
    SharedPreferencesHelper.setPrefBool(
        SharedPreferencesHelper.IS_PROFILE_COMPLETE, false);
    SharedPreferencesHelper.setPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN, '');
    SharedPreferencesHelper.setPrefInt(SharedPreferencesHelper.USER_ID, 0);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.ACCESS_TOKEN);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.AWS_ACCESS_KEY);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.AWS_SECRET_KEY);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.TOKEN_TYPE);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.REFRESH_TOKEN);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.EXPIRES_IN);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.SCOPE);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.NAME);
    //SharedPreferencesHelper.removeKey(SharedPreferencesHelper.USER_IMAGE_URL);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.USER_ID);
    SharedPreferencesHelper.removeKey(
        SharedPreferencesHelper.IS_REGISTRATION_COMPLETE);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.IS_ACTIVE);
    SharedPreferencesHelper.removeKey(
        SharedPreferencesHelper.IS_PROFILE_COMPLETE);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.JIT);
    SharedPreferencesHelper.removeKey(SharedPreferencesHelper.USER_PASSWORD);
    int id = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);
    print('UserId:: ${id}');
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
    String address = "";
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

    address =
        '${first.addressLine},${first.featureName},${first.subAdminArea},${first.adminArea}';
    print('Address:: $address');
    return address;
  }

  Future<LocationData> getUserLocationNewLatLang() async {
    //call this async method from whereever you need
    print("getUserLocationNew()");
    String address = "";
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
    return myLocation;
  }

  Future<String> getUserCountry() async {
    //call this async method from whereever you need
    print("getUserCountry()");
    String country = "";
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
    print('Country:: ${first.countryName}');

    country = '${first.countryName}';
    print('Address:: $country');
    print(
        'coordinates:: ${first.coordinates}'); //lat long{22.253104099999998,76.03181}
    print(
        'addressLine:: ${first.addressLine}'); //full address // Near railway gate, Maheshwar Rd, Barwaha, Madhya Pradesh 451115, India
    print('countryCode:: ${first.countryCode}'); //IN
    print('featureName:: ${first.featureName}'); //Maheshwar Road
    print('postalCode:: ${first.postalCode}'); //451115
    print('locality:: ${first.locality}'); //Barwaha
    print('subLocality:: ${first.subLocality}'); //null
    print('adminArea:: ${first.adminArea}'); //MP: state
    print('subAdminArea:: ${first.subAdminArea}'); //khargone dist
    print('thoroughfare:: ${first.thoroughfare}'); // Maheshwar Road
    print('subThoroughfare:: ${first.subThoroughfare}'); //null

    return country;
  }

  Future<Coordinates> getUserLatLong() async {
    //call this async method from whereever you need
    print("getUserLatLong()");
    String country = "";
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
    print(
        'inside getUserLatLong() coordinates:: ${coordinates}'); //lat long{22.253104099999998,76.03181}
    return coordinates;
  }

  Future<String> getUserCity() async {
    //call this async method from whereever you need
    print("getUserCity()");
    String city = "";
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
    city = '${first.locality}';
    print('City:: $city');
    return city;
  }

  static Future<String> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      //return path.basename(file.path);

      //return only extension
      String imageExt = path.extension(file.path);

      var timeStamp = new DateTime.now().millisecondsSinceEpoch;
      var randomNo = Utils.getRandomNo();
      String imageNameNew = 'deliva_${randomNo}_${timeStamp}${imageExt}';
      print('Complete img name:: ${imageNameNew}');

      return imageNameNew;
    } else {
      return null;
    }
  }

  static int getRandomNo() {
    var rng = new Random();
    int randomNo = rng.nextInt(100000) + 10000;
    print('randomNo::: $randomNo');
    return randomNo;
  }

  static String convertInchToCM(String number) {
    if (number != '' && number != null) {
      double num = double.parse(number);
      print('convertInchToCM num:: $num');

      double numConverted = num * 2.54;
      numConverted = double.parse((numConverted).toStringAsFixed(2));
      print('convertInchToCM numConverted:: ${numConverted}');
      return '${numConverted.toString()}';
    } else
      return "";
  }

  static String convertCMTOInch(String number) {
    if (number != '' && number != null) {
      double num = double.parse(number);
      print('convertInchToCM num:: $num');

      double numConverted = num / 2.54;
      numConverted = double.parse((numConverted).toStringAsFixed(2));
      print('convertInchToCM numConverted:: ${numConverted}');
      return '${numConverted.toString()}';
    } else
      return "";
  }

/*  static double convertCMTOInch(double num){
    print('convertInchToCM num:: $num');
    if(num != 0){
    double numConverted=num/2.54;
    print('convertCMTOInch numConverted:: $numConverted');
    return numConverted;
    }
    return 0;
  }*/

//static double screenHeight = MediaQuery.of(context).size.height;

  void callLogout(BuildContext context) {
    saveLogoutState();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/loginOptions', (Route<dynamic> route) => false);
  }


  String firstLetterUpper(String value) {
    if (value != null && value != '') {
      String s = value[0].toUpperCase() +
          value.substring(1); //"the quick brown fox jumps over the lazy dog";
      //print('Converted string s:: $s');
      return s;
    } else
      return '';
  }

  //Date time formate conversion
  DateTime formatDate(String date) {
    var parsedDate;
    if (date != null && date != '') {
      parsedDate = DateTime.parse(date);
      parsedDate = parsedDate.toLocal();
      String formatDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    }
    return parsedDate;
  }

  int getDateDifference(String date) {
    //DateTime parsedDate;
    print('getDateDifference date::: $date');
    var difference;

    if (date != null && date != '') {
      DateTime parsedDate = DateTime.parse(date);
      parsedDate = parsedDate.toLocal();
      final now = DateTime.now().subtract(Duration(days: 1));//DateTime.now();
      difference = now.toLocal().difference(parsedDate).inDays;
      //print('getDateDifference::: $difference');
    }
    return difference;
  }

  String formatTime(String dropOffTime) {
    if (dropOffTime != null && dropOffTime != '') {
    var parsedTime = DateTime.parse(dropOffTime);
    parsedTime = parsedTime.toLocal();

    String formatTime = DateFormat('hh:mm a').format(parsedTime);
    return formatTime;
    } else
      return '';
  }

  //get Month name
  String formatGetMonth(String dropOffTime) {
    if (dropOffTime != null && dropOffTime != '') {
    var parsedTime = DateTime.parse(dropOffTime);
    parsedTime = parsedTime.toLocal();

    String formatTime = DateFormat('MMM').format(parsedTime);
    return formatTime;
  } else
  return '';
  }

  //get date/day of month
  String formatGetMonthDay(String dropOffTime) {
    if (dropOffTime != null && dropOffTime != '') {
    var parsedTime = DateTime.parse(dropOffTime);
    parsedTime = parsedTime.toLocal();

    String formatTime = DateFormat('c').format(parsedTime);
    return formatTime;
    } else
      return '';
  }

  String formatDateInMonthName(String date) {
    if (date != null && date != '') {
      var parsedDate = DateTime.parse(date);
      parsedDate = parsedDate.toLocal();
      //String formatTime = DateFormat('kk:mm a').format(parsedDate);
      String formatDate = DateFormat('MMM d, yyyy').format(parsedDate);
      return formatDate;
    } else
      return '';
  }

  String formatDateInMonthNameFull(String date) {
    if (date != null && date != '') {
    var parsedDate = DateTime.parse(date);
    parsedDate = parsedDate.toLocal();
    //String formatTime = DateFormat('kk:mm a').format(parsedDate);
    String formatDate = DateFormat('d MMM yyyy').format(parsedDate);
    return formatDate;
  } else
  return '';
  }

  String formatDateInMonthNameFullTime(String date) {
    if (date != null && date != '') {
    var parsedDate = DateTime.parse(date);
    parsedDate = parsedDate.toLocal();
    //String formatTime = DateFormat('kk:mm a').format(parsedDate);
    String formatDate = DateFormat('d MMM yyyy').format(parsedDate);
    formatDate = '$formatDate at ${DateFormat('hh:mm a').format(parsedDate)}';
    return formatDate;
    } else
      return '';
  }
  String formatDateInMonthNameTime(String date) {
    if (date != null && date != '') {
    var parsedDate = DateTime.parse(date);
    parsedDate = parsedDate.toLocal();
    //String formatTime = DateFormat('kk:mm a').format(parsedDate);
    String formatDate = DateFormat('MMM d, yyyy').format(parsedDate);
    formatDate = '$formatDate at ${DateFormat('hh:mm a').format(parsedDate)}';
    return formatDate;
    } else
      return '';
  }

  String getDeviceType() {
    if (Platform.isAndroid)
      return StringValues.android;
    else if (Platform.isIOS) return StringValues.ios;
  }

  String getActualMobileNo(String mobileNoText) {
    var mobArr = mobileNoText.split('-');
    String mobileNo = '';
    for (int i = 0; i < mobArr.length; i++) {
      mobileNo = '$mobileNo${mobArr[i]}';
    }
    return mobileNo;
  }
  String getActualCardNo(String cardNoText) {
    var cardArr = cardNoText.split(' ');
    String cardNo = '';
    for (int i = 0; i < cardArr.length; i++) {
      cardNo = '$cardNo${cardArr[i]}';
    }
    return cardNo;
  }
  bool _keyboardIsVisible(BuildContext context) {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  double getTimeDifference(TimeOfDay yourTime,TimeOfDay nowTime){

    double _doubleyourTime = yourTime.hour.toDouble() +
        (yourTime.minute.toDouble() / 60);
    double _doubleNowTime = nowTime.hour.toDouble() +
        (nowTime.minute.toDouble() / 60);

    double _timeDiff = _doubleyourTime - _doubleNowTime;

    double _hr = _timeDiff;//.truncate();
    double _minute = (_timeDiff - _timeDiff.truncate()) * 60;

    print('Here your Happy $_hr Hour and $_minute min');
    return _hr;
  }

  Widget getToolTip(String tooltipMsg){
    GlobalKey _toolTipKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = _toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: _toolTipKey,
        message: '$tooltipMsg',
        preferBelow: false,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
        margin: EdgeInsets.all(0),
        showDuration: Duration(seconds: 5),
        decoration: BoxDecoration(
          color: Color(ColorValues.accentColor),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        textStyle: TextStyle(color: Colors.white, fontSize: 12.0),
        verticalOffset: 10,
        height: 21.0,
        child: Image(
          image: new AssetImage(
              'assets/images/tooltip_icon.png'),
          width: 13.0,
          height: 13.0,
          //fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  commonAppBar(String title, BuildContext context) {
    return Container(
      height: 60.0,
      //margin: EdgeInsets.only(top: 24.0),
      child:  Card(
        margin: EdgeInsets.all(0.0),
        //elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*Padding(
              padding: const EdgeInsets.only(top:4.0),
              child: IconButton(
                icon:  Image(
                  image: new AssetImage(
                      'assets/images/left_black_arrow.png'),
                  width: 20.0,
                  height: 24.0,
                  //fit: BoxFit.fitHeight,
                ),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(top:4.0,left: 16.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context, null);
                },
                child: Image(
                  image: new AssetImage(
                      'assets/images/left_black_arrow.png'),
                  width: 20.0,
                  height: 24.0,
                  //fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title != null ? '${ title.toUpperCase()}' : 'Package Title',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                      color: Color(ColorValues.black),
                      fontSize: 20.0,
                      fontFamily: StringValues.customSemiBold),
                ),
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
    );
  }
}
