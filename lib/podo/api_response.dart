class APIResponse {
  String responseMessage;
  int status;
  ResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  APIResponse(
      {this.responseMessage,
        this.status,
        this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  APIResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new ResourceData.fromJson(json['resourceData'])
        : null;
    timestamp = json['timestamp'];
    error = json['error'];
    message = json['message'];
    path = json['path'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseMessage'] = this.responseMessage;
    data['status'] = this.status;
    if (this.resourceData != null) {
      data['resourceData'] = this.resourceData.toJson();
    }
    data['timestamp'] = this.timestamp;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    data['error_description'] = this.errorDescription;
    return data;
  }
}

class ResourceData {
  String isRegistrationComplete;
  String mobileNo;
  int userId;
  String countryCode;

  ResourceData(
      {this.isRegistrationComplete,
        this.mobileNo,
        this.userId,
        this.countryCode});

  ResourceData.fromJson(Map<String, dynamic> json) {
    isRegistrationComplete = json['isRegistrationComplete'];
    mobileNo = json['mobileNo'];
    userId = json['userId'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRegistrationComplete'] = this.isRegistrationComplete;
    data['mobileNo'] = this.mobileNo;
    data['userId'] = this.userId;
    data['countryCode'] = this.countryCode;
    return data;
  }
}
