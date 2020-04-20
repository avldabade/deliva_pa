import 'dart:convert';
import 'dart:io';

import 'package:deliva/constants/Constant.dart';
import 'package:deliva/podo/pa_location_response.dart';
import 'package:deliva/services/common_widgets.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/services/validation_textfield.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class LocationSelector extends StatefulWidget {
  final String title;
  final String locationMsg;

  LocationSelector(this.title, this.locationMsg, {Key key}) : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  bool _isInProgress = false;

  bool _isSubmitPressed = false;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _search;

  ScrollController controller;

  bool isLocationAvaliable = false;

  List<PAResourceData> paLocaionList;

  String _address='';
  String filter;

  @override
  void initState() {
    // TODO: implement initState
    checkConnection();
    controller = new ScrollController();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    searchController.dispose();
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
                  Container(
                    height: 60.0,
                    //margin: EdgeInsets.only(top: 24.0),
                    child: Card(
                      margin: EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          IconButton(
                            icon: new Icon(
                              Icons.arrow_back_ios,
                              color: Color(ColorValues.black),
                            ),
                            onPressed: () {
                              Navigator.pop(context,null);
                            },
                          ),
                          Center(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: Color(ColorValues.black),
                                  fontSize: 20.0,
                                  fontFamily: StringValues.customSemiBold),
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
                  ),
                  Expanded(
                    //color: Colors.red,
                    child: ListView(
                      //scrollDirection: ,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 24.0, right: 24.0, bottom: 24.0),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 24.0),
                                    child: Text(
                                      StringValues.selectPALocation,
                                      style: TextStyle(
                                        color: Color(
                                            ColorValues.grey_light_header),
                                        fontSize: 16.0,
                                        fontFamily: StringValues.customLight,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 8.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        50.0,
                                    height: 45.0,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      //color: Color(ColorValues.grey_hint_color),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color:
                                            Color(ColorValues.grey_hint_color),
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image(
                                          image: new AssetImage(
                                              'assets/images/search_icon.png'),
                                          width: 20.0,
                                          height: 20.0,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                        Container(
                                          width: 12.0,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.words,
                                            controller: searchController,
                                            focusNode: _searchFocus,
                                            keyboardType: TextInputType.text,
                                            //to block space character
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                              //labelText: StringValues.TEXT_FULL_NAME,
                                              hintText: "Search city",//StringValues.value,

                                              border: InputBorder.none,
                                            ),
                                            validator: Validation.validateName,
                                            onSaved: (value) {
                                              _search = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 16.0,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String currentLocation= await new Utils().getUserLocationNew();

                                      _address=currentLocation;
                                      setState(() {
                                        searchController.text=currentLocation;
                                      });
                                      //Navigator.pop(context, _address);
                                      print("currentLocation:: $currentLocation");
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Image(
                                          image: new AssetImage(
                                              'assets/images/location_yello.png'),
                                          width: 20.0,
                                          height: 20.0,
                                          //fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            StringValues.TEXT_USE_CUR_LOC,
                                            style: TextStyle(
                                              color: Color(
                                                  ColorValues.primaryColor),
                                              fontSize: 15.0,
                                              fontFamily:
                                                  StringValues.customLight,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 16.0,
                                  ),
                                  getSearchLocationItems(),

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

  void checkInternet(){
    if(true){

    }else{

    }
  }

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if(isConnected){
      getLocations();
    }else{
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<List<PAResourceData>> getLocations() async {
    print("getLocations::::: ");
    //if (!mounted) return;
    setState(() {
      _isInProgress = true;
    });

    String access_token= await SharedPreferencesHelper.getPrefString(SharedPreferencesHelper.ACCESS_TOKEN);

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
    String dataURL = Constants.BASE_URL + Constants.PA_LOCATION_API;
    dataURL = dataURL + "/India";

    print("PA location URL::: $dataURL");
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        print("statusCode 200....");
        setState(() {
          _isInProgress = false;
        });
        final Map jsonResponseMap = json.decode(response.body);
        //final jsonResponse = json.decode(response.body);
        print('jsonResponse::::: ${jsonResponseMap.toString()}');
        //ResponsePodo responsePodo = new ResponsePodo.fromJson(jsonResponseMap);
        PALocationResponse apiResponse = new PALocationResponse.fromJson(jsonResponseMap);
        if(apiResponse.status == 200){
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          paLocaionList=apiResponse.resourceData;

          //Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          return paLocaionList;
        }else{
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }
        _isSubmitPressed = false;
        setState(() {
          _isInProgress = false;
        });
      } else {
        _isSubmitPressed = false;
        print("statusCode error....");
        Toast.show("status error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        setState(() {
          _isInProgress = false;
        });
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
    return paLocaionList;
  }

  Widget getRecord(int index,PAResourceData data) {
    return GestureDetector(
      onTap: () async {
        //String currentLocation= await new Utils().getUserLocationNew();
        //_address='${data.city},${data.country}';
        Navigator.pop(context, data);
      },
      child:
      filter=="" || filter==null ?
      Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text('0.4 Mile',
                  style: TextStyle(color: Color(ColorValues.accentColor),fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.name,
                    style: TextStyle(fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(data.email,
                        style: TextStyle(fontSize: 14.0,
                        color: Color(ColorValues.grey_light),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text('Address: ${data.city}, ${data.country}',
                        style: TextStyle(fontSize: 14.0,
                          color: Color(ColorValues.grey_light_header),
                        ),
                      ),
                    ),
                    Container(height: 16.0,),
                    Container(
                      //width: 127.0,
                      //height: 30.0,
                      decoration: BoxDecoration(
                        borderRadius:
                        new BorderRadius.circular(5.0),
                        //color: Color(ColorValues.grey_hint_color),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Color(
                              ColorValues.primaryColor),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: new AssetImage(
                                  'assets/images/direction_icon.png'),
                              width: 15.0,
                              height: 15.0,
                              //fit: BoxFit.fitHeight,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Get Directions".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(ColorValues
                                          .black))),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ):
      data.city.contains(filter) ?
      Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text('0.4 Mile',
                    style: TextStyle(color: Color(ColorValues.accentColor),fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(data.email,
                        style: TextStyle(fontSize: 14.0,
                          color: Color(ColorValues.grey_light),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text('Address: ${data.city}, ${data.country}',
                        style: TextStyle(fontSize: 14.0,
                          color: Color(ColorValues.grey_light_header),
                        ),
                      ),
                    ),
                    Container(height: 16.0,),
                    Container(
                      //width: 127.0,
                      //height: 30.0,
                      decoration: BoxDecoration(
                        borderRadius:
                        new BorderRadius.circular(5.0),
                        //color: Color(ColorValues.grey_hint_color),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Color(
                              ColorValues.primaryColor),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: new AssetImage(
                                  'assets/images/direction_icon.png'),
                              width: 15.0,
                              height: 15.0,
                              //fit: BoxFit.fitHeight,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Get Directions".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(ColorValues
                                          .black))),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ):
      new Container()
      ,
    );
  }

  Widget getSearchLocationItems() {
    if (paLocaionList != null && paLocaionList.length>0) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: _myAdapterView(context), //_myPageView(context),
      );
    } else {
      return Container();
      /*Center(child: SizedBox(
          width: MediaQuery.of(context).size.width-150,
          //height: MediaQuery.of(context).size.width -100,
          child: Image.asset(
            'assets/images/value.png',
            fit: BoxFit.cover,
          )),
      );*/
    }
  }

  Widget _myAdapterView(BuildContext context) {
    return ListView.builder(
      physics:
      NeverScrollableScrollPhysics(),
      scrollDirection:
      Axis.vertical,
      shrinkWrap: true,
      itemCount: paLocaionList.length,
      itemBuilder:
          (context, index) {
        return getRecord(
            index, paLocaionList[index]);
      },
    );
  }
}
