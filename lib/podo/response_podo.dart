class ResponsePodo {
  String responseMessage;
  int status;
  int resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  ResponsePodo(
      {this.responseMessage,
      this.status,
      this.resourceData,
      this.timestamp,
      this.error,
      this.message,
      this.path,
      this.errorDescription});

  ResponsePodo.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'];
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
    data['resourceData'] = this.resourceData;
    data['timestamp'] = this.timestamp;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    data['error_description'] = this.errorDescription;
    return data;
  }
}
