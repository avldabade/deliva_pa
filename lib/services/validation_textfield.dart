import 'package:deliva/values/StringValues.dart';

class Validation {
  //Email validation
  static String isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    if (regExp.hasMatch(em)) {
      
      return null;
    } else {
      return StringValues.ENTER_VALID_EMAIL;
    }
    //return regExp.hasMatch(em);
  }

//Mobile No validation
  static String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length < 10)
      return StringValues
          .ENTER_10_MOBILE_NO; //'Mobile Number must be of 10 digit or more';
    else
      return null;
  }

//name validation
  static String validateName(String value) {
    if (value.length < 3)
      return StringValues.ENTER_VALID_NAME;
    else
      return null;
  }

//address validation
  static String validateAddress(String value) {
    if (value.length < 3)
      return StringValues.ENTER_VALID_ADDRESS;
    else
      return null;
  }

//Password validation
  static String validatePassword(String password) {
    if (password.isEmpty || password == '') {
      return StringValues.ENTER_VALID_PASSWORD;
    } else if (password.length < 6) {
      return StringValues.ENTER_VALID_PASSWORD;
    } else
      return null;
  }

//confirm password validation
  static String validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword != null && confirmPassword == password) {
      return null;
    } else {
      return StringValues.PASSWORD_NOT_MATCH;
    }
  }

  //validation on dimen and weight inputs
  static String validateTextField(String fieldValue) {
    print('field name::  value:: $fieldValue');
    if (fieldValue.isEmpty || fieldValue == '') {
      return '${StringValues.ENTER_VALUE}';
    } else
      return null;
  }
}
