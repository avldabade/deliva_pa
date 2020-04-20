import 'package:deliva/services/shared_preference_helper.dart';
import 'package:deliva/services/utils.dart';
import 'package:deliva/values/ColorValues.dart';
import 'package:deliva/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliva/drawer/DrawerItem.dart';
import 'package:toast/toast.dart';

import '../delivery_request/delivery_request.dart';
//import 'package:auto_size_text/auto_size_text.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedDrawerIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String userName = "";

  List<Widget> drawerOptions;

  List<DrawerItem> drawerItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }

  @override
  Widget build(BuildContext context) {
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
                      'assets/images/dashboard_header_bg_yellow.png',
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
            )
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
  }

  Future getInitialData() async {
    userName = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.NAME);
    setState(() {
      userName = userName;
    });
  }

  Widget getBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:30.0, vertical: 50.0),
      decoration: new BoxDecoration(
        //color: Color(ColorValues.primaryColor),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Color(ColorValues.primaryColor),
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //topRight: Radius.circular(32.0),
        //topLeft: Radius.circular(32.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: (){
                _navigateToDeliveryRequest();
              },
              child: Image(
                image: new AssetImage("assets/images/plus.png"),
                width: 70.0,
                height: 70.0,
              ),
            ),
          ),
          Container(
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
          )
        ],
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
                        child:/*SizedBox(
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
                  height: 90.0,
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
}
