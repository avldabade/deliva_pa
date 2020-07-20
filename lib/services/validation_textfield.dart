import 'package:deliva_pa/values/StringValues.dart';

class Validation {
  //Email validation
  static String isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    if(em != null && em !='') {
      if (regExp.hasMatch(em)) {
        return null;
      } else {
        return StringValues.ENTER_VALID_EMAIL;
      }
    }
    return StringValues.ENTER_EMAIL;
  }

//Mobile No validation
  static String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value != null && value != '') {
      if (value.length < 12)
        return StringValues
            .ENTER_VALID_MOBILE_NO; //'Mobile Number must be of 10 digit or more';
      else
        return null;
    }
    return StringValues
        .ENTER_MOBILE;
  }

//name validation
  static String validateName(String value) {
    if (value.length <= 0)
      return StringValues.ENTER_VALID_NAME;
    else
      return null;
  }

//address validation
  static String validateAddress(String value) {
    if (value.length <= 0)
      return StringValues.ENTER_VALID_ADDRESS;
    else
      return null;
  }

//Password validation
  static String validatePassword(String password) {
    if (password.isEmpty || password == '') {
      return StringValues.ENTER_PASSWORD;
    } else
    if (password.length < 6) {
      return StringValues.ENTER_VALID_PASSWORD;
    } else
      return null;
  }
  static String validateNewPassword(String password) {
    if (password.isEmpty || password == '') {
      return StringValues.ENTER_NEW_PASSWORD;
    } else if (password.length < 6) {
      return StringValues.ENTER_VALID_PASSWORD;
    } else
      return null;
  }
  static String validateOldPassword(String password) {
    if (password.isEmpty || password == '') {
      return StringValues.ENTER_old_PASSWORD;
    } else if (password.length < 6) {
      return StringValues.ENTER_VALID_PASSWORD;
    } else
      return null;
  }
  static String validateCardNo(String cardNo) {
    if (cardNo.isEmpty || cardNo == '') {
      return StringValues.enterCardNo;
    } else if (cardNo.length < 16) {
      return StringValues.enterValidCardNo;
    } else
      return null;
  }
  static String validateCVV(String cvv) {
    if (cvv.isEmpty || cvv == '') {
      return StringValues.enterCvv;
    } else if (cvv.length < 3) {
      return StringValues.enterValidCvv;
    } else
      return null;
  }
  static String validateYearMonth(int year, int month) {
    DateTime dateTime=DateTime.now();
    int yearC=dateTime.year;
    int monthC=dateTime.month;

    /*if (year < yearC) {
      return StringValues.enterGreaterYear;
    } else if (monthC < month) {
      return StringValues.enterGreaterMonth;
    } else
      return null;*/

    print('yearC:: $yearC   year:: $year');
    print('monthC:: $monthC   month:: $month');
    if (year < yearC) {
      //return StringValues.enterGreaterYear;
      return StringValues.enterValidDate;
    }else if ((month < monthC && year == yearC) || month>12) {
      //return StringValues.enterGreaterMonth;
      return StringValues.enterValidDate;
    }
    else
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
  static String validateSecretCodeTextField(String fieldValue) {
    print('field name::  value:: $fieldValue');
    if (fieldValue.isEmpty || fieldValue == '') {
      return '${StringValues.codeErrorMsg}';
    } else if (fieldValue.length < 4) {
      return '${StringValues.codeValidErrorMsg}';
    }else
      return null;
  }
  static String validateDimenTextField(String fieldValue) {
    print('field name::  value:: $fieldValue');

    if (fieldValue.isEmpty || fieldValue == '') {
      return '${StringValues.ENTER_VALUE}';
    }else if (double.parse(fieldValue) == 0) {
      return '${StringValues.ENTER_NONZERO_VALUE}';
    } else
      return null;
  }
  static String validateNumber(String value) {
    if (value.isEmpty)
      return "${StringValues.enterRegNo}";
    else if (value.length < 3)
      return "${StringValues.enterValidRegNo}";
    else
      return null;
  }

  ///////Business Adress location
  static String validateLocation(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Location;
    }  else
      return null;
  }
  ///////Business Adress apartment
  static String validateAppartment(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Apartment;
    }  else
      return null;
  }
  ///////Business Adress State
  static String validateState(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Statet;
    }  else
      return null;
  }
  ///////Business Adress zip code
  static String validateZipCode(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_ZipCode;
    }  else
      return null;
  }
  ///////Business Adress Country
  static String validateCountry(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Country;
    }  else
      return null;
  }
  static String validateCity(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_City;
    }  else
      return null;
  }

  ///////Banking Detail Full Name
  static String validateFullName(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Full_NAme;
    }  else
      return null;
  }
  ///////Banking Detail Select bank
  static String validateSelectBank(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Select_Bank;
    }  else
      return null;
  }
  ///////Banking Detail bank location
  static String validateBankLocation(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Bank_Location;
    }  else
      return null;
  }
  ///////Banking Detail account number
  static String validateAccountNumber(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_Account_Number;
    }  else
      return null;
  }
  ///////Banking Detail ABA Number
  static String validateABANumber(String value) {
    if (value.isEmpty || value == '') {
      return StringValues.Validate_ABA_Number;
    }  else
      return null;
  }
}
