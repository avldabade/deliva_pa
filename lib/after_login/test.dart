
import 'package:country_code_picker/country_code_picker.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormDemo extends StatefulWidget {
  @override
  _TextFormDemoState createState() => _TextFormDemoState();
}

class _TextFormDemoState extends State<TextFormDemo> {
  var _countryCode;

  bool isError=false;

  String _mobileNo;
  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    var code = countryCode.toString().split("+");
    //print("Country selected: " + code[1]);
    _countryCode = code[1];
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 40.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Demo",style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),
              TextFormField(
                decoration: InputDecoration(
                    //icon: Icon(Icons.print),
                    prefixIcon: Icon(Icons.print),

                    enabled: true,
                    //labelText: 'demo text',

                    prefix: CountryCodePicker(
                      onChanged:
                      _onCountryChange,
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection:
                      'IN',
                      favorite: [
                        'IN',
                        '+39',
                        'FR'
                      ],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      showFlag: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed:
                      false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                      padding:
                      EdgeInsets.all(0),
                    //  flagWidth: 25.0,
                      //Get the country information relevant to the initial selection
                      onInit: (code) {
                        print(
                            "on init ${code} ${code.name} ${code.dialCode}");
                        var codeA = code
                            .dialCode
                            .split("+");
                        print(
                            "Country on init: " +
                                codeA[1]);
                        _countryCode =
                        codeA[1];
                      },
                    ),
                    hintText: "Demo Text",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, ),
                    //decoration: InputDecoration.collapsed(hintText: ""),//to remove underline
                    //border:OutlineInputBorder(),

                ),
             /*   onChanged: (text) {
                  // DEFINE YOUR RULES HERE
                  setState(() {
                    text.contains("1")
                        ? isError = true
                        : isError = false;
                  });
                },*/
              ),
              isError ? Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.error,
                  color: Color(Colors.red.value),
                ),
              ):Container(),
              TextFormField(
                //controller: mobileNoController,
                //focusNode: _mobileNoFocus,

                keyboardType:
                TextInputType
                    .phone,
                maxLength: 13,
                inputFormatters: [
                  WhitelistingTextInputFormatter
                      .digitsOnly,
                  //to block space character
                  BlacklistingTextInputFormatter(
                      new RegExp(
                          '[\\ ]'))
                  // Fit the validating format.
                  //_phoneNumberFormatter,
                ],

                textInputAction:
                TextInputAction
                    .done,

                //autofocus: true,
                decoration:
                InputDecoration(
                  counterText: '',
                  labelText: StringValues
                      .TEXT_MOBILE_NO,
                  hintText: StringValues
                      .TEXT_MOBILE_NO,

                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  /*errorText:
                                                                            submitFlag ? _validateEmail() : null,*/
                ),
                /*onFieldSubmitted:
                    (value) {
                  _mobileNoFocus
                      .unfocus();
                  validateLogin();
                },*/
                validator: Validation
                    .validateMobile,
                onSaved: (value) {
                  _mobileNo = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

import 'package:flutter/material.dart';

class TextFormDemo extends StatefulWidget {
  TextFormDemo({Key key}) : super(key: key);

  //final String title;

  @override
  _TextFormDemoState createState() => _TextFormDemoState();
}

class _TextFormDemoState extends State<TextFormDemo> {
  ErrorIcon _errorWidget = new ErrorIcon(false);

  set errorWidget(ErrorIcon value) {
    setState(() {
      _errorWidget = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuilding main widget");

    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: Center(
        child: Padding(
          //Add padding around textfield
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (text) {
                  // DEFINE YOUR RULES HERE
                  text.contains("1")
                      ? errorWidget = new ErrorIcon(true)
                      : errorWidget = new ErrorIcon(false);
                },
                decoration: InputDecoration(
                  hintText: "Enter Username",
                  icon: _errorWidget,
                ),
                //hintText: "Demo Text",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.error,
                  color: Color(Colors.red.value),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}

class ErrorIcon extends StatelessWidget {
  bool _isError;

  ErrorIcon(this._isError);

  bool get isError => _isError;

  @override
  Widget build(BuildContext context) {
    Widget out;

    debugPrint("Rebuilding ErrorWidget");
    isError
        ? out = new Icon(
      Icons.error,
      color: Color(Colors.red.value),
    )
        : out = new Icon(null);

    return out;
  }
}*/
