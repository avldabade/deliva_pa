import 'dart:convert';
import 'dart:io';
import 'package:deliva_pa/forgot_password/forgot_otp.dart';
import 'package:deliva_pa/home_screen/dashboard.dart';
import 'package:deliva_pa/podo/api_response.dart';
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
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../constants/Constant.dart';
import '../services/number_text_input_formator.dart';

class BankingDetailPage extends StatefulWidget {
  String fullName='',bankName='',bankLocation='',accountNumber='',abaNumber='';
  bool apiCall;
  BankingDetailPage(this.fullName,this.bankName,this.bankLocation,this.accountNumber,this.abaNumber,this.apiCall);
  @override
  BankingDetailPageState createState() =>
      BankingDetailPageState();
}

class BankingDetailPageState
    extends State<BankingDetailPage> {

  bool _isInProgress = false;
  bool _isSubmitPressed = false;
  bool _autoValidate = false;

  bool isFullNameError = false;
  final fullNameController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  String fullName;

  bool isSelectBankError = false;
  final selectBankController = TextEditingController();
  final FocusNodeselectBankFocus = FocusNode();
  String selectBank;

  bool isBankLocationError = false;
  final bankLocationController = TextEditingController();
  final FocusNode bankLocationFocus = FocusNode();
  String bankLocation;

  bool isAccountNumberError = false;
  final accountNumberController = TextEditingController();
  final FocusNode accountNumberFocus = FocusNode();
  String accountNumber;

  bool isABANumberError = false;
  final abaNumberController = TextEditingController();
  final FocusNode abaNumberFocus = FocusNode();
  String abaNumber;




  bool hasError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String banktext = StringValues.selectBank;

  String bankBlank = '';

  List<String> bankList = [
    StringValues.selectBank,
    "HDFC","ICICI","SBI","BOI","AXIS"
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameController.text=widget.fullName==""?"":widget.fullName;
    selectBankController.text=widget.bankName==""?"":widget.bankName;
    bankLocationController.text=widget.bankLocation==""?"":widget.bankLocation;
    accountNumberController.text=widget.accountNumber==""?"":widget.accountNumber;
    abaNumberController.text=widget.abaNumber==""?"":widget.abaNumber;
    banktext=widget.bankName==""?StringValues.selectBank:widget.bankName;
    print('widget.apiCall:: ${widget.apiCall}');
  }

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

                  Utils().commonAppBar(StringValues.Text_Banking_Detail,context),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(24.0),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        isFullNameError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                fullNameController,

                                                keyboardType:
                                                TextInputType.text,

                                                //to block space character
                                                textInputAction:
                                                TextInputAction.next,

                                                decoration: InputDecoration(
                                                  helperText: ' ',
                                                  //labelText: StringValues.TEXT_PASSWORD,
                                                  //contentPadding: EdgeInsets.only(top:16.0,left:0.0),
                                                  //errorStyle: TextStyle(),
                                                  prefixIcon: /*Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: new Image.asset(
                                                            "assets/bankingDetail/fullname.png"),
                                                      ),
                                                    ),
                                                  ),*/

                                                  Container(
                                                    width: 0,
                                                    height: 0,
                                                    alignment: Alignment(-0.99, 0.0),
                                                    child: Image.asset("assets/bankingDetail/fullname.png",width: 22,),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Full_Name,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateFullName(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isFullNameError = true;
                                                  else
                                                    isFullNameError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateFullName(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isFullNameError = true;
                                                  else
                                                    isFullNameError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  fullName = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*Stack(
                                      children: <Widget>[
                                        isSelectBankError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                selectBankController,

                                                keyboardType:
                                                TextInputType.text,

                                                //to block space character
                                                textInputAction:
                                                TextInputAction.next,
                                                decoration: InputDecoration(
                                                  helperText: ' ',
                                                  //labelText: StringValues.TEXT_PASSWORD,
                                                  //contentPadding: EdgeInsets.all(0.0),
                                                  //errorStyle: TextStyle(),
                                                  prefixIcon: *//*Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: new Image.asset(
                                                            "assets/bankingDetail/bank.png"),
                                                      ),
                                                    ),
                                                  ),*//*
                                                  Container(
                                                    width: 0,
                                                    height: 0,
                                                    alignment: Alignment(-0.99, 0.0),
                                                    child: Image.asset("assets/bankingDetail/bank.png",width: 22,),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  *//* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*//*
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Select_Bank,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  *//*errorText:
                                                                                submitFlag ? _validateEmail() : null,*//*
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateSelectBank(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isSelectBankError = true;
                                                  else
                                                    isSelectBankError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateSelectBank(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isSelectBankError = true;
                                                  else
                                                    isSelectBankError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  selectBank = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),*/

                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 0.0,
                                          bottom: 2.0,
                                          child: Visibility(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:5.0),
                                                child: Text(
                                                  "${StringValues.Validate_Select_Bank}",
                                                  style: TextStyle(color: Color(ColorValues.error_red),fontSize: 12.0),
                                                ),
                                              ),
                                            ),
                                            visible: isSelectBankError,
                                          ),
                                        ),
                                        isSelectBankError
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 0.0,
                                          //top: 1.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Padding(
                                          padding: const EdgeInsets.only(top:28.0,left: 0.0),
                                          child: Image.asset(

                                            'assets/bankingDetail/bank.png',height: 22.0,width: 22.0,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 14.0),
                                          child: SizedBox(
                                            height: 65.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: banktext,

                                                    icon: Padding(
                                                      padding: const EdgeInsets.only(right:8.0),
                                                      child: Image(
                                                  image: new AssetImage(
                                                        'assets/images/down_expanded_arrow.png'),
                                                  width: 16.0,
                                                  height: 16.0,
                                                  //fit: BoxFit.fitHeight,
                                                ),
                                                    ),
                                                    /*icon: Icon(
                                                    Icons.keyboard_arrow_down),*/
                                                    iconSize: 30,
                                                    elevation: 1,
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                        color: Color(ColorValues.text_view_hint),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal,
                                                        fontStyle: FontStyle.normal),
                                                    /* underline: Container(
                                                  height: 2,
                                                  color: Colors.transparent,
                                                ),*/
                                                    onChanged: (String data) {
                                                      setState(() {
                                                        bankBlank = banktext;
                                                        banktext = data;
                                                        if(banktext != "bank")
                                                          isSelectBankError = false;
                                                        else
                                                          isSelectBankError = true;
                                                        // callWeightValueConverter();
                                                      });
                                                    },
                                                    items: bankList.map<
                                                        DropdownMenuItem<
                                                            String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:48.0,right: 8.0),
                                                            child: Text(value,style: TextStyle(
                                                                color: bankBlank==""? Color(ColorValues.text_view_hint):Colors.black,fontSize: 15),
                                                            ),)
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                Container(height: 1.0,color: isSelectBankError?Color(ColorValues.error_red): Color(ColorValues.text_view_hint),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),



                                    Stack(
                                      children: <Widget>[
                                        isBankLocationError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                bankLocationController,

                                                keyboardType:
                                                TextInputType.text,

                                                //to block space character
                                                textInputAction:
                                                TextInputAction.next,
                                                decoration: InputDecoration(
                                                  helperText: ' ',
                                                  //labelText: StringValues.TEXT_PASSWORD,
                                                  //contentPadding: EdgeInsets.all(0.0),
                                                  //errorStyle: TextStyle(),
                                                  prefixIcon: /*Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: new Image.asset(
                                                            "assets/bankingDetail/banklocation.png"),
                                                      ),
                                                    ),
                                                  ),*/
                                                  Container(
                                                    width: 0,
                                                    height: 0,
                                                    alignment: Alignment(-0.99, 0.0),
                                                    child: Image.asset("assets/bankingDetail/banklocation.png",width: 22,),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_Bank_Location,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateBankLocation(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isBankLocationError = true;
                                                  else
                                                    isBankLocationError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateBankLocation(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isBankLocationError = true;
                                                  else
                                                    isBankLocationError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  bankLocation = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        isAccountNumberError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                accountNumberController,

                                                keyboardType:
                                                TextInputType.text,
                                                inputFormatters: [
                                                  BlacklistingTextInputFormatter(
                                                      new RegExp('[\\ ]'))
                                                ],
                                                //to block space character
                                                textInputAction:
                                                TextInputAction.next,
                                                decoration: InputDecoration(
                                                  helperText: ' ',
                                                  //labelText: StringValues.TEXT_PASSWORD,
                                                  //contentPadding: EdgeInsets.all(0.0),
                                                  //errorStyle: TextStyle(),
                                                  prefixIcon: /*Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: new Image.asset(
                                                            "assets/bankingDetail/account.png"),
                                                      ),
                                                    ),
                                                  ),*/
                                                  Container(
                                                    width: 0,
                                                    height: 0,
                                                    alignment: Alignment(-0.99, 0.0),
                                                    child: Image.asset("assets/bankingDetail/account.png",width: 22,),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_AccountNumber,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateAccountNumber(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isAccountNumberError = true;
                                                  else
                                                    isAccountNumberError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateAccountNumber(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isAccountNumberError = true;
                                                  else
                                                    isAccountNumberError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  accountNumber = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        isABANumberError && _autoValidate
                                            ? Positioned(
                                          right: 0.0,
                                          bottom: 2.0,
                                          //alignment: Alignment.bottomRight,
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/error_icon_red.png'),
                                            width: 17.0,
                                            height: 17.0,
                                            //fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Color(
                                                ColorValues.text_view_theme),
                                            inputDecorationTheme:
                                            new InputDecorationTheme(
                                              contentPadding:
                                              new EdgeInsets
                                                  .only(
                                                  top: 16.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14.0),
                                            child: SizedBox(
                                              height: 65.0,
                                              child: TextFormField(
                                                controller:
                                                abaNumberController,

                                                keyboardType:
                                                TextInputType.text,
                                                inputFormatters: [
                                                  BlacklistingTextInputFormatter(
                                                      new RegExp('[\\ ]'))
                                                ],
                                                //to block space character
                                                textInputAction:
                                                TextInputAction.next,
                                                decoration: InputDecoration(
                                                  helperText: ' ',
                                                  //labelText: StringValues.TEXT_PASSWORD,
                                                  //contentPadding: EdgeInsets.all(0.0),
                                                  //errorStyle: TextStyle(),
                                                  prefixIcon: /*Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: new Image.asset(
                                                            "assets/bankingDetail/abanumber.png"),
                                                      ),
                                                    ),
                                                  ),*/
                                                  Container(
                                                    width: 0,
                                                    height: 0,
                                                    alignment: Alignment(-0.99, 0.0),
                                                    child: Image.asset("assets/bankingDetail/abanumber.png",width: 22,),
                                                  ),
                                                  //icon: Icon(Icons.lock_outline),
                                                  /* suffixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 0.0),
                                                    child: Transform.scale(
                                                      scale: 0.65,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: Image.asset(
                                                            'assets/identificationIcon/drop.png'),
                                                      ),
                                                    ),
                                                  ),*/
                                                  counterText: '',
                                                  hintText:
                                                  StringValues.Text_ABA_Number,
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                  /*errorText:
                                                                                submitFlag ? _validateEmail() : null,*/
                                                ),

                                                validator: (String arg) {
                                                  String val = Validation
                                                      .validateABANumber(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isABANumberError = true;
                                                  else
                                                    isABANumberError = false;
                                                  //});
                                                  return val;
                                                },
                                                onChanged: (String arg) {
                                                  String val = Validation
                                                      .validateABANumber(arg);
                                                  //setState(() {
                                                  if (val != null)
                                                    isABANumberError = true;
                                                  else
                                                    isABANumberError = false;
                                                  //});
                                                  setState(() {
                                                  });
                                                },

                                                onSaved: (value) {
                                                  abaNumber = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(height:40.0),

                                    Center(
                                      child: SizedBox(
                                        width: 250.0,
                                        height: 52.0,
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(
                                                  30.0),
                                              side: BorderSide(
                                                  color: Color(
                                                      ColorValues
                                                          .accentColor))),
                                          onPressed: () {
                                            print("Login....");
                                            //  validateLogin();
                                            validateDetail();
                                          },
                                          color: Color(ColorValues
                                              .accentColor),
                                          textColor: Colors.white,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(10.0),
                                            child: Text(
                                               widget.apiCall?"SAVE": StringValues
                                                    .TEXT_SUBMIT
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 20)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
  void _validateInputs() {
    if (_formKey.currentState.validate() && banktext!=StringValues.selectBank) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //Toast.show("All feild are valid....", context, duration: Toast.LENGTH_LONG);
    widget.apiCall? updateBankingDetailApiCall():saveBankingDetailApiCall();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
        if(banktext == StringValues.selectBank){
          isSelectBankError = true;
        }
      });
      _isSubmitPressed = false;
      //Toast.show("Some feilds are not valid....", context, duration: Toast.LENGTH_LONG);
    }
  }
  Future validateDetail() async {
    if (!_isSubmitPressed) {
      try {
        print("press");
        _isSubmitPressed = true;
        FocusScope.of(context).requestFocus(new FocusNode());
        bool isConnected = await Utils.isInternetConnected();
        if (isConnected) {
          print("validate details");
          _validateInputs();
        } else {
          _isSubmitPressed = false;
          //Utils.showGreenSnackBar(StringValues.INTERNET_ERROR, scaffoldKey);
          Toast.show(StringValues.INTERNET_ERROR, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } catch (exception) {
        print('exception is: ${exception}');
      }
    }
  }
  void saveBankingDetailApiCall() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    print("call api");
    setState(() {
      _isInProgress = true;
    });
    int userId=await SharedPreferencesHelper.getPrefInt(SharedPreferencesHelper.USER_ID);
    print(userId);

    Map<String, dynamic> requestJson = {
      "abaNumber": abaNumberController.text,
      "accountNumber": accountNumberController.text,
      "bankLocation": bankLocationController.text,
      //"bankName": selectBankController.text,
      "bankName": banktext,
      "fullName": fullNameController.text,
      "userId": userId
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
    String dataURL =
        Constants.BASE_URL + Constants.Processing_Agent_SaveBankDetails;
    print("Profile URL::: $dataURL");
    try {
      http.Response response = await http.post(dataURL,
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
        if (apiResponse.resourceData == null && apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("Submit Sucesfull!!!");
          Navigator.pop(context,'refresh');
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (jsonResponseMap.containsKey("error")){
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
  void updateBankingDetailApiCall() async {
    //print("callGetOtpApi.... \n_mobileNo:: $_mobileNo  \nmobileNo::: $mobileNo");
    print("call api");
    setState(() {
      _isInProgress = true;
    });
    int userId=await SharedPreferencesHelper.getPrefInt(SharedPreferencesHelper.USER_ID);
    print(userId);

    Map<String, dynamic> requestJson = {
      "abaNumber": abaNumberController.text,
      "accountNumber": accountNumberController.text,
      "bankLocation": bankLocationController.text,
      //"bankName": selectBankController.text,
      "bankName": banktext,
      "fullName": fullNameController.text,
      "userId": userId
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
    String dataURL =
        Constants.BASE_URL + Constants.Processing_Agent_UPDATEBANKDETAIL;
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
        if (apiResponse.resourceData == null && apiResponse.status == 200) {
          //.isRegistrationComplete == "false"){
          //_navigateToRegistrationOtp();
          print("Submit Sucesfull!!!");
          Navigator.pop(context,'refresh');
        } else if (apiResponse.status == 500) {
          print(apiResponse.message);
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else if (apiResponse.status == 500) {
        print(apiResponse.message);
        Toast.show("${apiResponse.message}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (jsonResponseMap.containsKey("error")){
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
}
