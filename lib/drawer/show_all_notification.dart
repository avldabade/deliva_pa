import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/podo/all_notification_response.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';


final homeScaffoldKey = GlobalKey<ScaffoldState>();

class ShowAllNotification extends StatefulWidget {
 /* final String title;
  final String locationMsg;

  ShowAllNotification(this.title, this.locationMsg, {Key key})
      : super(key: key);*/

  @override
  _ShowAllNotificationState createState() => _ShowAllNotificationState();
}

class _ShowAllNotificationState extends State<ShowAllNotification> {
  bool _isInProgress = false;

  List<NotificationResourceData> notificationList = new List();
  List<NotificationResourceData> todayNotificationList = new List();
  List<NotificationResourceData> unreadNotificationList = new List();
  List<NotificationResourceData> weekNotificationList = new List();
  List<NotificationResourceData> OlderNotificationList = new List();

  bool isFirstTime = true;

  bool _isSubmitPressed = false;

  @override
  void initState() {
    // TODO: implement initState

    checkConnection();
    //isFirstTime = true;
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

                  Utils().commonAppBar(StringValues.notifications,context),
                  Expanded(
                    //color: Colors.red,
                    child: ListView(
                      //scrollDirection: ,
                      children: <Widget>[
                        Form(
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 12.0,
                                right: 12.0,
                                top: 24.0,
                                bottom: 24.0),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  unreadNotificationList != null && unreadNotificationList.length > 0 ?
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 8.0),
                                    child: Text(
                                      'You have ${unreadNotificationList.length} new notifications',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(ColorValues.unreadTextColor),
                                      ),
                                    ),
                                  ): Container(),
                                    //getNotificationList(unreadNotificationList, "Unread"),
                                  getNotificationList(todayNotificationList, StringValues.Today),
                                  //todayNotificationList != null && todayNotificationList.length > 0 ?
                                  //Container(height: 0.5, color: Color(ColorValues.unselected_tab_text_color),): Container(),
                                  getNotificationList(weekNotificationList,StringValues.ThisWeek),
                                  getNotificationList(OlderNotificationList,StringValues.Older),
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

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      getAllNotification();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<List<NotificationResourceData>> getAllNotification() async {
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
    //http://3.7.49.123:8711/request/deliveryRequest/getAllProcessingAgentByLocation/india/22.694099/75.86527
    String dataURL = Constants.BASE_URL + Constants.get_all_notification;
    //if(location != null)
    //dataURL = dataURL + "/$cityCountry/${location.lat}/${location.lng}";
    dataURL = dataURL + "/$userId";

    print("PA location URL::: $dataURL");
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
      NotificationResponse apiResponse =
          new NotificationResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        /*setState(() {
          isFirstTime = false;
        });*/
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          //_elements =
          //
          clearAllListOnPageRefresh();
          notificationList = apiResponse.resourceData;


          for (int i = 0; i < notificationList.length; i++) {
            var diff = Utils().getDateDifference(notificationList[i].dateTime);
            print('getDateDifference::: $diff');
            if (!notificationList[i].read)
              unreadNotificationList.add(notificationList[i]);
            if (diff == 0)
              todayNotificationList.add(notificationList[i]);
            else if (diff <= 6)
              weekNotificationList.add(notificationList[i]);
            else //if (notificationList[i].dateTime == Constants.DRAFT)
              OlderNotificationList.add(notificationList[i]);
          }

          if(unreadNotificationList != null)
            print('unreadNotificationList size:: ${unreadNotificationList.length}');
          if(todayNotificationList != null)
            print('todayNotificationList size:: ${todayNotificationList.length}');
          if(weekNotificationList != null)
            print('weekNotificationList size:: ${weekNotificationList.length}');
          if(OlderNotificationList != null)
            print('OlderNotificationList size:: ${OlderNotificationList.length}');
          
          //Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          return notificationList;
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
    return notificationList;
  }

  Widget getRecord(int index, NotificationResourceData data, String header) {
    String notificationMsg='';
    if(data != null){
      notificationMsg=data.notification;
    }

    return Padding(
      padding: const EdgeInsets.only(top:0.0),
      child: Column(
        children: <Widget>[
          index != 0 ? Container(height: 10.0,) : Container(height: 35.0,),
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.2,
            child: Row(
              children: <Widget>[
                data.read
                    ? Container(
                        width: 6.0,
                        height: 6.0,
                      )
                    : Image(
                        image: new AssetImage('assets/images/unread_dot.png'),
                        width: 6.0,
                        height: 6.0,
                        //fit: BoxFit.cover,
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            width: 0.2,
                            color:
                            Color(ColorValues.unselected_tab_text_color)),
                      ),
                      elevation: 0.5,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              //mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 4.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 75,
                                    child: _buildTextSpanWithSplittedText(
                                        '$notificationMsg', context),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6.0, right: 0.0),
                                child: Text(
                                  header != StringValues.Today ? '${Utils().formatDateInMonthNameFull(data.dateTime)}, ${Utils().formatTime(data.dateTime)}' :
                                  '${Utils().formatTime(data.dateTime)}' ,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Color(ColorValues.notificationGreyTextColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            secondaryActions: <Widget>[
              Container(
                //color: Colors.green,
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                margin: EdgeInsets.only(left: 0.0),

                child: SlideAction(
                  onTap: () {
                    /*setState(() {
                      notificationList.removeAt(index);
                    });*/
                    callDeleteNotificationAPI(data.notificationId, index);
                  },
                  decoration: new BoxDecoration(
                    color: Color(ColorValues.error_red),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                  ),
                  child: Container(
                    //color: Colors.red,
                    child: Image(
                      image:
                          new AssetImage('assets/images/delete_bin_white.png'),
                      width: 24.0,
                      height: 24.0,
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //),
        ],
      ),
    );
  }

  Widget getNotificationList(List<NotificationResourceData> notiList,String header) {
    if (notiList != null && notiList.length > 0) {
      return _myAdapterView(context,notiList,header);
    } else {
      return Container(
        //child: Text('${StringValues.noPAAvailable}'),
      );
    }
  }

  Widget _myAdapterView(BuildContext context, List<NotificationResourceData> notiList, String header) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 8.0,
          left: 8.0,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, bottom: 16.0),
            child: Text(
              '$header',
              style: TextStyle(
                fontSize: 15.0,
                color: Color(ColorValues.blueTheme),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: notiList.length,
              itemBuilder: (context, index) {
                return getRecord(index, notiList[index],header);
              },
            ),
            header != StringValues.Older ? Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 10.0,left: 16.0,right: 16.0),
              child: Container(height: 0.5, color: Color(ColorValues.unselected_tab_text_color),),
            ):Container(),
          ],
        ),
      ],
    );
  }

  RichText _buildTextSpanWithSplittedText(
      String textToSplit, BuildContext context) {
    final splittedText = textToSplit.split("#");
    final spans = List<TextSpan>();
    for (int i = 0; i <= splittedText.length - 1; i++) {
      spans.add(TextSpan(
        text:  "${splittedText[i].toString()}",
        style: TextStyle(
            color: i % 2 != 0
                ? Color(ColorValues.accentColor)
                : Color(ColorValues.black)),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }

  callDeleteNotificationAPI(int notificationId, int index) async {
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
    //http://103.76.253.133:8711/user/notification/12
    String dataURL = Constants.BASE_URL + Constants.get_all_notification;
    dataURL = dataURL + "/$notificationId";

    print("PA location URL::: $dataURL");
    try {
      http.Response response = await http.delete(dataURL,
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
      NotificationResponse apiResponse =
          new NotificationResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          refreshPage();
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
    return notificationList;
  }

  void refreshPage() {
    getAllNotification();
  }

  void clearAllListOnPageRefresh() {
    notificationList.clear();
    unreadNotificationList.clear();
    todayNotificationList.clear();
    weekNotificationList.clear();
    OlderNotificationList.clear();
  }
}
