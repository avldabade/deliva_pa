import 'package:deliva_pa/values/ColorValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class Constants {
  static const String BASE_URL_DEVELOPMENT = "http://103.76.253.133:8711/";
  static const String BASE_URL_QA = "http://3.7.49.123:8721/";
  static const String BASE_URL = BASE_URL_QA; //"http://3.7.49.123:8711/";
  static const String BASE_URL_OLD = "http://103.76.253.133:8751/";

  //apurva added
  static const String newLoginStatus = "user/user/newLoginStatus";
  static const String allRequestForPA = "request/deliveryRequest/getAllRequestForProcessingAgent";
  static const String cancelRequestAPI = "request/deliveryRequest/cancelRequest";
  static const String confirmPickupRequestAPI = "request/deliveryRequest/confirmPickup";
  static const String getPickupVerificationDetail = "request/deliveryRequest/getPickupVerificationDetail";
  static const String rejectPickup = "request/deliveryRequest/rejectPickup";
  static const String CHANGE_PASSWORD_API = "user/user/changePassword";
  static const String get_user_profile_info = "user/user/profile";
  static const String update_user_profile_info = "user/user/cutomer/profile/update";
  static const String USER_PROFILE_UPLOAD_URL = "http://user-profile-images.s3.us-east-2.amazonaws.com/";
  static const String AWS_USER_PROFILE_BUCKET_NAME = "user-profile-images";
  static const String GetDetailForPackageReceived = "request/deliveryRequest/GetDetailForPackageReceived";//http://103.76.253.133:8711/request/deliveryRequest/GetDetailForPackageReceived/11
  static const String verifyPickupForDA = "request/deliveryRequest/verifyPickup";//http://103.76.253.133:8711/request/deliveryRequest/verifyPickup/1234/1234
  static const String GET_PICKUP_VERIFICATION = "request/deliveryRequest/getPickupVerificationDetail";//http://3.7.49.123:8721/request/deliveryRequest/getPickupVerificationDetail/71
  static const String packageDelivered = "request/deliveryRequest/packageDelivered";//http://103.76.253.133:8711/request/deliveryRequest/packageDelivered/12345678
  static const String saveRecieverIdentificationDetail = "request/deliveryRequest/saveRecieverIdentificationDetail";//http://103.76.253.133:8711/request/deliveryRequest/packageDelivered/12345678
  static const String trackingRequestAPI = "request/deliveryRequest/getTrackingDetail";
//Notification API
  static const String get_all_notification = "user/notification";
  static const String requestHistoryAPI = "request/deliveryRequest/getAllRequestHistory";
  //rating API
  static const String rateUserAPI = "user/user/userRating";
  static const String getUserRatingAPI = "user/user/getUserRating";
  //help
  static const String getHelpAPI = "user/user/userHelp";
  //apurva added

  //http://103.76.253.133:8751/userauth/oauth/token?grant_type=password&username=1234567890&password=ZHVtbXkxMjM=&countryCode=91&roleId=2
  static const String LOGIN_API = "userauth/oauth/token";
  static const String LOGIN_OTP_API =
      "userauth/public/sendLoginOtp"; //userauth/public/sendLoginOtp?mobile=8878999959&countryCode=91&roleId=2
  static const String REGISTRATION_STEP1_API = "user/user/add/";
  static const String REGISTRATION_VERIFY_OTP_API = "user/user/verify/";
  static const String Get_profile = "user/user/profile";

  // static const String REGISTRATION_PROFILE_STEP2_API = "user/user/complete/customer/profile/";
  static const String REGISTRATION_PROFILE_STEP2_API =
      "user/user/register/processingAgent/profile/";
  static const String FORGOT_PASSWORD_GET_OTP_API = "user/user/generateOtp";
  static const String FORGOT_PASSWORD_VERIFY_OTP_API = "user/user/validateOtp";
  static const String RESET_PASSWORD_API = "user/user/resetPassword";
  static const String PA_LOCATION_API =
      "request/deliveryRequest/getAllProcessingAgentByLocation";
  static const String transactionHistoryAPI =
      "user/user/getAllTransactionHistory";

  //for delivery request listing
  static const String published_draft_delivery_request_API =
      "request/deliveryRequest/getAllRequestByCustomerStatus";
  static const String active_delivery_request_API =
      "request/deliveryRequest/getAllActiveRequest";
  static const String delivery_request_detail_API = "request/deliveryRequest/details";

  static const String CREATE_DELIVERY_REQ_API =
      "request/deliveryRequest/create";
  static const String MEDIA_UPLOAD_API =
      "request/deliveryRequest/mediaUrl/update";
  //static const String MEDIA_UPLOAD_URL = "https://deliva_pa-request-image-full.s3.amazonaws.com/";
  //static const String MEDIA_UPLOAD_URL_WITH_REGION = "https://deliva_pa-request-image-full.s3.us-east-2.amazonaws.com/";
  static const String MEDIA_UPLOAD_URL = "https://deliva-request-image-full.s3.amazonaws.com/";
  static const String MEDIA_UPLOAD_URL_WITH_REGION = "https://deliva-request-image-full.s3.us-east-2.amazonaws.com/";
  //https://deliva-request-image-full.s3.us-east-2.amazonaws.com/{requestId}/opc-images/{filename}
  static const String AWS_BUCKET_NAME = "deliva-request-image-full";
  static const String AWS_REGION_NAME = "us-east-2";
  static const String CONTAINER_PREFIX = "dc_";
  static const String CONTAINER_DELIVERY_REQUEST = "deliveryRequest";
  static const String Processing_Agent_SaveBankDetails =
      "user/user/processingAgent/saveBankDetails";
  static const String Processing_Agent_UPDATEBANKDETAIL =
      "user/user/processingAgent/editBankDetails";
  static const String Processing_Agent_SaveAdress =
      "user/user/processingAgent/saveAddress/";
  static const String Processing_Agent_UPDATEAdress =
      "user/user/processingAgent/editAddress/";

  static const String Operation_GET =
      "user/user/processingAgent/getOperationalHours";
  static const String SAVE_OPERATON =
      "user/user/processingAgent/saveOperationalHoursDetails/";
  static const String UPDATE_OPERATON =
      "user/user/processingAgent/editOperationalHoursDetails/";

  static const int CUSTOMER_ROLE_ID = 2;
  static const int DELIVERY_AGENT_ROLE_ID = 3;
  static const int PROCESSING_AGENT_ROLE_ID = 4;
  static const int ROLE_ID = PROCESSING_AGENT_ROLE_ID;
  static const String loginByMobile = "mobile";
  static const String loginByEmail = "email";

  static const int SERVICE_TIME_OUT = 30000;

  static const int CONNECTION_TIME_OUT = 30000;
  static const int OTP_TIMER = 300;//25sec now 5min(5x60=300)

  static final String ERROR_LOGIN =
      "Please enter correct mobile no. and password";
  static final String TEXT_SERVER_EXCEPTION = 'Please try again in sometime';

  static final int popScreen =
      1; //'Somthing went wrong, Please try again later.';
  static final int popSingleScreen =
      2; //'Somthing went wrong, Please try again later.';

  //request type
  static const String OUTGOING  = "OUTGOING";
  static const String INCOMING  = "INCOMING";

}
