import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:async/async.dart';
import 'package:deliva_pa/constants/Constant.dart';
import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:deliva_pa/delivery_request/aws_policy_helper.dart';

import 'package:deliva_pa/podo/PickupVerificationModel.dart';
import 'package:deliva_pa/podo/api_response.dart';
import 'package:deliva_pa/podo/delivery_request_response.dart';
import 'package:deliva_pa/podo/pa_location_response.dart';
import 'package:deliva_pa/podo/verify_detail_response.dart';
import 'package:deliva_pa/services/common_widgets.dart';
import 'package:deliva_pa/services/image_picker_class.dart';
import 'package:deliva_pa/services/shared_preference_helper.dart';
import 'package:deliva_pa/services/utils.dart';
import 'package:deliva_pa/services/validation_textfield.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

//import 'package:aws_client/aws_client.dart';
import 'package:toast/toast.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

class DAVerifyPackageDetail extends StatefulWidget {
  final String title;
  final int requestId;

  DAVerifyPackageDetail(this.title, this.requestId, {Key key})
      : super(key: key);

  @override
  _DAVerifyPackageDetailState createState() => _DAVerifyPackageDetailState();
}

class _DAVerifyPackageDetailState extends State<DAVerifyPackageDetail> {
  bool _isInProgress = false;
  bool _isSubmitPressed = false;

  bool _checkConditionOk = false;
  bool _showImage = false;
  bool _confirmCheck = false;
  PickUpVerificationResponseData _data ;
  final commentController = TextEditingController();
  final secretCodeController = TextEditingController();
  int pinLength = 4; bool hasError = false;
  int status;
  String docketNumberData="";

  int i;
  List<MediaUrl> mediaUrls =new List();

  bool _isExpand=true;
  List<File> imageList = new List();
  List<String> imageUrlList = new List();
  File _imagePath;

