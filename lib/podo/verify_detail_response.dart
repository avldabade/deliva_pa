class VerifyDetailResponse {
  String responseMessage;
  int status;
  VerifyResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  VerifyDetailResponse(
      {this.responseMessage,
        this.status,
        this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  VerifyDetailResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new VerifyResourceData.fromJson(json['resourceData'])
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

class VerifyResourceData {
  int requestId;
  String title;
  double length;
  double width;
  double height;
  String dmUnit;
  double weight;
  String wtUnit;
  String dropOffDate;
  String mobile;

  VerifyResourceData(
      {this.requestId,
        this.title,
        this.length,
        this.width,
        this.height,
        this.dmUnit,
        this.weight,
        this.wtUnit,
        this.dropOffDate,
        this.mobile});

  VerifyResourceData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    title = json['title'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    dmUnit = json['dmUnit'];
    weight = json['weight'];
    wtUnit = json['wtUnit'];
    dropOffDate = json['dropOffDate'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['title'] = this.title;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['dmUnit'] = this.dmUnit;
    data['weight'] = this.weight;
    data['wtUnit'] = this.wtUnit;
    data['dropOffDate'] = this.dropOffDate;
    data['mobile'] = this.mobile;
    return data;
  }
}
