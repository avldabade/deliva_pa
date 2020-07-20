class LoginResponse {
  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;
  String scope;
  String name;
  String profileImageUrl;
  bool isRegistrationComplete;
  bool isActive;
  int userid;
  bool isProfileComplete;
  String jti;
  String error;
  String errorDescription;
  String awsAccessKeyId;
  String awsSecretAccessKey;

  bool isNewLogin;
  String countryCode;
  String mobile;

  LoginResponse(
      {this.accessToken,
        this.tokenType,
        this.refreshToken,
        this.expiresIn,
        this.scope,
        this.name,
        this.profileImageUrl,
        this.isRegistrationComplete,
        this.isActive,
        this.userid,
        this.isProfileComplete,
        this.jti,
        this.error,
        this.errorDescription,
        this.awsAccessKeyId,
        this.awsSecretAccessKey,
        this.isNewLogin,
        this.countryCode,
        this.mobile,
      });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
    isRegistrationComplete = json['isRegistrationComplete'];
    isActive = json['isActive'];
    userid = json['userid'];
    isProfileComplete = json['isProfileComplete'];
    jti = json['jti'];
    error = json['error'];
    errorDescription = json['error_description'];
    awsAccessKeyId = json['aws_access_key_id'];
    awsSecretAccessKey = json['aws_secret_access_key'];
    isNewLogin = json['isNewLogin'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    data['scope'] = this.scope;
    data['name'] = this.name;
    data['isRegistrationComplete'] = this.isRegistrationComplete;
    data['isActive'] = this.isActive;
    data['userid'] = this.userid;
    data['isProfileComplete'] = this.isProfileComplete;
    data['jti'] = this.jti;
    data['error'] = this.error;
    data['error_description'] = this.errorDescription;
    data['aws_access_key_id'] = this.awsAccessKeyId;
    data['aws_secret_access_key'] = this.awsSecretAccessKey;

    data['isNewLogin'] = this.isNewLogin;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    return data;
  }
}
