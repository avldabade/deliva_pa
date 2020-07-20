import 'dart:convert';

import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

class ApiCalling {
  String userIdPref, token;
  Response response;
  BuildContext context;
  String uri;
  String type;

/*
  //========================================= Api Calling ============================
  Future<Response> apiCall2(context1,url,type) async {
    context = context1;
    response = await apiCallForUserProfile2(url,type);
    return response;
  }

  Future<Response> apiCallForUserProfile2(url,type) async {
    var isConnect = await Utils.isInternetConnected();
    if (isConnect) {
      try {


        var dio = new Dio();
        dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };

        dio.options.baseUrl = Constants.BASE_URL;
        dio.options.connectTimeout = Constants.CONNECTION_TIME_OUT; //5s
        dio.options.receiveTimeout = Constants.SERVICE_TIME_OUT;
        dio.options.headers = {'user-agent': 'dio'};
        dio.options.headers = {'Accept': 'application/json'};
        dio.options.headers = {'Content-Type': 'application/json'};
        dio.options.headers = {'Authorization': token}; // Prepare Data

        // Make API call
        if(type=='get') {
          response = await dio.get(url);
        }else{
          response = await dio.post(url);

        }
        print(response.toString());
        if (response.statusCode == 200) {
          String status = response.data[LoginResponseConstant.STATUS];

          if (status == "Success") {

            return response;
          } else {
            return response;
          }
        } else {
        //  CustomProgressLoader.cancelLoader(context);

          return response;
        }
      } catch (e) {
       // CustomProgressLoader.cancelLoader(context);
        print(e);
        return response;
      }
    } else {
      //CustomProgressLoader.cancelLoader(context);

      //ToastWrap.showToast(MessageConstant.CONNECTION_NOT_AVAILABLE_ERROR,context);
      return response;
    }
  }



  //========================================= Api Calling ============================
  Future<Response> apiCall(context1,url,type) async {
    context = context1;
    response = await apiCallForUserProfile(url,type);
    return response;
  }

  Future<Response> apiCallForUserProfile(url,type) async {
    var isConnect = await ConectionDetecter.isConnected();
    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userIdPref = prefs.getString(UserPreference.USER_ID);
        token = prefs.getString(UserPreference.USER_TOKEN);
        CustomProgressLoader.showLoader(context);
        var dio = new Dio();
        dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };

        dio.options.baseUrl = Constant.BASE_URL;
        dio.options.connectTimeout = Constant.CONNECTION_TIME_OUT; //5s
        dio.options.receiveTimeout = Constant.SERVICE_TIME_OUT;
        dio.options.headers = {'user-agent': 'dio'};
        dio.options.headers = {'Accept': 'application/json'};
        dio.options.headers = {'Content-Type': 'application/json'};
        dio.options.headers = {'Authorization': token}; // Prepare Data

        // Make API call
        if(type=='get') {
          response = await dio.get(url);
        }else{
          response = await dio.post(url);

        }
        CustomProgressLoader.cancelLoader(context);
        print(response.toString());
        if (response.statusCode == 200) {
          String status = response.data[LoginResponseConstant.STATUS];

          if (status == "Success") {

            return response;
          } else {
            return response;
          }
        } else {
        //  CustomProgressLoader.cancelLoader(context);

          return response;
        }
      } catch (e) {
        CustomProgressLoader.cancelLoader(context);
        print(e);
        return response;
      }
    } else {
    //  CustomProgressLoader.cancelLoader(context);

      ToastWrap.showToast(MessageConstant.CONNECTION_NOT_AVAILABLE_ERROR,context);
      return response;
    }
  }


  //============================================Api Calling post with Param ===============================

  Future<Response> apiCallPostWithMapData(context1,url,map) async {
    context = context1;
    response = await apiCallPost(url,map);
    return response;
  }

  Future<Response> apiCallPost(url,map) async {
    var isConnect = await ConectionDetecter.isConnected();
    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userIdPref = prefs.getString(UserPreference.USER_ID);
        token = prefs.getString(UserPreference.USER_TOKEN);
        CustomProgressLoader.showLoader(context);
        var dio = new Dio();
        dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };

        dio.options.baseUrl = Constant.BASE_URL;
        dio.options.connectTimeout = Constant.CONNECTION_TIME_OUT; //5s
        dio.options.receiveTimeout = Constant.SERVICE_TIME_OUT;
        dio.options.headers = {'user-agent': 'dio'};
        dio.options.headers = {'Accept': 'application/json'};
        dio.options.headers = {'Content-Type': 'application/json'};
        dio.options.headers = {'Authorization': token}; // Prepare Data


          response = await dio.post(url,data: json.encode(map));

print("response:-"+response.toString());
        CustomProgressLoader.cancelLoader(context);
        print(response.toString());
        if (response.statusCode == 200) {
          String status = response.data[LoginResponseConstant.STATUS];

          if (status == "Success") {

            return response;
          } else {
            return response;
          }
        } else {
          //CustomProgressLoader.cancelLoader(context);

          return response;
        }
      } catch (e) {
        CustomProgressLoader.cancelLoader(context);
        print(e);
        return response;
      }
    } else {
      //CustomProgressLoader.cancelLoader(context);

      ToastWrap.showToast(MessageConstant.CONNECTION_NOT_AVAILABLE_ERROR,context);
      return response;
    }
  }


  //============================================Api Calling put with Param ===============================

  Future<Response> apiCallPutWithMapData(context1,url,map) async {
    context = context1;
    response = await apiCallPut(url,map);
    return response;
  }

  Future<Response> apiCallPut(url,map) async {
    var isConnect = await ConectionDetecter.isConnected();
    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userIdPref = prefs.getString(UserPreference.USER_ID);
        token = prefs.getString(UserPreference.USER_TOKEN);
        CustomProgressLoader.showLoader(context);
        var dio = new Dio();
        dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };

        dio.options.baseUrl = Constant.BASE_URL;
        dio.options.connectTimeout = Constant.CONNECTION_TIME_OUT; //5s
        dio.options.receiveTimeout = Constant.SERVICE_TIME_OUT;
        dio.options.headers = {'user-agent': 'dio'};
        dio.options.headers = {'Accept': 'application/json'};
        dio.options.headers = {'Content-Type': 'application/json'};
        dio.options.headers = {'Authorization': token}; // Prepare Data


        response = await dio.put(url,data: json.encode(map));

        print("response:-"+response.toString());
        CustomProgressLoader.cancelLoader(context);
        print(response.toString());
        if (response.statusCode == 200) {
          String status = response.data[LoginResponseConstant.STATUS];

          if (status == "Success") {

            return response;
          } else {
            return response;
          }
        } else {
         // CustomProgressLoader.cancelLoader(context);

          return response;
        }
      } catch (e) {
        CustomProgressLoader.cancelLoader(context);
        print(e);
        return response;
      }
    } else {
     // CustomProgressLoader.cancelLoader(context);

      ToastWrap.showToast(MessageConstant.CONNECTION_NOT_AVAILABLE_ERROR,context);
      return response;
    }
  }



  //============================================Api Calling Delete with Param ===============================

  Future<Response> apiCallDeleteWithMapData(context1,url,map) async {
    context = context1;
    response = await apiCallDelete(url,map);
    return response;
  }

  Future<Response> apiCallDelete(url,map) async {
    var isConnect = await ConectionDetecter.isConnected();
    if (isConnect) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userIdPref = prefs.getString(UserPreference.USER_ID);
        token = prefs.getString(UserPreference.USER_TOKEN);
        CustomProgressLoader.showLoader(context);
        var dio = new Dio();
        dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };

        dio.options.baseUrl = Constant.BASE_URL;
        dio.options.connectTimeout = Constant.CONNECTION_TIME_OUT; //5s
        dio.options.receiveTimeout = Constant.SERVICE_TIME_OUT;
        dio.options.headers = {'user-agent': 'dio'};
        dio.options.headers = {'Accept': 'application/json'};
        dio.options.headers = {'Content-Type': 'application/json'};
        dio.options.headers = {'Authorization': token}; // Prepare Data


        response = await dio.delete(url,data: json.encode(map));

        print("response:-"+response.toString());
        CustomProgressLoader.cancelLoader(context);
        print(response.toString());
        if (response.statusCode == 200) {
          String status = response.data[LoginResponseConstant.STATUS];

          if (status == "Success") {

            return response;
          } else {
            return response;
          }
        } else {
       //   CustomProgressLoader.cancelLoader(context);

          return response;
        }
      } catch (e) {
        CustomProgressLoader.cancelLoader(context);
        print(e);
        return response;
      }
    } else {
    //  CustomProgressLoader.cancelLoader(context);

      //ToastWrap.showToast(MessageConstant.CONNECTION_NOT_AVAILABLE_ERROR,context);
      return response;
    }
  }*/

}
