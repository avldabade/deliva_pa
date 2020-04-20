import 'dart:convert';

import 'package:deliva/login/login.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';



class UserPreference {
  static SharedPreferences prefs;
  static const String USER_ID = 'userId';
  static const String LOGIN_STATUS = 'loginStatus';
  static const String ACCESS_TOKEN = 'accessToken';
  static const String SURVEY_ID = 'SurveyId';


  static Future initSharedPreference () async {
    prefs = await SharedPreferences.getInstance();
  }

  static void initBoolData () {
    setLoginStatus(false);
  }

  static void setUserId (String userId) {
    prefs.setString(USER_ID, userId);
  }

  static String getUserId () {
    return prefs.getString(USER_ID);
  }
  static void setSurveyId (String SurveyId) {
    prefs.setString(SURVEY_ID, SurveyId);
  }

  static String getSurveyId () {
    return prefs.getString(SURVEY_ID);
  }
  static void setLoginStatus (bool status) {
    prefs.setBool(LOGIN_STATUS, status);
  }

  static bool getLoginStatus () {
    return prefs.getBool(LOGIN_STATUS);
  }



  static void setAccessToken (String token) {
    prefs.setString(ACCESS_TOKEN, token);
  }

  static String getAccessToken () {
    return prefs.getString(ACCESS_TOKEN);
  }


  static void logout(BuildContext context) {
    Navigator.pop(context);
    setLoginStatus(false);
    print("lllooooogggooouutt");
    // makeLogOutApiCall(context);
    clearPreference();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  static void clearPreference() {
    prefs.clear();
  }


}
