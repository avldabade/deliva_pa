class DeliveryRequestResponse {
  String responseMessage;
  int status;
  ResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;

  DeliveryRequestResponse(
      {this.responseMessage, this.status, this.resourceData,this.timestamp, this.error, this.message, this.path});

  DeliveryRequestResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new ResourceData.fromJson(json['resourceData'])
        : null;
    timestamp = json['timestamp'];
    error = json['error'];
    message = json['message'];
    path = json['path'];
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
    return data;
  }
}

class ResourceData {
  int requestId;

  ResourceData({this.requestId});

  ResourceData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    return data;
  }
}
