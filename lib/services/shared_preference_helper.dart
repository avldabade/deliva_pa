

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
/*Login data*/
  static final String ACCESS_TOKEN = "access_token";
  static final String TOKEN_TYPE = "token_type";
  static final String REFRESH_TOKEN = "refresh_token";
  static final String EXPIRES_IN = "expires_in";
  static final String SCOPE = "scope";
  static final String NAME = "name";
  static final String IS_REGISTRATION_COMPLETE = "isRegistrationComplete";
  static final String IS_ACTIVE = "isActive";
  static final String USER_ID = "userid";
  static final String IS_PROFILE_COMPLETE = "isProfileComplete";
  static final String JIT = "jti";
  static final String mobileNo = "mobileNo";
  static final String countryCode = "countryCode";

  static final String _kLanguageCode = "language";
  static final String USER_EMAIL = "userEmail";
  static final String USER_PASSWORD = "userPassword";
  static final String IS_LOGGED_IN = "isLoggedin";
  static final String IS_LOGGED_OUT = "isLoggedOut";
  static final String POLES_DATA = "polesData";
  static final String USER_DATA = "userData";
  static final String USER_FNAME = "userFName";
  static final String USER_LNAME = "userLName";
  static final String TOKEN = "token";
  static final String APP_NAME = "appName";
  static final String APP_VERSION = "appVersion";
  static final String APP_BUILD_NUMBER = "appBuildNumber";
  static final String APP_PACKAGE_NAME = "appPackageName";
  static final String DEVICE_TOKEN = "deviceToken";
  static final String AWS_ACCESS_KEY = "aws_access_key_id";
  static final String AWS_SECRET_KEY = "aws_secret_access_key";
  static final String DELIVERY_ID = "delivery_requestId";



  /// ------------------------------------------------------------
  /// Method that returns the user language code, 'en' if not set
  /// ------------------------------------------------------------
  static Future<String> getPrefString(String keyName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
    //return prefs.getString(_kLanguageCode) ?? 'en';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user language code
  /// ----------------------------------------------------------
  static Future<bool> setPrefString(String keyName,String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(keyName, value);
  }

  static Future<int> getPrefInt(String keyName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyName);
    //return prefs.getString(_kLanguageCode) ?? 'en';
  }

  static Future<bool> setPrefInt(String keyName,int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(keyName, value);
  }

  static Future<bool> getPrefBool(String keyName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyName);
    //return prefs.getString(_kLanguageCode) ?? 'en';
  }

  static Future<bool> setPrefBool(String keyName,bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyName, value);
  }

  static removeKey(String keyName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyName);
    prefs.commit();
  }

  static Future<List<String>> getPrefStringList(String keyName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyName);
  }

  static Future<bool> setPrefStringList(String keyName,List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(keyName, value);
  }

  static Future<List<String>> getPolesData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(POLES_DATA);
  }

  static Future<bool> setPolesData(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(POLES_DATA, value);
  }
}
