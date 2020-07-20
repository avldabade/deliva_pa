import 'dart:convert';
import 'dart:io';

import 'package:deliva_pa/api_interface/Api_Calling.dart';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/customize_predefine_widgets/circle_tab_indicator.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/detailPages/BankingDetail_Page.dart';
import 'package:deliva_pa/detailPages/BusinessAddressPage.dart';
import 'package:deliva_pa/detailPages/edit_operation_page_ad.dart';
import 'package:deliva_pa/detailPages/operation_page_ad.dart';
import 'package:deliva_pa/drawer/change_password.dart';
import 'package:deliva_pa/drawer/show_all_notification.dart';
import 'package:deliva_pa/drawer/view_profile.dart';
import 'package:deliva_pa/home_screen/da_package_detail.dart';
import 'package:deliva_pa/home_screen/opc_package_detail.dart';
import 'package:deliva_pa/home_screen/package_detail.dart';
import 'package:deliva_pa/home_screen/tracking_detail.dart';
import 'package:deliva_pa/podo/all_request_response.dart';
import 'package:deliva_pa/podo/response_podo.dart';
import 'package:deliva_pa/registration/my_profile.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliva_pa/drawer/DrawerItem.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'dpc_package_detail.dart';

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
  String userImageUrl = "";

  List<Widget> drawerOptions;

  List<DrawerItem> drawerItems;

  bool hasDeliveryRequest = true;
  double screenHeight;
  double screenWidth;

  bool _isInProgress = false;

  List<RequestResourceData> allRequest = new List();
  List<RequestResourceData> allIncomingRequest = new List();
  List<RequestResourceData> allOutgoingRequest = new List();
  List<RequestResourceData> allCustomerRequest = new List();
  List<RequestResourceData> allOPCRequest = new List();
  List<RequestResourceData> allDARequest = new List();
  List<RequestResourceData> allDPCRequest = new List();

  int userId;
  bool iconChange = false;
  bool _isProfileComplete = false;
  bool _isActive = false;
  var bussinessAddress, bankingDetails, operationalHours;
  String fullName = '',
      bankName = '',
      bankLocation = '',
      accountNumber = '',
      abaNumber = '',
      businessName = '';
  String address = '',
      state = '',
      zipcode = '',
      city = '',
      aptNumber = '',
      country = "";
  String startTime = '',
      endTime = '',
      allDays = '',
      startTimeA = "",
      endTimeA = '';
  var dayName, open;
  List operationListUpdate = new List();

  bool isPAApproved = true;

  String requestType = StringValues.incomingPackages;

  Color deliveredBgColor;

  Color deliveredTextColor;

  Color cancelledBgColor;
  Color cancelledTextColor;

  final searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _search;

  bool isAdminApproved = false;
  bool isNewLogin = false;
  bool isBusinessProfileComplete = false;

  bool _isExpand = false;

  int _groupValue = -1;

  int _radioValue = 1;

  Color _radioTextColor;

  //for FCM notification
  bool _newNotification = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init userImageUrl:: $userImageUrl');

    //init for outgoing
    /*deliveredBgColor = Color(ColorValues.primaryColor);
    deliveredTextColor = Color(ColorValues.white);
    cancelledBgColor = Color(ColorValues.white);
    cancelledTextColor = Color(ColorValues.primaryColor);*/

    //init for incoming
    deliveredBgColor = Color(ColorValues.white);
    deliveredTextColor = Color(ColorValues.primaryColor);
    cancelledBgColor = Color(ColorValues.primaryColor);
    cancelledTextColor = Color(ColorValues.white);

    //  getPrefernce();
    //screenHeight = MediaQuery.of(context).size.height;
    //screenWidth = MediaQuery.of(context).size.width;
    getInitialData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getPrefernce() async {
    _isProfileComplete = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper.IS_REGISTRATION_COMPLETE);
    print(_isProfileComplete);
    _isActive = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper.IS_ACTIVE);
    print(_isActive);
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
          StringValues.TEXT_TERMS_Conditions,
          new Image.asset(
            "assets/images/term_n_policy_icon.png",
            width: 24.0,
            height: 24.0,
          ),
          false),
      new DrawerItem(
          StringValues.TEXT_Privacy_POLICY,
          new Image.asset(
            "assets/images/privacy_policy.png",
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
                ? const Color(ColorValues.accentColor)
                : const Color(ColorValues.white),
          ),
          title: new Text(
            d.title,
            style: TextStyle(
              color: const Color(ColorValues.white),
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
                      'assets/images/header_orange.png',
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
                              Container(
                                //color: Colors.green,
                                child: GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                  child: new Image.asset(
                                    "assets/images/drawer_menu_icon.png",
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  //color: Colors.red,
                                  child: Padding(
                                    //padding: const EdgeInsets.only(left: 28.0,top:4.0),
                                    padding: const EdgeInsets.only(left: 28.0),
                                    child: Text(
                                      StringValues.AAP_NAME,
                                      style: TextStyle(
                                          color: Color(ColorValues.black),
                                          fontSize: 23.0,
                                          //fontFamily: StringValues.customSemiBold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                //color: Colors.green,
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        //_navigateToEditOperationalHours();
                                      },
                                      child: new Image.asset(
                                        "assets/images/search_icon.png",
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                    ),
                                    Container(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _newNotification = false;
                                        });
                                        _navigateToNotificationPage();
                                      },
                                      child: _newNotification
                                          ? Stack(
                                        children: <Widget>[
                                          new Image.asset(
                                            "assets/images/bell_icon.png",
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 13,
                                                minHeight: 13,
                                              ),
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                          : new Image.asset(
                                        "assets/images/bell_icon.png",
                                        width: 24.0,
                                        height: 24.0,
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
            _isInProgress ? CommonWidgets.getLoader(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Container(
      child: !isNewLogin ? getApprovedPage() : getCompleteProfileTab(),
    );
  }

  _onSelectItem(int index) async {
    if (!mounted) return;
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // close the drawer

    /*if (index == 7) {
      getAlertDialog(context);
    }*/
    switch (index) {
      case 2:
        _navigateToBankingDetails();
        break;
      case 3:
        _navigateToChangePassword();
        break;
      case 7:
        getAlertDialog(context);
        break;
    }
  }

  Future getAlertDialog(BuildContext context) async {
    final TwoButtonSelection action = await new CustomAlertDialog()
        .getTwoBtnAlertDialog(context, StringValues.TEXT_LOGOUT_MESSAGE,
            StringValues.TEXT_NO, StringValues.TEXT_YES, '');
    print("Image Action::: $action");
    if (action == TwoButtonSelection.First) {
      //Navigator.of(context).pop();
    } else if (action == TwoButtonSelection.Second) {
      new Utils().callLogout(context);
    }
  }

  Future getInitialData() async {
    getUserData();
    String name = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.NAME);

    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);
    this.userId = userId;
    bool isProfileComplete = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper
            .IS_REGISTRATION_COMPLETE); // basic profile check

    isNewLogin = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper
            .isNewLogin); //to verify user in for first time after approval

    isBusinessProfileComplete = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper
            .IS_PROFILE_COMPLETE); //for banking/business deatil complete check

    isAdminApproved = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper.IS_ACTIVE); //for admin approval check

    print('isProfileComplete::: $isProfileComplete');
    print('isNewLogin::: $isNewLogin');
    print('isBusinessProfileComplete::: $isBusinessProfileComplete');
    print('isAdminApproved::: $isAdminApproved');

    setState(() {
      //  _isProfileComplete=isProfileComplete;
      print("completeprofile-----" + _isProfileComplete.toString());
    });
    print(businessName);
    if (businessName != null) {
      /*  setState(() {
        userName = businessName;
        print(userName);
      });*/
    }
    bool active = await SharedPreferencesHelper.getPrefBool(
        SharedPreferencesHelper.IS_ACTIVE);
    setState(() {
      _isActive = active;
      print("active===" + _isActive.toString());
    });

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
    } else {
      //call getDelivery request API
      checkConnection();
    }
  }

  checkConnection() async {
    bool isConnected = await Utils.isInternetConnected();
    if (isConnected) {
      if (isBusinessProfileComplete && isAdminApproved && !isNewLogin) {
        //user already approved and not login for first time
        allRequest = await callGetAllRequestForPA();
      } else {
        ////user approved and login for first time show business
        // bankig and other details are not completed
        //call api to get profile
        await callGetProfile();
      }
    } else {
      Toast.show(StringValues.INTERNET_ERROR, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Widget getDrawer() {
    return new Drawer(
      child: Container(
        //color: const Color(ColorValues.white), //2152B5
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/sidepanel.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToViewProfile();
                    },
                    child: Row(
                      children: <Widget>[
                        /*CircleAvatar(
                          radius: 35.0,
                          child: userImageUrl != '' && userImageUrl != null
                              ? ClipOval(
                            child: Image.network(
                              userImageUrl,
                              width: 70.0,
                              height: 70.0,
                              fit: BoxFit.cover,
                            )

                          ): Image(
                    image: new AssetImage(
                    "assets/images/user_img_with_edit.png"),
                    width: 70.0,
                    height: 70.0,
                  ),
                          backgroundColor: Colors.transparent,
                        ),*/
                        Container(
                          //color: Colors.red,
                            child: Stack(
                              children: <Widget>[
                                userImageUrl != '' && userImageUrl != null
                                    ? CircleAvatar(
                                  radius: 35.0,
                                  child:  ClipOval(
                                      child: Image.network(
                                        userImageUrl,
                                        width: 70.0,
                                        height: 70.0,
                                        fit: BoxFit.cover,
                                      )

                                  ),
                                  backgroundColor: Colors.transparent,
                                ): Image(
                                  image: new AssetImage(
                                      "assets/images/user_img.png"),
                                  width: 70.0,
                                  height: 70.0,
                                ),
                                Positioned(
                                  right: 0.0,
                                  bottom: 5.0,
                                  child: Image(
                                    image: new AssetImage(
                                        "assets/images/edit_pencile.png"),
                                    width: 22.0,
                                    height: 22.0,
                                  ),
                                ),
                              ],
                            )
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
                              '$userName',
                              //"sfnjsnd wefm wefw wefwrgv wegfrwe",
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(ColorValues.black),
                                  fontSize: 18.0,
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
                ),
                Container(
                  height: 75.0,//120.0,
                ),
                new Column(children: drawerOptions),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future callGetProfile() async {
    // Prepare Request

    // CustomProgressLoader.showLoader(context);

    String url = Constants.BASE_URL + Constants.Get_profile;
    url = url + "/$userId" + "/${Constants.ROLE_ID}";

    // print(UserPreference.getAccessToken());

    String response =
        await APICalling.getapiRequestWithAccessToken(url, context);

    var parsedJson = json.decode(response);

    print('parsedJson::: $parsedJson');
    print(url);

    // print(map);

    if (parsedJson != "") {
      var message = parsedJson['message'];
      var status = parsedJson['status'];

      //  CustomProgressLoader.cancelLoader(context);

      print(status);

      // Success to navigate to login page otherwise stay here
      if (status == 200) {
        var resourceData = parsedJson['resourceData'];
        bussinessAddress = resourceData["bussinessAddress"];
        businessName = resourceData["businessName"];
        bankingDetails = resourceData["bankingDetails"];
        operationalHours = resourceData["operationalHours"];

        setState(() {
          if (bussinessAddress != null) {
            address = bussinessAddress['address'].toString();
            state = bussinessAddress['state'].toString();
            zipcode = bussinessAddress['zipcode'].toString();
            country = bussinessAddress['country'].toString();
            city = bussinessAddress['city'].toString();
            aptNumber = bussinessAddress['aptNumber'].toString();
          }

          if (bankingDetails != null) {
            fullName = bankingDetails['fullName'].toString();
            bankName = bankingDetails['bankName'].toString();

            bankLocation = bankingDetails['bankLocation'].toString();
            accountNumber = bankingDetails['accountNumber'].toString();
            abaNumber = bankingDetails['abaNumber'].toString();

            if (operationalHours != null) {
              operationListUpdate = operationalHours['days'];

              /*       print(days);
              for(int i=0;i<days.length;i++){
              String  dayName=days[i]['dayName'].toString();
              String  startTime=days[i]['startTime'].toString();
              String  endTime=days[i]['endTime'].toString();
              bool  isSelect=days[i]['isSelect'];
              selectDays.add(OperationalList(startTime, endTime, dayName, isSelect));

                print(dayName);
               // open=days[i]['open'].toString();

              }*/

            }
          }
          bussinessAddress;
          bankingDetails;
          operationalHours;
        });

        print(bussinessAddress);
        // Navigator.of(context).pop();

        // getTrustWallet();
        // getDashBoardInfo();
      } else {
        if (message == "100") {
          /*   Fluttertoast.showToast(
              msg: "Your session has been expired please Log in again.",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIos: 5);*/

          // UserPreference.logout(context);
        }
      }
    } else {
      // API failure
      // CustomProgressLoader.cancelLoader(context);

      /*Fluttertoast.showToast(
          msg: Constants.SOMETHING_WENT_WRONG,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 5);*/
    }
  }

  Widget getApprovedPage() {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("delivered clicked");
                            getrequestType();
                          },
                          child: Container(
                            //width: 100.0,
                            height: 38.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0)),
                              color: deliveredBgColor,
                              //Color(ColorValues.grey_hint_color),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Color(ColorValues.primaryColor),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${StringValues.outgoingPackages.toUpperCase()}',
                                style: TextStyle(
                                  color:
                                      deliveredTextColor, //Color(ColorValues.primaryColor)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("cancelled clicked");
                            getrequestType();
                          },
                          child: Container(
                            //width: 100.0,
                            height: 38.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)),
                              color: cancelledBgColor,
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
                                '${StringValues.incomingPackages.toUpperCase()}',
                                style: TextStyle(
                                  color:
                                      cancelledTextColor, //Color(ColorValues.white)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    side: BorderSide(
                        width: 0.2,
                        color: Color(ColorValues.unselected_tab_text_color)),
                  ),
                  elevation: 0.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50.0,
                      height: 45.0,
                      //padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image:
                                new AssetImage('assets/images/search_grey.png'),
                            width: 20.0,
                            height: 20.0,
                            //fit: BoxFit.fitHeight,
                          ),
                          Container(
                            width: 6.0,
                          ),
                          Expanded(
                            child: Center(
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: searchController,
                                focusNode: _searchFocus,
                                //enabled: false,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 14.0),
                                //to block space character
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  //labelText: StringValues.TEXT_FULL_NAME,
                                  hintText: StringValues.searchText,
                                  //StringValues.value,

                                  border: InputBorder.none,
                                ),
                                //validator: Validation.validateName,
                                onSaved: (value) {
                                  _search = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            width: 0.2,
                            color:
                                Color(ColorValues.unselected_tab_text_color)),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _radioValue == 1 ? '${StringValues.fromCustomer}':'${StringValues.fromAjent}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(ColorValues.black)),
                            ),
                            SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: new IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpand = !_isExpand;
                                  });
                                },
                                icon: Image.asset(_isExpand
                                    ? 'assets/images/up_expanded_arrow.png'
                                    : 'assets/images/down_expanded_arrow.png'),
                                //color:Color(ColorValues.accentColor),
                                //iconSize: 24.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ), //

                    _isExpand
                        ? Card(
                      margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  width: 0.2,
                                  color: Color(
                                      ColorValues.unselected_tab_text_color)),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 35.0,
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Radio(
                                          value: 1,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChange,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        new Text(
                                          '${StringValues.fromCustomer}',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: _radioValue == 1
                                                ? Color(ColorValues.accentColor)
                                                : Color(
                                                ColorValues.unselected_tab_text_color),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4.0),
                                    child: Container(
                                      color: Color(ColorValues.unselected_tab_text_color),
                                      height: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35.0,
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Radio(
                                          value: 0,
                                          groupValue: _radioValue,
                                          onChanged: /*(int value){
                                            value == 1
                                                ? _radioTextColor= Color(ColorValues.accentColor)
                                                : _radioTextColor= Color(
                                                ColorValues.radioTextColor);
                                            setState(() {
                                              _radioValue = value;
                                            });
                                          },*/
                                          _handleRadioValueChange,

                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        new Text(
                                          '${StringValues.fromAjent}',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            //color:
                                            color: _radioValue == 0
                                                ? Color(ColorValues.accentColor)
                                                : Color(
                                                ColorValues.unselected_tab_text_color),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*_myRadioButton(
                                    title: '${StringValues.fromCustomer}',
                                    value: 1,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),
                                  _myRadioButton(
                                    title: '${StringValues.fromAjent}',
                                    value: 0,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),*/
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                height: 16.0,
              ),
              Container(
                //color: Colors.red,
                child: allRequest != null && allRequest.length > 0
                    ? Container(
                        child: /*requestType == StringValues.outgoingPackages
                            ? getRequestList(allOutgoingRequest)
                            : getRequestList(allIncomingRequest),*/
                            /*requestType == StringValues.outgoingPackages
                            ? _radioValue == 1 ? getRequestList(allOutgoingRequest):  getRequestList(allOutgoingRequest)
                            : _radioValue == 1 ? getRequestList(allDPCRequest):  getRequestList(allOPCRequest)*/
                        requestType == StringValues.outgoingPackages && _radioValue == 1
                        ? getRequestList(allDPCRequest)
                            : requestType == StringValues.outgoingPackages && _radioValue == 0
                            ? getRequestList(allOPCRequest)
                            : requestType == StringValues.incomingPackages && _radioValue == 1
                            ? getRequestList(allCustomerRequest)
                            : getRequestList(allDARequest),

                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                          ),
                          Image(
                            image: new AssetImage(
                                'assets/images/sorry_no_data.png'),
                            width: 40.0,
                            height: 40.0,
                            //fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 16.0),
                            child: Text(
                              requestType == StringValues.incomingPackages
                                  ? StringValues.noPackage
                                  : StringValues.noPackageDeliver,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(ColorValues.accentColor),
                                  fontSize: 22.0,
                                  fontFamily: StringValues.customSemiBold),
                            ),
                          ),
                        ],
                      ),
              ),
              //getCustomerRecord(1,null),
              //getOPCRecord(1,null),
              //getDARecord(1,null),
              //getDPCRecord(1,null),
            ],
          ),
        ),
      ],
    );
  }

  Widget getCompleteProfileTab() {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(12.0, 10, 12, 10),
          child: Column(
            children: <Widget>[
              //isBusinessProfileComplete
              bussinessAddress != null &&
                  bankingDetails != null &&
                  operationalHours != null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        StringValues.account_activated_text,
                        style: TextStyle(
                            color: Color(ColorValues.grey_light_header),
                            fontSize: 16.0),
                      ),
                    ),
              SizedBox(
                height: 25.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      width: 0.2,
                      color: Color(ColorValues.unselected_tab_text_color)),
                ),
                elevation: 1,
                child: InkWell(
                  onTap: () {
                    _navigateToBusinessDetails();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: new AssetImage(
                                  "assets/dashboard/baddress.png"),
                              width: 54.0,
                              height: 54.0,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text(
                              StringValues.Text_Business_Adress,
                              style: TextStyle(
                                color: Color(ColorValues.black),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image(
                            image: new AssetImage(
                              bussinessAddress == null
                                  ? "assets/dashboard/pink_arrow.png"
                                  : "assets/images/pink_tick.png",
                            ),
                            width: 18.0,
                            height: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      width: 0.2,
                      color: Color(ColorValues.unselected_tab_text_color)),
                ),
                elevation: 1,
                child: InkWell(
                  onTap: () {
                   _navigateToBankingDetails();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: new AssetImage(
                                  "assets/dashboard/bdetail.png"),
                              width: 54.0,
                              height: 54.0,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text(
                              StringValues.Text_Banking_Details,
                              style: TextStyle(
                                color: Color(ColorValues.black),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image(
                            image: new AssetImage(
                              bankingDetails == null
                                  ? "assets/dashboard/blue_arroe.png"
                                  : "assets/images/blue_tick.png",
                            ),
                            width: 18.0,
                            height: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      width: 0.2,
                      color: Color(ColorValues.unselected_tab_text_color)),
                ),
                elevation: 1,
                child: new InkWell(
                  onTap: () {
                    operationalHours == null
                        /*? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OperationPage()),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateOperationalPage(
                                    userId, operationListUpdate)),
                          );*/

                    ? _navigateToOperationalHours()
                    : _navigateToEditOperationalHours();

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: new AssetImage(
                                  "assets/dashboard/operation.png"),
                              width: 54.0,
                              height: 54.0,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text(
                              StringValues.Text_Operational_Hours,
                              style: TextStyle(
                                color: Color(ColorValues.black),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image(
                            image: new AssetImage(
                              operationalHours == null
                                  ? "assets/dashboard/yellow_arrow.png"
                                  : "assets/images/yellow_tick.png",
                            ),
                            width: 18.0,
                            height: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              bussinessAddress != null &&
                      bankingDetails != null &&
                      operationalHours != null
                  ? isAdminApproved
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/congrates.png",
                              height: 80,
                              width: 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${StringValues.text_congrats}",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              //padding: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Center(
                                child: Text(
                                  "${StringValues.account_active_text}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(ColorValues.orangeLight)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                  width: 250.0,
                                  height: 50.0,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Color(
                                                ColorValues.accentColor))),
                                    onPressed: () {
                                      print("Login....");
                                      callChangeNewLoginStatus();
                                    },
                                    color: Color(ColorValues.accentColor),
                                    textColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                          "${StringValues.text_Start_Business}"
                                              .toUpperCase(),
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/thankyou.png",
                              height: 30,
                              width: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${StringValues.text_thank}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Center(
                                child: Text(
                                  "${StringValues.detail_thank}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(ColorValues.grey_light)),
                                ),
                              ),
                            ),
                          ],
                        )
                  : bussinessAddress == null &&
                          bankingDetails == null &&
                          operationalHours == null
                      ? Container()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/check_mark.png",
                              height: 30,
                              width: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Center(
                                child: Text(
                                  "${StringValues.complete_rest_details}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(
                                        ColorValues.text_complete_deatils),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<RequestResourceData>> callGetAllRequestForPA() async {
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
    //http://3.7.49.123:8711/user/user/deliveryAgent/profileForRequest/{daId}
    String dataURL = Constants.BASE_URL + Constants.allRequestForPA;
    dataURL = dataURL + "/$userId";

    print("get PA request detail URL::: $dataURL");
    try {
      http.Response response = await http.get(dataURL,
          //headers: headers, body: jsonParam);
          headers: headers);
      //if (!mounted) return;
      print("response::: ${response.body}");
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      PackageDataResoponse apiResponse =
          new PackageDataResoponse.fromJson(jsonResponseMap);

      if (response.statusCode == 200) {
        print("statusCode 200....");
        if (apiResponse.status == 200) {
          clearAllListData();

          allRequest = apiResponse.resourceData;
          for (int i = 0; i < allRequest.length; i++) {
            if (allRequest[i].deliveryLabel == Constants.OUTGOING){
              allOutgoingRequest.add(allRequest[i]);
            }
            else if (allRequest[i].deliveryLabel == Constants.INCOMING) {
              allIncomingRequest.add(allRequest[i]);
            }
            if(allRequest[i].currentLocation == null)
              allCustomerRequest.add(allRequest[i]);
            else if(allRequest[i].currentLocation == StringValues.OPC)
              allOPCRequest.add(allRequest[i]);
            else if(allRequest[i].currentLocation == StringValues.DA)
              allDARequest.add(allRequest[i]);
            else if(allRequest[i].currentLocation == StringValues.DPC)
              allDPCRequest.add(allRequest[i]);

            if(allCustomerRequest != null){
              print('Customer allCustomerRequest size:: ${allCustomerRequest.length}');
              //print('Customer allCustomerRequest requestId ${allCustomerRequest[0].requestId}');
            }
            if(allOPCRequest != null){
              print('OPC allOPCRequest size:: ${allOPCRequest.length}');
            }

            if(allDARequest != null){
              print('DA allDARequest size:: ${allDARequest.length}');
            }
            if(allDPCRequest != null){
              print('DPC allDPCRequest size:: ${allDPCRequest.length}');
            }


            if(allIncomingRequest != null){
              print('allIncomingRequest size:: ${allIncomingRequest.length}');
            }

            if(allOutgoingRequest != null){
              print('allOutgoingRequest size:: ${allOutgoingRequest.length}');
            }


              print('allRequest size:: ${allRequest.length}');

          }
          return apiResponse.resourceData;
        } else {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else {
        //_isSubmitPressed = false;
        print("statusCode error....");
        if (jsonResponseMap.containsKey("error")) {
          if (apiResponse.error == StringValues.invalidateToken) {
            Toast.show('${StringValues.sessionExpired}', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            new Utils().callLogout(context);
          } else {
            Toast.show(apiResponse.error, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        } else {
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
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
    }
    return null;
  }

  void getrequestType() {
    setState(() {
      if (requestType == StringValues.outgoingPackages) {
        requestType = StringValues.incomingPackages;
        deliveredBgColor = Color(ColorValues.white);
        deliveredTextColor = Color(ColorValues.primaryColor);
        cancelledBgColor = Color(ColorValues.primaryColor);
        cancelledTextColor = Color(ColorValues.white);
      } else {
        requestType = StringValues.outgoingPackages;
        deliveredBgColor = Color(ColorValues.primaryColor);
        deliveredTextColor = Color(ColorValues.white);
        cancelledBgColor = Color(ColorValues.white);
        cancelledTextColor = Color(ColorValues.primaryColor);
      }
      _radioValue = _radioValue;
      print("requestType:: $requestType");
    });
  }

  Widget getRequestList(List<RequestResourceData> notiList) {
    if (notiList != null && notiList.length > 0) {
      return _myAdapterView(context, notiList);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 70.0,
          ),
          Image(
            image: new AssetImage('assets/images/sorry_no_data.png'),
            width: 40.0,
            height: 40.0,
            //fit: BoxFit.cover,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
            child: Text(
              requestType == StringValues.incomingPackages
                  ? StringValues.noPackage
                  : StringValues.noPackageDeliver,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(ColorValues.accentColor),
                  fontSize: 22.0,
                  fontFamily: StringValues.customSemiBold),
            ),
          ),
        ],
      );

      /* return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Text(
            requestType == StringValues.outgoingPackages
                ? '${StringValues.noOutgoingRequest}'
                : '${StringValues.noIncomingRequest}',
          ),
        ),
      );*/
    }
  }

  Widget _myAdapterView(
      BuildContext context, List<RequestResourceData> notiList) {

    return RefreshIndicator(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: notiList.length,
        itemBuilder: (context, index) {
      /*    if(notiList[index].currentLocation == null)
          return getCustomerRecord(index, notiList[index]);
          else if(notiList[index].currentLocation == StringValues.OPC)
            return getOPCRecord(index, notiList[index]);
          else if(notiList[index].currentLocation == StringValues.DA)
            return getDARecord(index, notiList[index]);
          else if(notiList[index].currentLocation == StringValues.DPC)
            return getDPCRecord(index, notiList[index]);*/
          if(requestType == StringValues.incomingPackages && _radioValue == 1)
            return getCustomerRecord(index, notiList[index]);
          else if(requestType == StringValues.outgoingPackages && _radioValue == 0)
            return getOPCRecord(index, notiList[index]);
          else if(requestType == StringValues.incomingPackages && _radioValue == 0)
            return getDARecord(index, notiList[index]);
          else if(requestType == StringValues.outgoingPackages && _radioValue == 1)
            return getDPCRecord(index, notiList[index]);
        },
      ),
      onRefresh: _getData,
    );
  }
  Future<void> _getData() async {
    setState(() {
      checkConnection();
    });
  }

  Widget getOPCRecord(int index, RequestResourceData data) {
    print('getOPCRecord request Id::: ${data.requestId}');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              side: BorderSide(
                  width: 0.2,
                  color: Color(ColorValues.unselected_tab_text_color)),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        print('Package detail');
                        /*_navigateToPackageDetails(
                            data.title, data.requestId, data.deliveryLabel);*/
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${Utils().firstLetterUpper(data.title)}',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(ColorValues.black)),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                              '${StringValues.pickupDate}${Utils().formatDateInMonthNameFullTime(data.pickupDate)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              '${StringValues.Expecteddateofpickup}${Utils().formatDateInMonthName(data.expectedPickupDate)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 16.0, top: 12.0),
                            child: Container(
                              height: 1.0,
                              color: Color(ColorValues.greyViewColor),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                   '${StringValues.Customer}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              Text(
                                '${Utils().firstLetterUpper(data.customerName)}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(ColorValues.grey_light),
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, top: 8.0),
                                child: Text(
                                   '${StringValues.DeliveryAgent}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              new RichText(
                                text: new TextSpan(
                                    text: '${Utils().firstLetterUpper(data.daName)} ',
                                    //style: underlineStyle.copyWith(decoration: TextDecoration.none),
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorValues.grey_light),
                                    ),
                                    children: [
                                      new TextSpan(
                                        text: '(${StringValues.id}${data.daId})',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorValues
                                                .greyTextColorLight)),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                      child: Container(
                        height: 1.0,
                        color: Color(ColorValues.greyViewColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _navigateToTracking(data.requestId,data.title);
                      },
                      child: Image.asset(
                        "assets/images/location_OPC.png",
                        //'assets/icons/drawer.png',
                        width: screenWidth - 32.0 - 30.0,
                        height: 45.0,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 24.0),
                      child: GestureDetector(
                        onTap: () async {
                          print('Recieve Package');
                          _navigateToOPCPackageDetails(data.title, data.requestId, data.deliveryLabel);
                        },
                        child: Container(
                          //width: 100.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                            color: Color(ColorValues.primaryColor),
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
                              '${StringValues.DeliverPackage}',
                              style: TextStyle(
                                color: Color(ColorValues
                                    .white), //Color(ColorValues.white)
                              ),
                            ),
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
        Container(
          height: 12.0,
        )
      ],
    );
  }
  Widget getDARecord(int index, RequestResourceData data) {
    print('getDARecord request Id::: ${data.requestId}');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              side: BorderSide(
                  width: 0.2,
                  color: Color(ColorValues.unselected_tab_text_color)),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        print('Package detail');
                        /*_navigateToPackageDetails(
                            data.title, data.requestId, data.deliveryLabel);*/
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //'${Utils().firstLetterUpper(data.title)}',
                            '${data.title}',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(ColorValues.black)),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                              '${StringValues.pickupDate}${Utils().formatDateInMonthNameFullTime(data.pickupDate)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              '${StringValues.Expecteddateofpickup}${Utils().formatDateInMonthName(data.expectedPickupDate)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 16.0, top: 12.0),
                            child: Container(
                              height: 1.0,
                              color: Color(ColorValues.greyViewColor),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                   '${StringValues.DeliveryAgent}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              Text(
                               '${Utils().firstLetterUpper(data.daName)}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(ColorValues.grey_light),
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, top: 8.0),
                                child: Text(
                                  '${StringValues.Receiver}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              new RichText(
                                text: new TextSpan(
                                    text:'${Utils().firstLetterUpper(data.receiverName)} ',
                                    //style: underlineStyle.copyWith(decoration: TextDecoration.none),
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorValues.grey_light),
                                    ),
                                    children: [
                                      new TextSpan(
                                        text:'(${StringValues.id}${data.receiverId})',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(ColorValues
                                                .greyTextColorLight)),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                      child: Container(
                        height: 1.0,
                        color: Color(ColorValues.greyViewColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _navigateToTracking(data.requestId,data.title);
                      },
                      child: Image.asset(
                        "assets/images/location_DA.png",
                        //'assets/icons/drawer.png',
                        width: screenWidth - 32.0 - 30.0,
                        height: 45.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 24.0),
                      child: GestureDetector(
                        onTap: () async {
                          print('Recieve Package');
                          _navigateToDAPackageDetails(data.title, data.requestId, data.deliveryLabel);
                        },
                        child: Container(
                          //width: 100.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                            color: Color(ColorValues.primaryColor),
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
                              '${StringValues.ReceivePackage}',
                              style: TextStyle(
                                color: Color(ColorValues
                                    .white), //Color(ColorValues.white)
                              ),
                            ),
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
        Container(
          height: 12.0,
        )
      ],
    );
  }
  Widget getDPCRecord(int index, RequestResourceData data) {
    print('getDPCRecord request Id::: ${data.requestId}');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              side: BorderSide(
                  width: 0.2,
                  color: Color(ColorValues.unselected_tab_text_color)),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        print('Package detail');
                        /*_navigateToPackageDetails(
                            data.title, data.requestId, data.deliveryLabel);*/
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${Utils().firstLetterUpper(data.title)}',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(ColorValues.black)),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text(
                              '${StringValues.SourceLabel}${Utils().firstLetterUpper(data.destinationPaBusinessName)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              '${StringValues.ExpecteddateofDelivery}${Utils().formatDateInMonthName(data.expectedPickupDate)}',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(ColorValues.helpTextColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 16.0, top: 12.0),
                            child: Container(
                              height: 1.0,
                              color: Color(ColorValues.greyViewColor),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '${StringValues.Customer}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              Text(
                                '${Utils().firstLetterUpper(data.customerName)}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(ColorValues.grey_light),
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, top: 8.0),
                                child: Text(
                                  '${StringValues.DocketNumber}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(ColorValues.grey_light_header),
                                  ),
                                ),
                              ),
                              Text(
                                '${data.docketNumber}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(ColorValues.grey_light),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                      child: Container(
                        height: 1.0,
                        color: Color(ColorValues.greyViewColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        print('location_DPC clicked');
                        _navigateToTracking(data.requestId,data.title);
                      },
                      child: Image.asset(
                        "assets/images/location_DPC.png",
                        //'assets/icons/drawer.png',
                        width: screenWidth - 32.0 - 30.0,
                        height: 45.0,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 24.0),
                      child: GestureDetector(
                        onTap: () async {
                          print('Recieve Package');
                          _navigateToDPCPackageDetails(data.title, data.requestId, data.deliveryLabel);
                        },
                        child: Container(
                          //width: 100.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                            color: Color(ColorValues.primaryColor),
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
                              '${StringValues.DeliverPackage}',
                              style: TextStyle(
                                color: Color(ColorValues
                                    .white), //Color(ColorValues.white)
                              ),
                            ),
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
        Container(
          height: 12.0,
        )
      ],
    );
  }

  Future _navigateToViewProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewProfile()),
    );
    getUserData();
  }

  Future _navigateToOperationalHours() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OperationPageNew()),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }

  Future _navigateToPackageDetails(
    String title,
    int requestId,
    String status,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PackageDetail(title, requestId, status)),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }
  Future _navigateToDPCPackageDetails(
    String title,
    int requestId,
    String status,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DPCPackageDetail(title, requestId, status)),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }
  Future _navigateToOPCPackageDetails(
    String title,
    int requestId,
    String status,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OPCPackageDetail(title, requestId, status)),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }
  Future _navigateToDAPackageDetails(
    String title,
    int requestId,
    String status,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DAPackageDetail(title, requestId, status)),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }

  callChangeNewLoginStatus() async {
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

    String dataURL = Constants.BASE_URL + Constants.newLoginStatus;
    dataURL = dataURL + "/$userId";

    print("get request cancel URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL, headers: headers);
      print("response::: ${response.body}");

      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      ResponsePodo apiResponse = new ResponsePodo.fromJson(jsonResponseMap);
      if (response.statusCode == 200) {
        print("statusCode 200....");

        if (apiResponse.status == 200) {
          print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
          SharedPreferencesHelper.setPrefBool(
              SharedPreferencesHelper.isNewLogin, false);
          setState(() {
            isNewLogin = false;
          });
          callGetAllRequestForPA();
        } else {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else {
        //_isSubmitPressed = false;
        print("statusCode error....");
        if (jsonResponseMap.containsKey("error")) {
          if (apiResponse.error == StringValues.invalidateToken) {
            Toast.show('${StringValues.sessionExpired}', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            new Utils().callLogout(context);
          } else {
            Toast.show(apiResponse.error, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        } else {
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

  Future getUserData() async {
    String name = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.NAME);
    userImageUrl = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.USER_IMAGE_URL);
    print('userImageUrl:: $userImageUrl');
    if (name != null) {
      setState(() {
        userName = Utils().firstLetterUpper(name);
        userImageUrl = userImageUrl;
      });
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      requestType=requestType;
      _isExpand = false;
    });
  }

  void clearAllListData() {
    allRequest.clear();
    allOutgoingRequest.clear();
    allIncomingRequest.clear();
    allCustomerRequest.clear();
    allOPCRequest.clear();
    allDARequest.clear();
    allDARequest.clear();
  }

  Widget getCustomerRecord(int index, RequestResourceData data) {
    print('getCustomerRecord request Id::: ${data.requestId}');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              side: BorderSide(
                  width: 0.2,
                  color: Color(ColorValues.unselected_tab_text_color)),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '${StringValues.packageId}${data.requestId}',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Color(ColorValues.black)),
                      ),
                    ),
                    Container(
                      //width: 130.0,
                      //height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        //color: Color(ColorValues.primaryColor),
                        //Color(ColorValues.primaryColor),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Color(ColorValues.radioTextColor),
                          width: 0.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      //elevation: 1,
                      child: Padding(padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                        child:  Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${data.customerName}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(
                                      ColorValues.grey_light),
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Image(
                              image: new AssetImage(
                                  'assets/images/call_img_green.png'),
                              width: 35.0,
                              height: 35.0,
                              //fit: BoxFit.fitHeight,
                            ),
                          ],
                        ),

                      ),
                    ),
                    /*Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20.0, top: 24.0),
                      child: Container(
                        height: 1.0,
                        color: Color(ColorValues.greyViewColor),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 24.0),
                      child: Dash(
                          direction: Axis.horizontal,
                          length: MediaQuery.of(context).size.width - 72,
                          dashLength: 8,
                          dashGap: 4,
                          //dashThickness: 0.5,
                          dashColor: Color(ColorValues.greyViewColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        '${StringValues.ETA}${Utils().formatDateInMonthName(data.pickupDate)} at ${Utils().formatTime(data.pickupTime)}',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(ColorValues.helpTextColor),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 32.0,bottom: 16.0),
                      child: GestureDetector(
                        onTap: () async {
                          print('Recieve Package');
                          _navigateToPackageDetails(
                              data.title, data.requestId, data.deliveryLabel);
                        },
                        child: Container(
                          //width: 100.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                            color: Color(ColorValues.primaryColor),
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
                              '${StringValues.START_RECEIVING}',
                              style: TextStyle(
                                color: Color(ColorValues
                                    .white), //Color(ColorValues.white)
                              ),
                            ),
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
        Container(
          height: 12.0,
        )
      ],
    );
  }

  Future _navigateToEditOperationalHours() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditOperationPageNew()),
    );
    if (result != null) {
      //refreshPage
      print('back from PackageDetails result:: $result');
      checkConnection();
    }
  }

  //PRIVATE METHOD TO HANDLE NAVIGATION TO SPECIFIC PAGE
  Future _navigateToChangePassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePassword()),
    );
  }

  Future _navigateToBankingDetails() async {
    bool isCallUpdate=false;
    if(bankingDetails == null){
      isCallUpdate=false;
    }else
      isCallUpdate=true;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BankingDetailPage(
              fullName,
              bankName,
              bankLocation,
              accountNumber,
              abaNumber,
              isCallUpdate)),
    );
    if (result != null) {
      //refreshPage
      print('back from bankDetail result:: $result');
      getInitialData();
    }
  }

  Future _navigateToBusinessDetails() async {
    bool isCallUpdate=false;
    if(bussinessAddress == null){
      isCallUpdate=false;
    }else
      isCallUpdate=true;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BusinessAddressPage(
              address,
              state,
              zipcode,
              city,
              aptNumber,
              country,
              isCallUpdate)),
    );
    /*bussinessAddress == null
        ? Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BusinessAddressPage(
              address,
              state,
              zipcode,
              city,
              aptNumber,
              country,
              false)),
    )
        : Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateBusinessPage(
              address,
              state,
              zipcode,
              city,
              aptNumber,
              country,
              true)),
    );*/
    if (result != null) {
      //refreshPage
      print('back from business result:: $result');
      getInitialData();
    }
  }

  Future _navigateToTracking(int requestId, String title) async {
    final resultData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrackingDetail(title, requestId)),
    );
    print('resultData:: $resultData');
    /*if(resultData as int == Constants.popScreen)
      Navigator.of(context).pop(Constants.popScreen);*/
  }

  Future _navigateToNotificationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowAllNotification()),
    );
  }

}
