import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';

class TextViewClass{

  /*final confirmPassword = TextFormField(
    controller: widget.confirmPasswordController,
    obscureText: true,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
      hintText: 'Confirm Password',
      errorText: validatePassword(widget.confirmPasswordController.text),
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    ),
  );*/

  /*final emailText=Stack(
    children: <Widget>[
      Positioned(
        top:0,
        left: 0,
        child: Text(StringValues.TEXT_EMAIL,style: TextStyle(color: Color(ColorValues.primaryColor),fontSize: 17.0),),),
      isEmailError ? Positioned(
        right: 0.0,
        bottom: 5.0,
        //alignment: Alignment.bottomRight,
        child: Image(
          image: new AssetImage(
              'assets/images/error_icon_red.png'),
          width: 16.0,
          height: 16.0,
          //fit: BoxFit.fitHeight,
        ),
      ):Container(),
      Theme(
        data: Theme.of(context)
            .copyWith(primaryColor: Color(ColorValues.text_view_theme),),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextFormField(
            controller:
            emailController,
            focusNode:
            _emailFocus,
            keyboardType:
            TextInputType
                .emailAddress,
            textInputAction:
            TextInputAction
                .next,

            //autofocus: true,
            decoration:
            InputDecoration(
              //contentPadding: EdgeInsets.all(0.0),

              prefixIcon:
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Transform.scale(
                  scale: 0.65,
                  child: IconButton(
                    onPressed: (){},
                    icon: new Image.asset("assets/images/email_icon.png"),
                  ),
                ),
              ),
              //icon: Icon(Icons.lock_outline),
              counterText: '',
              //labelText: StringValues.TEXT_EMAIL,
              hintText: StringValues
                  .TEXT_EMAIL,
              //border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              *//*errorText:
                                                                              submitFlag ? _validateEmail() : null,*//*
            ),

            onFieldSubmitted:
                (_) {
              Utils.fieldFocusChange(
                  context,
                  _emailFocus,
                  _passwordFocus);
            },
            validator: (String arg) {
              String val=Validation.isEmail(arg);
              //setState(() {
              if(val != null)
                isEmailError=true;
              else
                isEmailError=false;
              //});
              return val;
            },
            onSaved: (value) {
              //print('email value:: $value');
              _email = value;
            },

          ),
        ),
      ),
    ],
  );*/

}