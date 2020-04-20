import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:deliva/services/UserPreferences.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//BuildContext context;

class APICalling {
  // Post Method

  static Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply;
    print(response.statusCode);
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }

  static Future<String> apiPostWithHeaderRequest(
      String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    print(UserPreference.getAccessToken());
    request.headers.set('content-type', 'application/json');
    request.headers
        .set('accessToken', UserPreference.getAccessToken());
    request.add(utf8.encode(json.encode(jsonMap)));
    print(json.encode(jsonMap));
    HttpClientResponse response = await request.close();
    print(response.statusCode);
    // todo - you should check the response.statusCode
    String reply;

    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }

  static Future<String> getapiRequest(String url, String filename) async {
    HttpClient client = new HttpClient();
    var _downloadData = StringBuffer();
    var fileSave = new File(filename);
    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.listen((d) => _downloadData.write(d), onDone: () {
        fileSave.writeAsString(_downloadData.toString());
      });
    });
  }

  static Future<String> getapiRequestWithAccessToken(
      String url, BuildContext context) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('accessToken', UserPreference.getAccessToken());
     HttpClientResponse response = await request.close();

    print(response.statusCode);
    // todo - you should check the response.statusCode
    String reply;
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();

    }
    else if(response.statusCode==400||response.statusCode==401){


      reply = await response.transform(utf8.decoder).join();

    }
    else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }

  static Future<String> getapiRequestWithoutAccessToken(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply;
    print(response.statusCode);
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }

  static apiPostWithImageHeaderRequest(String url, File imageFile) async {
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    Map<String, String> headers = {
      "u_authentication_code": UserPreference.getAccessToken()
    };
    var length = await imageFile.length();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('u_image', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    return respStr;
  }

  static putapiRequestWithAcsessToken(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers
        .set('u_authentication_code', UserPreference.getAccessToken());
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply;

    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }


  static Future<String> apiDeleteWithHeaderRequest(
      String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers
        .set('u_authentication_code', UserPreference.getAccessToken());
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    print(response.statusCode);
    // todo - you should check the response.statusCode
    String reply;

    if (response.statusCode == 200) {
      print(response.statusCode);
      reply = await response.transform(utf8.decoder).join();
    } else {
      reply = "";
    }
    httpClient.close();
    return reply;
  }
}
