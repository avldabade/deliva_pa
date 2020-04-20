import 'package:deliva/values/ColorValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class Constants {
  static const String BASE_URL = "http://3.7.49.123:8711/";
  static const String BASE_URL_OLD = "http://103.76.253.133:8751/";
  //http://103.76.253.133:8751/userauth/oauth/token?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2
  static const String LOGIN_API = "userauth/oauth/token";
  static const String LOGIN_OTP_API = "userauth/public/sendLoginOtp";//userauth/public/sendLoginOtp?mobile=8878999959&countryCode=91&roleId=2
  static const String REGISTRATION_STEP1_API = "user/user/add/";
  static const String REGISTRATION_VERIFY_OTP_API = "user/user/verify/";
  static const String REGISTRATION_PROFILE_STEP2_API = "user/user/complete/customer/profile/";
  static const String FORGOT_PASSWORD_GET_OTP_API = "user/user/generateOtp";
  static const String FORGOT_PASSWORD_VERIFY_OTP_API = "user/user/validateOtp";
  static const String RESET_PASSWORD_API = "user/user/resetPassword";
  static const String PA_LOCATION_API = "request/deliveryRequest/getAllProcessingAgentByLocation";
  static const String CREATE_DELIVERY_REQ_API = "request/deliveryRequest/create";
  static const String MEDIA_UPLOAD_API = "request/deliveryRequest/mediaUrl/update";
  static const String MEDIA_UPLOAD_URL = "https://deliva-request-image-full.s3.amazonaws.com/";
  static const String MEDIA_UPLOAD_URL_WITH_REGION = "https://deliva-request-image-full.s3.us-east-2.amazonaws.com/";
  static const String AWS_BUCKET_NAME = "deliva-request-image-full";
  static const String AWS_REGION_NAME = "us-east-2";
  static const String CONTAINER_PREFIX = "dc_";
  static const String CONTAINER_DELIVERY_REQUEST = "deliveryRequest";

  static const int CUSTOMER_ROLE_ID  = 2;
  static const int DELIVERY_AGENT_ROLE_ID  = 3;
  static const int PROCESSING_AGENT_ROLE_ID  = 4;
  static const int ROLE_ID  = CUSTOMER_ROLE_ID;
  static const String loginByMobile  = "mobile";
  static const String loginByEmail  = "email";




  static const int SERVICE_TIME_OUT = 30000;

  static const int CONNECTION_TIME_OUT = 30000;

  static final String ERROR_LOGIN = "Please enter correct mobile no. and password";
  static final String TEXT_SERVER_EXCEPTION = 'Please try again in sometime';//'Somthing went wrong, Please try again later.';

}
