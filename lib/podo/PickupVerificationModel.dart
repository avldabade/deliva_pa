



class PickUpVerificationResponse {
  String responseMessage;
  int status;
  PickUpVerificationResponseData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  PickUpVerificationResponse(
      {this.responseMessage,
        this.status,
        this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  PickUpVerificationResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new PickUpVerificationResponseData.fromJson(json['resourceData'])
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

class PickUpVerificationResponseData {
  int requestId;
  String docketNumber;
  List mediaUrls;
  String title;
  double length;
  double width;
  double height;
  String dmUnit;
  double weight;
  String wtUnit;
  String dropOffDate;
  String mobile;


  PickUpVerificationResponseData(
      {this.requestId,this.docketNumber,this.mediaUrls,
      this.title,
        this.length,
        this.width,
        this.height,
        this.dmUnit,
        this.weight,
        this.wtUnit,
        this.dropOffDate,
        this.mobile});
  PickUpVerificationResponseData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    docketNumber = json['docketNumber']==null?"":json['docketNumber'];
    mediaUrls = json['mediaUrls'];

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
    data['docketNumber'] = this.docketNumber;

      data['mediaUrls'] = this.mediaUrls;

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


class MediaUrl{
  String thumbnailUrl350X350;
  String originalMediaUrl;
  String thumbnailUrl80X80;
  String mediaCode;

  MediaUrl(
      this.thumbnailUrl350X350,this.originalMediaUrl,this.thumbnailUrl80X80,
      this.mediaCode

      );



}