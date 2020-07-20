class PAOperationalHours {
  String responseMessage;
  int status;
  OperationalResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  PAOperationalHours({this.responseMessage, this.status, this.resourceData,
    this.timestamp,
    this.error,
    this.message,
    this.path,
    this.errorDescription});

  PAOperationalHours.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new OperationalResourceData.fromJson(json['resourceData'])
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

class OperationalResourceData {
  bool allDays;
  String allStartTime;
  String allEndTime;
  List<Days> days;

  OperationalResourceData({this.allDays, this.allStartTime, this.allEndTime, this.days});

  OperationalResourceData.fromJson(Map<String, dynamic> json) {
    allDays = json['allDays'];
    allStartTime = json['allStartTime'];
    allEndTime = json['allEndTime'];
    if (json['days'] != null) {
      days = new List<Days>();
      json['days'].forEach((v) {
        days.add(new Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allDays'] = this.allDays;
    data['allStartTime'] = this.allStartTime;
    data['allEndTime'] = this.allEndTime;
    if (this.days != null) {
      data['days'] = this.days.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String dayName;
  String startTime;
  String endTime;
  bool open;

  Days({this.dayName, this.startTime, this.endTime, this.open});

  Days.fromJson(Map<String, dynamic> json) {
    dayName = json['dayName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayName'] = this.dayName;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['open'] = this.open;
    return data;
  }
}
