import 'dart:convert';
import 'dart:io';
import 'package:deliva_pa/forgot_password/forgot_otp.dart';
import 'package:deliva_pa/home_screen/dashboard.dart';
import 'package:deliva_pa/home_screen/opration_new_class.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/get_all_delivery_request_response.dart';
import 'package:deliva_pa/podo/pa_operational_hours.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/registration/registration.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';


class EditOperationPageNew extends StatefulWidget {
  @override
  EditOperationPageNewState createState() => EditOperationPageNewState();
}

class EditOperationPageNewState extends State<EditOperationPageNew> {
  bool _isInProgress = false;
  bool _isSubmitPressed = false;

  String allStartTime = '2:00 PM', allEndTime = '05:00 PM';

  bool isAllSelected = false;

  TimeOfDay selectedTime = TimeOfDay.now();

  OperationalResourceData operationHoursData=null;
  List<Days> daysList = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    daysList.add(new Days(dayName: "Monday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Tuesday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Wednesday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Thursday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Friday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Saturday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    daysList.add(new Days(dayName: "Sunday",startTime: "10:00 AM",endTime: "07:00 PM",open: false));
    getOperationHours();
  }

  List<OperationNewClass> listData = [
    //OperationNewClass("12:00 PM","7:00 PM","All Days",false),
    OperationNewClass("12:00 PM", "07:00 PM", "Monday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Tuesday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Wednesday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Thursday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Friday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Saturday", false),
    OperationNewClass("12:00 PM", "07:00 PM", "Sunday", false),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));

    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[

                  Utils().commonAppBar(StringValues.Text_Operational_Hours,context),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(0.0),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      getDayList(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      editOperational();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0, 0, 50.0, 20),
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            color: Color(
                                                ColorValues.primaryColor)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 8),
                                          child: Center(
                                            child: Text(
                                              "${StringValues.TEXT_UPDATE.toUpperCase()}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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

  void editOperational() async {

    setState(() {
      _isInProgress = true;
    });
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);

    Map<String, dynamic> requestJson = {
      "allDays": isAllSelected,
      "allStartTime": allStartTime,
      "allEndTime": allEndTime,
      "days": listData.map((item) => item.toJson()).toList(),
    };
    print("requestJson::: ${requestJson}");

    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    //Map<String, dynamic> requestJson1 = {"mobile": "7000543895"};
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.UPDATE_OPERATON + "$userId";
    print("Profile URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
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
          print("Submit Sucesfull!!!");
          Navigator.of(context).pop('refresh');
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
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

  Widget getDayList() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:16.0),
            child: Container(
              color: Color(ColorValues.accentColor).withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 36.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAllSelected = !isAllSelected;
                            });
                            setAllDays();
                          },
                          child: Image(
                            image: isAllSelected
                                ? new AssetImage('assets/images/selected_white.png')
                                : new AssetImage(
                                    'assets/images/unselected_white.png'),
                            width: 22.0,
                            height: 22.0,
                            //fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                StringValues.All_DAYS,
                                style: TextStyle(
                                    color: Color(ColorValues.white),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              String time=await selectTime(context,allStartTime,allEndTime,StringValues.startTime);
                              allStartTime = time;
                              setAllDays();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Color(ColorValues.white),
                                //Color(ColorValues.primaryColor),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Color(ColorValues.unselected_tab_text_color),
                                  width: 0.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:4.0, horizontal: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right:4.0),
                                      child: Text(
                                        '$allStartTime',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(
                                                ColorValues.black)),
                                      ),
                                    ),
                                Image.asset('assets/images/up_down_arrow.png',
                                width: 11.0, height: 17.0,
                                ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 12.0,
                            height: 1.0,
                            color: Color(ColorValues.white),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String time = await selectTime(
                                  context, allStartTime, allEndTime,
                                  StringValues.endTime);
                              allEndTime = time;
                              setAllDays();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Color(ColorValues.white),
                                //Color(ColorValues.primaryColor),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Color(ColorValues.unselected_tab_text_color),
                                  width: 0.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:4.0, horizontal: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right:4.0),
                                      child: Text(
                                        '$allEndTime',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(
                                                ColorValues.black)),
                                      ),
                                    ),
                                Image.asset('assets/images/up_down_arrow.png',
                                  width: 11.0, height: 17.0,
                                ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _myAdapterView(context),
          ),
        ],
      ),
    );
  }
  Widget _myAdapterView(
      BuildContext context) {

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listData.length,
      itemBuilder: (context, index) {
        return getDayRecord(index, listData[index]);
      },
    );
  }

  setAllDays() {
   setState(() {
     for (int i = 0; i < listData.length; i++) {
       listData[i].isSelect = isAllSelected;
       listData[i].startTime = allStartTime;
       listData[i].endTime = allEndTime;
     }
   });
  }

  Widget getDayRecord(int index, OperationNewClass data) {
    int sideColor=ColorValues.lightPinkColor;
    switch(index){
      case 0:
        sideColor = ColorValues.lightYellowColor;
        break;
      case 1:
        sideColor = ColorValues.lightGreenColor;
        break;
      case 2:
        sideColor = ColorValues.lightPurpleColor;
        break;
      case 3:
        sideColor = ColorValues.lightPinkColor;
        break;
        case 4:
        sideColor = ColorValues.lightBlueColor;
        break;
        case 5:
        sideColor = ColorValues.lightOrangeColor;
        break;
        case 6:
        sideColor = ColorValues.lightOrangeColor;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom:12.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            //bottomLeft: Radius.circular(5.0),
            //topLeft: Radius.circular(5.0),
          ),
          side: BorderSide(
              width: 0.2,
              color:
              Color(ColorValues.unselected_tab_text_color)),
          //side: BorderSide(width: 5, color: Colors.green),
        ),
        elevation: 1,
        margin: EdgeInsets.zero,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0))),
          child: Container(
            height: 94,
            decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Color(sideColor), width: 2.5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            data.isSelect = !data.isSelect;
                            if(isAllSelected)
                              isAllSelected = !isAllSelected;
                          });
                        },
                        child: Image(
                          image: data.isSelect
                              ? new AssetImage('assets/images/orange_selected_check.png')
                              : new AssetImage(
                              'assets/images/unselected_check_op.png'),
                          width: 22.0,
                          height: 22.0,
                          //fit: BoxFit.fitHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${data.dayName}',
                              style: TextStyle(
                                  color: Color(ColorValues.black),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            String time = await selectTime(
                                context, data.startTime, data.endTime,
                                StringValues.startTime);
                            data.startTime = time;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: Color(ColorValues.white),
                              //Color(ColorValues.primaryColor),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Color(ColorValues.unselected_tab_text_color),
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0, horizontal: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right:4.0),
                                    child: Text(
                                      '${data.startTime}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(
                                              ColorValues.black)),
                                    ),
                                  ),
                                  Image.asset('assets/images/up_down_arrow.png',
                                    width: 11.0, height: 17.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 12.0,
                          height: 1.0,
                          color: Color(ColorValues.white),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String time = await selectTime(
                                context, data.startTime, data.endTime,
                                StringValues.endTime);
                            data.endTime = time;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: Color(ColorValues.white),
                              //Color(ColorValues.primaryColor),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Color(ColorValues.unselected_tab_text_color),
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0, horizontal: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right:4.0),
                                    child: Text(
                                      '${data.endTime}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(
                                              ColorValues.black)),
                                    ),
                                  ),
                                  Image.asset('assets/images/up_down_arrow.png',
                                    width: 11.0, height: 17.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> selectTime(BuildContext context,String startTime, String endTime, String from) async {
    selectedTime = TimeOfDay.now();
    TimeOfDay currTime = selectedTime;
    String res ='';
    DateFormat format = DateFormat.jm(); //"6:00 AM"

    TimeOfDay _startTimeOfDay = null;
    TimeOfDay _endTimeOfDay = null;

    if(startTime != null && startTime != ''){
      //startTime = Utils().formatTime(startTime);
    _startTimeOfDay = TimeOfDay.fromDateTime(format.parse(startTime));
    }
    if(endTime != null && endTime != ''){
      //endTime = Utils().formatTime(endTime);
      _endTimeOfDay = TimeOfDay.fromDateTime(format.parse(endTime));
    }

    if(_startTimeOfDay != null && from == StringValues.startTime ) {
      currTime = _startTimeOfDay;
      res = startTime;
    }
    else{
      currTime = _endTimeOfDay;
      res = endTime;
    }

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: currTime,//selectedTime,
    );
    print("picked::: $picked");

    setState(() {
      if (picked != null) {
        /*if(_startTimeOfDay != null && from == StringValues.startTime )
          _startTimeOfDay = picked;
        else
          _endTimeOfDay= picked;*/

        /*if(Utils().getTimeDifference(_startTimeOfDay, selectedTime) <= 0){

          _readyTime='';
          Toast.show(StringValues.ENTER_CORRECT_TIME, context, duration: Toast.LENGTH_LONG);
        }else{*/
          res = picked.format(context);
          //_readyTime = res;
          print('res:: ${res}');
          return res;
          /*final now = new DateTime.now();
          timeinUTC = new DateTime(now.year, now.month, now.day, picked.hour,
              picked.minute); //T18:30:00.000Z

          timeinUTC = timeinUTC.toUtc();
          print('timeinUTC UTC:: ${timeinUTC}');
          timeinUTCIsoString = timeinUTC.toIso8601String();
          print('timeinUTCIsoString:: ${timeinUTCIsoString}');
          print('formate timeinUTCIsoString:: ${Utils().formatTime(timeinUTCIsoString)}');*/
        //}
      }
    });
    print('edit page res:::::>  $res ');
    return res;
  }

  Future getOperationHours() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      operationHoursData = await callGetOperationHours();
      if (operationHoursData != null) getScreenFields();
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void getScreenFields() {
    setState(() {
      if(operationHoursData.allStartTime !=null && operationHoursData.allStartTime != '')
      allStartTime = operationHoursData.allStartTime;

      if(operationHoursData.allEndTime !=null && operationHoursData.allEndTime != '')
        allEndTime = operationHoursData.allEndTime;

      if(operationHoursData.days !=null){
        for(int i=0; i < operationHoursData.days.length; i++){
          listData[i].isSelect = operationHoursData.days[i].open;
          listData[i].startTime = operationHoursData.days[i].startTime;
          listData[i].endTime = operationHoursData.days[i].endTime;
          listData[i].dayName = operationHoursData.days[i].dayName;
        }
      }
      //if(operationHoursData.allDays !=null)
        isAllSelected = operationHoursData.allDays;
    });
  }


  callGetOperationHours() async {
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
    //http://3.7.49.123:8711/request/deliveryRequest/getAllProcessingAgentByLocation/india/22.694099/75.86527
    String dataURL = Constants.BASE_URL + Constants.Operation_GET;
    dataURL = dataURL + "/$userId";

    print("PA URL::: $dataURL");
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      setState(() {
        _isInProgress = false;
      });
      _isSubmitPressed = false;
      final Map jsonResponseMap = json.decode(response.body);
      //final jsonResponse = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
      PAOperationalHours apiResponse = new PAOperationalHours.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");

          operationHoursData =apiResponse.resourceData;
          return operationHoursData;
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
    return operationHoursData;
  }
}