  String dropOffDate='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
    _data=await callPickupVerificationApi();
    print(_data);
    docketNumberData=_data.docketNumber;
    dropOffDate=Utils().formatDateInMonthNameTime(_data.dropOffDate);
    setState(() {
      docketNumberData;
    });
    mediaUrls= parseMediaUrlList(_data.mediaUrls);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(ColorValues.white),
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Material(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Utils().commonAppBar(widget.title,context),

                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets.bottom),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /*Container(
                                      height: 107.0,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 22.0),
                                              child: Text(
                                                StringValues.DocketNumber,
                                                style: TextStyle(
                                                    color: Color(ColorValues
                                                        .grey_light_header),
                                                    fontSize: 18.0,
                                                    fontFamily:
                                                    "customRegular"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(docketNumberData.toString(),
                                                // _data.docketNumber.toString()==""?"1234":_data.docketNumber.toString(),
                                                style: TextStyle(
                                                  color:
                                                  Color(ColorValues.black),
                                                  fontSize: 22.0,
                                                  //  fontFamily: "customLight"
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),*/
                                    Container(
                                      height: 16.0,
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, right: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${StringValues.date}$dropOffDate',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Color(
                                                            ColorValues.helpTextColor)),
                                                  ),
                                                  SizedBox(
                                                    width: 33.0,
                                                    height: 33.0,
                                                    child: new IconButton(
                                                      onPressed: _toggleDropDown,
                                                      icon: Image.asset(_isExpand
                                                          ? 'assets/images/up_expanded_arrow.png'
                                                          : 'assets/images/down_expanded_arrow.png'),
                                                      //color:Color(ColorValues.accentColor),
                                                      //iconSize: 24.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ), //

                                            _isExpand
                                                ? Container(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    vertical: 12.0,
                                                    horizontal:
                                                    12.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Container(
                                                      color: Color(ColorValues
                                                          .unselected_tab_text_color),
                                                      height: 1.0,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 22.0,bottom: 16.0),
                                                      child: Text(
                                                        StringValues.PackageImages,
                                                        style: TextStyle(
                                                            color: Color(
                                                                ColorValues.grey_light_header),
                                                            fontSize: 18.0,
                                                            fontFamily: "customRegular"),
                                                      ),
                                                    ),
                                                    mediaUrls.length==0 ?Container(child: Padding(
                                                      padding: const EdgeInsets.only(top: 22.0,bottom: 30),
                                                      child: Text(
                                                        "No Image Available",
                                                        style: TextStyle(
                                                            color: Color(
                                                                ColorValues.grey_light_text),
                                                            fontSize: 18.0,
                                                            fontFamily: "customRegular"),
                                                      ),
                                                    ),):
                                                    new Container(
                                                        margin: EdgeInsets.only(
                                                            left: 18,right: 18,top: 5),
                                                        //height: MediaQuery.of(context).size.height / 2.0,
                                                        height: 250,
                                                        child: GridView.count(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 0.0,
                                                          crossAxisSpacing: 0.0,
                                                          children: List.generate(mediaUrls.length
                                                              , (index) {i=index;
                                                              return Container(
                                                                  //margin: EdgeInsets.only(top: 5),
                                                                  child: Column(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                                                        child: Image.network(
                                                                          mediaUrls[index].thumbnailUrl350X350,
                                                                          fit: BoxFit.fill,
                                                                          width: 100,
                                                                          height: 80,
                                                                        ),
                                                                      ),
                                                                      buildImageTag(mediaUrls[index].mediaCode),
                                                                    ],
                                                                  ));
                                                              }),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            /* _imagePath = await ImagePickerUtility.getImageFromGallery();
                                          setState(() {
                                            _imagePath=_imagePath;
                                          });*/
                                            if (imageList.length < 5) {
                                              //
                                              //
                                              //
                                              // (context);

                                              final ImageSelectionAction action =
                                              await new CustomAlertDialog()
                                                  .getImageSelectorAlertDialog(
                                                  context);
                                              print("Image Action::: $action");
                                              if (action ==
                                                  ImageSelectionAction.GALLERY) {
                                                _imagePath =
                                                await ImagePickerUtility
                                                    .getImageFromGallery();
                                                if (imageList == null)
                                                  imageList = new List();
                                                if (_imagePath != null) {
                                                  setState(() {
                                                    imageList.add(_imagePath);
                                                  });
                                                }
                                                print(
                                                    'imageList size:: ${imageList.length}');
                                              } else if (action ==
                                                  ImageSelectionAction.CAMERA) {
                                                _imagePath =
                                                await ImagePickerUtility
                                                    .getImageFromCamera();
                                                if (imageList == null)
                                                  imageList = new List();
                                                if (_imagePath != null) {
                                                  setState(() {
                                                    imageList.add(_imagePath);
                                                  });
                                                }
                                                print(
                                                    'imageList size:: ${imageList.length}');
                                              }
                                            } else
                                              Toast.show(
                                                  "${StringValues.maxImageLimit}",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.BOTTOM);
                                          },
                                          child: Image(
                                            image: new AssetImage(
                                                'assets/images/add_package.png'),
                                            width: 95.0,
                                            height: 95.0,
                                            //fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          width: 8.0,
                                        ),
                                        /*_imagePath == null
                                          ? Text('No image selected.')
                                          : Image.file(
                                              _imagePath,
                                              width: 95.0,
                                              height: 95.0,
                                            ),*/
                                        Expanded(
                                          child: new Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            height: 95.0,
                                            child: imageList != null
                                                ? ListView.builder(
                                              //physics: NeverScrollableScrollPhysics(),
                                              scrollDirection:
                                              Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: imageList.length,
                                              itemBuilder:
                                                  (context, index) {
                                                return getRecord(index,
                                                    imageList[index]);
                                              },
                                            )
                                                : Container(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 8.0,
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        print('Confirm clicked');
                                        _validateInputs();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0, vertical: 16.0),
                                        child: Center(
                                          child: Container(
                                            //width: screenWidth * 0.6,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              borderRadius: new BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                              color:
                                              Color(ColorValues.primaryColor),
                                              //Color(ColorValues.primaryColor),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(
                                                    ColorValues.primaryColor),
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Center(
                                                child: Text(
                                                  StringValues.CONFIRM_PACKAGE,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),




                                  ],
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
      ),
    );


  }
  Widget buildImageTag(String mediaCode){

    if (mediaCode == "CUST"){
      return  Container(
        height: 20,
        width: 100,
        decoration: BoxDecoration(
            color: Color(0xffFFF6E0),
            borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0),
            )
        ),
        child: Center(child: Text("Captured by Customer",style: TextStyle(fontSize: 10,color: Color( 0xff6C6C6C)),)),
      );
    }

    if (mediaCode == "PA_OPC_PRODUCT"){
      return  Container(
        height: 20,
        width: 100,
        decoration: BoxDecoration(
            color: Color(0xffFFF6E0),
            borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0),
            )
        ),
        child: Center(child: Text("Captured by OPC",style: TextStyle(fontSize: 10,color: Color( 0xff6C6C6C)),)),
      );
    }

    if (mediaCode == "PA_OPC_PACKAGE"){
      return  Container(
        height: 20,
        width: 100,
        decoration: BoxDecoration(
            color: Color(0xffFFF6E0),
            borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(5.0),
              bottomRight: const Radius.circular(5.0),
            )
        ),
        child: Center(child: Text("Captured by OPC",style: TextStyle(fontSize: 10,color: Color( 0xff6C6C6C)),)),
      );
    }

  }



  static List<MediaUrl> parseMediaUrlList(map) {
    List<MediaUrl> tagList = new List<MediaUrl>();

    if(map != null){
      for (int i = 0; i < map.length; i++) {
        String thumbnailUrl350X350 = map[i]['thumbnailUrl350X350'].toString();
        String originalMediaUrl = map[i]['originalMediaUrl'].toString();
        String thumbnailUrl80X80 = map[i]['thumbnailUrl80X80'].toString();
        String mediaCode = map[i]['mediaCode'].toString();
        tagList.add(new MediaUrl(thumbnailUrl350X350,originalMediaUrl,thumbnailUrl80X80,mediaCode));
        //tagList.add(new MediaUrl(thumbnailUrl350X350,originalMediaUrl,thumbnailUrl80X80,mediaCode));
      }
    }
    return tagList;
  }
  Future<PickUpVerificationResponseData> callPickupVerificationApi() async {
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
    String dataURL = Constants.BASE_URL + Constants.GET_PICKUP_VERIFICATION;
    dataURL = dataURL +"/${widget.requestId}";

    print("get agent detail URL::: $dataURL");
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

      PickUpVerificationResponse apiResponse =
      new PickUpVerificationResponse.fromJson(jsonResponseMap);

      if (response.statusCode == 200) {
        print("statusCode 200....");
        if (apiResponse.status == 200) {
          return apiResponse.resourceData;
        } else {
          Toast.show("${apiResponse.responseMessage}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
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
    } catch (Exception) {
      print("Exception:...... $Exception");
      setState(() {
        _isInProgress = false;
      });
    }
    return _data;
  }



  void _toggleDropDown() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  Widget getRecord(int index, File imageListFile) {
    return Container(
      //color: Colors.black,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 8.0, bottom: 5.0),
            child:
            /*Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png")
                    )
                ),
              width: 95.0,
              height: 95.0,
              child: Image.file(
                imageListFile,
                //width: 95.0,
                //height: 95.0,
                fit: BoxFit.fill,
              ),
            ),*/
            Container(
              //padding: EdgeInsets.all(30.0),
                width: 95.0,
                height: 95.0,
                //color: Colors.red,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.file(
                    imageListFile,
                    //width: 95.0,
                    //height: 95.0,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageList.removeAt(index);
                });
              },
              child: Image(
                image: new AssetImage('assets/images/img_cross_icon.png'),
                width: 20.0,
                height: 20.0,
                //fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _validateInputs() {
      if (imageList != null && imageList.length > 0) {
        uploadAllImagesOnAws();
      } else {
        Toast.show(StringValues.TEXT_SELECT_package_IMAGES, context,
            duration: Toast.LENGTH_LONG);
        _isSubmitPressed = false;
      }
  }
  Future uploadAllImagesOnAws() async {
    setState(() {
      _isInProgress = true;
    });
    for (int i = 0; i < imageList.length; i++) {
      String imageUrl = await getUploadUrlFromAWS(imageList[i]);
      imageUrlList.add(imageUrl);
      print('imageUrlList $i :: $imageUrlList');
    }
    if (imageUrlList != null && imageUrlList.length > 0) {
      callVerifyRequestAPI();
    }
  }
  Future<String> getUploadUrlFromAWS(File imageList) async {
    String uploadedImageUrl = '';
    String awsAccessKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_ACCESS_KEY);
    awsAccessKey = Utils.decodeStringFromBase64(awsAccessKey);
    String awsSecretKey = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.AWS_SECRET_KEY);
    awsSecretKey = Utils.decodeStringFromBase64(awsSecretKey);

    print('awsSecretKey::: $awsSecretKey');
    print('awsAccessKey::: $awsAccessKey');

    const _region = 'us-east-2'; //'ap-southeast-1';
    const _s3Endpoint = Constants.MEDIA_UPLOAD_URL_WITH_REGION;
    //'https://bucketname.s3-ap-southeast-1.amazonaws.com';

    final file = imageList;
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    /*final policy = Policy.fromS3PresignedPost('uploaded/square-cinnamon.jpg',
        'bucketname', awsAccessKey, 15, length,
        region: _region);*/

    String imageNameNew = await Utils.getFileNameWithExtension(_imagePath);
    final policy = Policy.fromS3PresignedPost(
        '${widget.requestId}/${StringValues.daImageFolderName}/${imageNameNew}',
        Constants.AWS_BUCKET_NAME,
        awsAccessKey,
        15,
        length,
        region: _region);

    final key =
    SigV4.calculateSigningKey(awsSecretKey, policy.datetime, _region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());
    req.files.add(multipartFile);

    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();
      print('uploaded images response:: $res');
      print('response status::: ${res.statusCode}');
      if (res.statusCode == 204) {
        //Toast.show(StringValues.imageUploadSuccess, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //https://deliva-request-image-full.s3.us-east-2.amazonaws.com/{requestId}/dpc-images/{filename}
        uploadedImageUrl =
        '${Constants.MEDIA_UPLOAD_URL_WITH_REGION}${widget.requestId}/${StringValues.daImageFolderName}/${imageNameNew}';
        print('uploaded images uploadedImageUrl:: $uploadedImageUrl');
        return uploadedImageUrl;
      }
    } catch (e) {
      print('exception::: ${e.toString()}');
      return uploadedImageUrl;
    }
    return uploadedImageUrl;
  }

  void callVerifyRequestAPI() async {
    //if (!mounted) return;
    String access_token = await SharedPreferencesHelper.getPrefString(
        SharedPreferencesHelper.ACCESS_TOKEN);
    int userId = await SharedPreferencesHelper.getPrefInt(
        SharedPreferencesHelper.USER_ID);

    Map<String, dynamic> requestJson = {
      //"dimOk": _checkedDimenValue,
      //"fragile": _checkedFragileValue,
      "imageCode": "string",
      "matched": true,
      "mediaUrl": imageUrlList,
      "packageOk": true,
      "requestId": widget.requestId,
      "userId": userId,
      //"weightOk": _checkedWeightValue,
      //"weight": weightController.text,
      //"wtUnit": weightUnit
      //"mediaUrlDetail": urlJsonList,
    };
    print("requestJson::: ${requestJson}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $access_token'
    };
    String dataURL = Constants.BASE_URL + Constants.confirmPickupRequestAPI;
    print("Add URL::: $dataURL");
    try {
      http.Response response = await http.put(dataURL,
          headers: headers, body: json.encode(requestJson));

      print("response::: ${response.body}");

      _isSubmitPressed = false;
      setState(() {
        _isInProgress = false;
      });
      final Map jsonResponseMap = json.decode(response.body);
      print('jsonResponse::::: ${jsonResponseMap.toString()}');
      APIResponse apiResponse = new APIResponse.fromJson(jsonResponseMap);

      if (response.statusCode == 200) {
        print("statusCode 200....");
        print("apiResponse.responseMessage:: ${apiResponse.responseMessage}");
        if (apiResponse.status == 200) {
          print("${apiResponse.message}");
          //Toast.show("${apiResponse.message}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          String alertMsg = '${StringValues.PackageReceived}';
          int backResult = 2;

          final OKButtonSelection okAction = await new CustomAlertDialog()
              .getOKAlertDialog(
              context,
              alertMsg,
              "",
              'assets/images/like_orange.png');

          if (okAction == OKButtonSelection.OK) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/dashboard', (Route<dynamic> route) => false);
          }

          //_showDeliverySuccessAlet();
        } else if (apiResponse.status == 404) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        } else if (apiResponse.status == 500) {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //_navigateToLogin();
        } else {
          print("${apiResponse.message}");
          Toast.show("${apiResponse.message}", context,
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
