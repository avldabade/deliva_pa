import 'dart:convert';
import 'dart:io';

import 'package:deliva/constants/Constant.dart';
import 'package:deliva/customize_predefine_widgets/circle_tab_indicator.dart';
import 'package:deliva/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva/podo/get_all_delivery_request_response.dart';
import 'package:deliva/registration/my_profile.dart';
import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliva/drawer/DrawerItem.dart';
import 'package:toast/toast.dart';

import '../delivery_request/delivery_request.dart';
import 'package:http/http.dart' as http;
class Dashboard extends StatefulWidget {
  final String countryCode;
  final String mobileNo;

  //final int userId;

  Dashboard(this.countryCode, this.mobileNo, {Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _selectedDrawerIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String userName = "";

  List<Widget> drawerOptions;

  List<DrawerItem> drawerItems;

  //for tab bar
  TabController _tabController;
  bool hasDeliveryRequest = true;
  double screenHeight;
  double screenWidth;

  bool _isInProgress=false;

  List<ResourceDataForAllDeliveryReq> allActiveRequestList;
  List<ResourceDataForAllDeliveryReq> allPublishedRequestList;
  List<ResourceDataForAllDeliveryReq> allDraftRequestList;

  int userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    //screenHeight = MediaQuery.of(context).size.height;
    //screenWidth = MediaQuery.of(context).size.width;
    getInitialData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    drawerOptions = <Widget>[];
    drawerItems = [
      new DrawerItem(
          StringValues.TEXT_HISTORY,
          new Image.asset(
            "assets/images/history_icon.png",
            //'assets/icons/drawer.png',
            width: 24.0,
            height: 24.0,
          ),
          true),
      new DrawerItem(
          StringValues.TEXT_TRANSACTION_HISTORY,
          new Image.asset(
            "assets/images/tran_hist_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_PAYMENT_SETTINGS,
          new Image.asset(
            "assets/images/pay_setting_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_CHANGE_PASSWORD,
          new Image.asset(
            "assets/images/change_pass_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_HELP,
          new Image.asset(
            "assets/images/help_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_TERMS_POLICY,
          new Image.asset(
            "assets/images/term_n_policy_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_LOGOUT,
          new Image.asset(
            "assets/images/logout_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
    ];

    for (var i = 0; i < drawerItems.length; i++) {
      //print("in drawer i: $i");

      var d = drawerItems[i];

      drawerOptions.add(Container(
        //color: Colors.indigo[600],
        //color: d.isSelected ? const Color(ColorValues.white) : Colors.transparent,
        child: new ListTile(
          leading:
              /*new Icon(
            d.icon,
            color: Colors.white,),*/
              new IconButton(
            onPressed: () {},
            icon: d.icon, //new Icon(Icons.shopping_cart),
            color: d.isSelected
                ? const Color(ColorValues.yellow_light)
                : const Color(ColorValues.white),
          ),
          title: new Text(
            d.title,
            style: TextStyle(
              color: const Color(ColorValues.white),
              /*color: d.isSelected
                    ? const Color(ColorValues.yellow_light)
                    : const Color(ColorValues.white)*/
            ),
          ),
          selected: i == _selectedDrawerIndex, //d.isSelected,
          onTap: () {
            _onSelectItem(i);
          },
        ),
      ));
    }
    ;

    return Scaffold(
      key: _scaffoldKey,
      drawer: getDrawer(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              //margin: const EdgeInsets.only(top: 24.0),
              //padding: const EdgeInsets.only(top: 50.0),
              color: Color(ColorValues.white),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/images/action_bar_header_yellow.png',
                      fit: BoxFit.fill,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                    ),
                    margin: EdgeInsets.only(top: 0.0),
                  ),
                  Container(
                    height: 60.0,
                    //color: Colors.greenAccent,
                    margin: EdgeInsets.only(top: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.all(0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                                child: new Image.asset(
                                  "assets/images/drawer_menu_icon.png",
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ),
                              Center(
                                child: Text(
                                  StringValues.AAP_NAME,
                                  style: TextStyle(
                                      color: Color(ColorValues.black),
                                      fontSize: 20.0,
                                      fontFamily: StringValues.customSemiBold),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  new Image.asset(
                                    "assets/images/search_icon.png",
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  Container(
                                    width: 10.0,
                                  ),
                                  new Image.asset(
                                    "assets/images/bell_icon.png",
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 80.0, left: 0.0, right: 0.0),
              //margin: const EdgeInsets.only(top: 24.0),
              //padding: const EdgeInsets.only(top: 50.0),
              decoration: new BoxDecoration(
                color: Color(ColorValues.white),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              child: getBody(),
            ),
          ],
        ),
      ),
    );
  }

  _onSelectItem(int index) async {
    if (!mounted) return;
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // close the drawer

    if (index == 6) {
      getAlertDialog(context);
    }
  }

  Future getAlertDialog(BuildContext context) async {
    final TwoButtonSelection action =
    await new CustomAlertDialog().getTwoBtnAlertDialog(context,StringValues.TEXT_LOGOUT_MESSAGE,StringValues.TEXT_NO,StringValues.TEXT_YES,'');
    print("Image Action::: $action");
    if (action == TwoButtonSelection.First) {
      //Navigator.of(context).pop();
    } else if (action == TwoButtonSelection.Second) {
      new Utils().callLogout(context);
    }
  }
  /*Widget getAlertDialog(BuildContext context) {
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
                                  StringValues.TEXT_LOGOUT,
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
                      StringValues.TEXT_LOGOUT_MESSAGE,
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
                    onPressed: () {
                      //setState(() {
                      Utils.saveLogoutState();
                      return Navigator.of(context).pushNamedAndRemoveUntil(
                          '/loginOptions', (Route<dynamic> route) => false);
                      // });
                    },
                    color: Color(ColorValues.yellow_light),
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(StringValues.TEXT_LOGOUT.toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                new InkWell(
                  child: new Padding(
                      padding: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                      child: new Text(
                        StringValues.TEXT_CANCEL,
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
  }*/

  Future getInitialData() async {
    String name = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.NAME);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);
    this.userId=userId;
    bool isProfileComplete = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper.IS_PROFILE_COMPLETE);
    if (name != null) {
      setState(() {
        userName = name;
      });
    }
    /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyProfile(widget.countryCode,widget.mobileNo,userId)));*/

    String countryCode = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.countryCode);
    String mobileNo = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.mobileNo);
    if (!isProfileComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyProfile(countryCode, mobileNo, userId, 'Dashboard')),
      );
    }

    //call getDelivery request API
    checkConnection();

  }
  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if(isConnected){
      allActiveRequestList = await callActiveDeliveryRequestApi();
      allPublishedRequestList = await callSaveNPublishDeliveryRequestApi(true);
      allDraftRequestList = await callSaveNPublishDeliveryRequestApi(false);
    }else{
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
  Widget getBody() {
    return hasDeliveryRequest
        ? Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                Container(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: () {
                    print('save clicked');
                    _navigateToDeliveryRequest();
                  },
                  child: Container(
                    width: screenWidth*(2/3),
                    height: 42.0,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(
                        Radius.circular(30.0),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(width: 4.0,),
                        Image(
                          image: new AssetImage(
                              'assets/images/add_more_request.png'),
                          width: 36.0,
                          height: 36.0,
                          //fit: BoxFit.fitHeight,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: Text(
                              StringValues.new_request,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:30.0,bottom: 20.0),
                    child: Text(StringValues.delivery_request,
                    style: TextStyle(color: Color(ColorValues.black),fontSize: 22.0,),),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: CircleTabIndicator(color: Colors.black, radius: 4),
                      //isScrollable: true,
                      labelColor: Color(ColorValues.black),
                      unselectedLabelColor: Color(ColorValues.unselected_tab_text_color),
                      //isScrollable: true,
                      tabs: <Widget>[
                        Tab(
                          text: StringValues.active,
                        ),
                        Tab(
                          text: StringValues.Published,
                        ),
                        Tab(
                          text: StringValues.Draft,
                        ),
                      ]),
                ),

                Expanded(
                  child: Container(
                    //height: 200.0,//screenHeight * 0.70,
                    margin: EdgeInsets.only(top: 16.0,),//, right: 16.0),
                    child: TabBarView(
                      //physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: <Widget>[
                        getDeliveryRequestAdapter(StringValues.active, allActiveRequestList),
                        getDeliveryRequestAdapter(StringValues.publish, allPublishedRequestList),
                        getDeliveryRequestAdapter(StringValues.Draft, allDraftRequestList),
                        //getPublishedDeliveryRequest(),
                        //getDraftDeliveryRequest(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : Container(
            height: screenHeight * 0.7,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _navigateToDeliveryRequest();
                      },
                      child: Image(
                        image: new AssetImage(
                            "assets/images/home_add_requesr.png"),
                        width: screenWidth * 0.52,
                        //height: screenWidth * 0.25,
                      ),
                    ),
                  ),
                  /*Container(
                  height: 30.0,
                ),
                Center(
                  child: Text(
                    StringValues.TEXT_DELIVA_REQUEST,
                    style: TextStyle(
                      color: Color(ColorValues.black),
                      fontSize: 20.0,
                    ),
                  ),
                )*/
                ],
              ),
            ),
          );
  }

  Widget getDrawer() {
    return new Drawer(
      child: Container(
        //color: const Color(ColorValues.white), //2152B5
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/drawer_bg_full_yello.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: new AssetImage(
                            "assets/images/user_img_with_edit.png"),
                        width: 70.0,
                        height: 70.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                            /*SizedBox(
                              height: 60.0,
                              width: 150.0,
                              child: FittedBox(
                                child: Text('short'),
                                fit: BoxFit.scaleDown,
                              ),),*/
                            SizedBox(
                          width: 150.0,
                          child: Text(
                            userName,
                            //"sfnjsnd wefm wefw wefwrgv wegfrwe",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(ColorValues.black),
                                fontSize: 22.0,
                                fontFamily: StringValues.customRegular),
                          ),
                        ),
                        /*  AutoSizeText(
                            'A really long String',
                            style: TextStyle(fontSize: 30),
                            minFontSize: 18,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),*/
                      )
                    ],
                  ),
                ),
                Container(
                  height: 120.0,
                ),
                new Column(children: drawerOptions),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDeliveryRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeliveryRequest()),
    );
  }

  Widget getDeliveryRequestAdapter(String type, List<ResourceDataForAllDeliveryReq> deliveryRequestList) {
    if (allActiveRequestList != null && allActiveRequestList.length>0) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: _myAdapterView(context,type,deliveryRequestList), //_myPageView(context),
      );
    } else {
      return Container(
        child: Center(
          child: Text('Data not avaliable.'),
        ),
      );
    }
  }
  Widget _myAdapterView(BuildContext context,String type, List<ResourceDataForAllDeliveryReq> deliveryRequestList) {
    if(deliveryRequestList != null){
      return ListView.builder(
        //physics: NeverScrollableScrollPhysics(),
        scrollDirection:Axis.vertical,
        shrinkWrap: true,
        itemCount: deliveryRequestList.length,
        itemBuilder:
            (context, index) {
          if(type == StringValues.active)
            return getActiveRecord(index, deliveryRequestList[index]);
          if(type == StringValues.Published)
            return getPublishedRecord(index, deliveryRequestList[index]);
          if(type == StringValues.Draft)
            return getDraftRecord(index, deliveryRequestList[index]);
        },
      );
    }else{

    }
  }
  Widget getActiveRecord(int index,ResourceDataForAllDeliveryReq data) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            //String currentLocation= await new Utils().getUserLocationNew();
            //_address='${data.city},${data.country}';
            //Navigator.pop(context, data);
          },
          child:
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(data.status,
                        style: TextStyle(color:
                        data.status == StringValues.accepted_bid ?
                        Color(ColorValues.acceptedBidColorBlue):
                        data.status == StringValues.show_inTransit ?
                        Color(ColorValues.inTransitColorGreen):
                        Color(ColorValues.inTransitColorGreen),
                            fontSize: 15.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(data.title,
                          style: TextStyle(fontSize: 20.0,color: Color(ColorValues.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${StringValues.destinationLabel}${data.destinationPaId}',
                            style: TextStyle(fontSize: 15.0,
                              color: Color(ColorValues.grey_light),
                            ),
                          ),
                        ),
                        data.status == StringValues.accepted_bid ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${StringValues.processingAgentLabel}${data.sourcePaId}',
                                style: TextStyle(fontSize: 14.0,
                                  color: Color(ColorValues.grey_light),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom:12.0,top:12.0),
                              child: Container(height: 1.0,color: Color(ColorValues.unselected_tab_text_color),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Text('${StringValues.dropOffOpaLabel}${data.deliveryBeforeDate}',
                                style: TextStyle(fontSize: 15.0,
                                  color: Color(ColorValues.greyTextColorLight),
                                ),
                              ),
                            ),
                          ],
                        ):
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${StringValues.deliveryAgentLabel}${data.daName}',
                                style: TextStyle(fontSize: 14.0,
                                  color: Color(ColorValues.grey_light),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0,top: 8.0),
                              child: Text('${StringValues.expectedDeliveryDateLabel}${data.deliveryDate}',
                                style: TextStyle(fontSize: 14.0,
                                  color: Color(ColorValues.greyTextColorLight),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom:16.0,top:12.0),
                              child: Container(height: 1.0,color: Color(ColorValues.unselected_tab_text_color),),
                            ),
                            data.currentLocation == StringValues.OPC ?
                            Image.asset(
                              "assets/images/location_OPC.png",
                              //'assets/icons/drawer.png',
                              width: screenWidth-32.0-30.0,
                              height: 45.0,
                            ):
                            data.currentLocation == StringValues.DA ?
                            Image.asset(
                              "assets/images/location_OPC.png",
                              //'assets/icons/drawer.png',
                              width: screenWidth-32.0-30.0,
                              height: 45.0,
                            ):
                            data.currentLocation == StringValues.DPC ?
                            Image.asset(
                              "assets/images/location_OPC.png",
                              //'assets/icons/drawer.png',
                              width: screenWidth-32.0-30.0,
                              height: 45.0,
                            ):
                            //data.currentLocation == StringValues.RC ?
                            Image.asset(
                              "assets/images/location_OPC.png",
                              //'assets/icons/drawer.png',
                              width: screenWidth-32.0-30.0,
                              height: 45.0,
                            ),//:Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(height: 12.0,)
      ],
    );
  }
  Widget getPublishedRecord(int index,ResourceDataForAllDeliveryReq data) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            //String currentLocation= await new Utils().getUserLocationNew();
            //_address='${data.city},${data.country}';
            //Navigator.pop(context, data);
          },
          child:
          Container(
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),*/
            //elevation: 2,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular(10.0),
              ),
              //color: Color(ColorValues.primaryColor),
              //Color(ColorValues.primaryColor),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(ColorValues.unselected_tab_text_color),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.title,
                            style: TextStyle(fontSize: 20.0,color: Color(ColorValues.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${StringValues.destinationLabel}${data.destinationPaId}',
                              style: TextStyle(fontSize: 15.0,
                                color: Color(ColorValues.grey_light),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${StringValues.deliveryBeforeLabel}${data.deliveryBeforeDate}',
                              style: TextStyle(fontSize: 14.0,
                                color: Color(ColorValues.greyTextColorLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: 75.0,
                      width: 1.0,
                      color: Color(ColorValues.greyViewColor),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: <Widget>[
                        Text('3',//${data.numberOfBids}
                          style: TextStyle(fontSize: 36.0,color: Color(ColorValues.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text('${StringValues.bid}',
                            style: TextStyle(fontSize: 30.0,
                              color: Color(ColorValues.greyTextColorLight),
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
        Container(height: 12.0,),
      ],
    );
  }
  Widget getDraftRecord(int index,ResourceDataForAllDeliveryReq data) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            //String currentLocation= await new Utils().getUserLocationNew();
            //_address='${data.city},${data.country}';
            //Navigator.pop(context, data);
          },
          child:
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)),

            ),
            elevation: 2,
            /*decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular(10.0),
              ),
              //color: Color(ColorValues.primaryColor),
              //Color(ColorValues.primaryColor),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Color(ColorValues.unselected_tab_text_color),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),*/
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.title,
                            style: TextStyle(fontSize: 20.0,color: Color(ColorValues.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${StringValues.destinationLabel}${data.destinationPaId}',
                              style: TextStyle(fontSize: 15.0,
                                color: Color(ColorValues.grey_light),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(color: Color(ColorValues.greyViewColor),height: 1.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/edit_green.png",
                              //'assets/icons/drawer.png',
                              width: 16.0,
                              height: 16.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('${StringValues.edit}',
                                style: TextStyle(fontSize: 15.0,
                                  color: Color(ColorValues.text_green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30.0,//double.maxFinite,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/delete_red.png",
                              //'assets/icons/drawer.png',
                              width: 16.0,
                              height: 16.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('${StringValues.delete}',
                                style: TextStyle(fontSize: 15.0,
                                  color: Color(ColorValues.text_red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30.0,//double.maxFinite,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/publish_yellow.png",
                              //'assets/icons/drawer.png',
                              width: 16.0,
                              height: 16.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('${StringValues.publish}',
                                style: TextStyle(fontSize: 15.0,
                                  color: Color(ColorValues.yellowTheme),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(height: 12.0,),
      ],
    );
  }

  Future<List<ResourceDataForAllDeliveryReq>> callSaveNPublishDeliveryRequestApi(bool isPublished) async {
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

    //http://3.7.49.123:8711/request/deliveryRequest/getAllRequestByCustomerStatus/{customerId}/{isPublished}        //12/false
    String dataURL = Constants.BASE_URL + Constants.published_draft_delivery_request_API;
    dataURL = dataURL + "/$userId/$isPublished";

    print("DR URL::: $dataURL");
    List<ResourceDataForAllDeliveryReq> allRequestList;
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      final Map jsonResponseMap = json.decode(response.body);
      DeliveryRequestsResponse apiResponse = new DeliveryRequestsResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        setState(() {
          _isInProgress = false;
        });

        if(apiResponse.status == 200){
          allRequestList = apiResponse.resourceData;
          return allRequestList;
        }else{
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }
        //_isSubmitPressed = false;
        setState(() {
          _isInProgress = false;
        });
      } else {
        //_isSubmitPressed = false;
        print("statusCode error....");
        if(jsonResponseMap.containsKey("responseMessage"))
        Toast.show(apiResponse.responseMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        else
        Toast.show(apiResponse.error, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        setState(() {
          _isInProgress = false;
        });
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
      print('Exception:: $e');
      //_view.onLoginError();
      //_isSubmitPressed = false;
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
      //_isSubmitPressed = false;
    }

    return allRequestList;
  }

  Future<List<ResourceDataForAllDeliveryReq>> callActiveDeliveryRequestApi() async {
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

    //http://3.7.49.123:8711/request/deliveryRequest/getAllActiveRequest/{customerId}        //12
    String dataURL = Constants.BASE_URL + Constants.active_delivery_request_API;
    dataURL = dataURL + "/$userId";

    print("DR URL::: $dataURL");
    List<ResourceDataForAllDeliveryReq> allRequestList;
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      final Map jsonResponseMap = json.decode(response.body);
      DeliveryRequestsResponse apiResponse = new DeliveryRequestsResponse.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        setState(() {
          _isInProgress = false;
        });

        if(apiResponse.status == 200){
          allRequestList = apiResponse.resourceData;
          return allRequestList;
        }else{
          Toast.show("${apiResponse.responseMessage}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }
        //_isSubmitPressed = false;
        setState(() {
          _isInProgress = false;
        });
      } else {
        //_isSubmitPressed = false;
        print("statusCode error....");
        if(jsonResponseMap.containsKey("responseMessage"))
          Toast.show(apiResponse.responseMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        else
          Toast.show(apiResponse.error, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        setState(() {
          _isInProgress = false;
        });
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      setState(() {
        _isInProgress = false;
      });
      //Utils.showRedSnackBar(Constants.TEXT_SERVER_EXCEPTION, scaffoldKey);
      print('Exception:: $e');
      //_view.onLoginError();
      //_isSubmitPressed = false;
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
      //_isSubmitPressed = false;
    }

    return allRequestList;
  }
}
