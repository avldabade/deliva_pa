class NotificationResponse {
  String responseMessage;
  int status;
  List<NotificationResourceData> resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;


  NotificationResponse({this.responseMessage, this.status, this.resourceData,
    this.timestamp,
    this.error,
    this.message,
    this.path,
    this.errorDescription});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    if (json['resourceData'] != null) {
      resourceData = new List<NotificationResourceData>();
      json['resourceData'].forEach((v) {
        resourceData.add(new NotificationResourceData.fromJson(v));
      });
    }
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
      data['resourceData'] = this.resourceData.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    data['error_description'] = this.errorDescription;
    return data;
  }
}

class NotificationResourceData {
  int notificationId;
  String notification;
  String notifictionAction;
  String dateTime;
  bool read;

  NotificationResourceData(
      {this.notificationId,
        this.notification,
        this.notifictionAction,
        this.dateTime,
        this.read});

  NotificationResourceData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    notification = json['notification'];
    notifictionAction = json['notifictionAction'];
    dateTime = json['dateTime'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    data['notification'] = this.notification;
    data['notifictionAction'] = this.notifictionAction;
    data['dateTime'] = this.dateTime;
    data['read'] = this.read;
    return data;
  }
}
