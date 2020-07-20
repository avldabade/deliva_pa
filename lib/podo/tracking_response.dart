class TrackingResponse {
  String responseMessage;
  int status;
  TrackingResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  TrackingResponse(
      {this.responseMessage,
        this.status,
        this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  TrackingResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new TrackingResourceData.fromJson(json['resourceData'])
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

class TrackingResourceData {
  int requestId;
  String title;
  OpcDetail opcDetail;
  OpcDetail daDetail;
  OpcDetail dpcDetail;
  OpcDetail rcDetail;
  String expectedDeliveryDate;
  String docketNumber;

  TrackingResourceData(
      {this.requestId,
        this.title,
        this.opcDetail,
        this.daDetail,
        this.dpcDetail,
        this.rcDetail,
        this.expectedDeliveryDate,
        this.docketNumber});

  TrackingResourceData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    title = json['title'];
    opcDetail = json['opcDetail'] != null
        ? new OpcDetail.fromJson(json['opcDetail'])
        : null;
    daDetail = json['daDetail'] != null
        ? new OpcDetail.fromJson(json['daDetail'])
        : null;
    dpcDetail = json['dpcDetail'] != null
        ? new OpcDetail.fromJson(json['dpcDetail'])
        : null;
    rcDetail = json['rcDetail'] != null
        ? new OpcDetail.fromJson(json['rcDetail'])
        : null;
    expectedDeliveryDate = json['expectedDeliveryDate'];
    docketNumber = json['docketNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['title'] = this.title;
    if (this.opcDetail != null) {
      data['opcDetail'] = this.opcDetail.toJson();
    }
    if (this.daDetail != null) {
      data['daDetail'] = this.daDetail.toJson();
    }
    if (this.dpcDetail != null) {
      data['dpcDetail'] = this.dpcDetail.toJson();
    }
    if (this.rcDetail != null) {
      data['rcDetail'] = this.rcDetail.toJson();
    }
    data['expectedDeliveryDate'] = this.expectedDeliveryDate;
    data['docketNumber'] = this.docketNumber;
    return data;
  }
}
class OpcDetail {
  List<MediaUrls> mediaUrls;
  String transitDate;

  OpcDetail({this.mediaUrls, this.transitDate});

  OpcDetail.fromJson(Map<String, dynamic> json) {
    if (json['mediaUrls'] != null) {
      mediaUrls = new List<MediaUrls>();
      json['mediaUrls'].forEach((v) {
        mediaUrls.add(new MediaUrls.fromJson(v));
      });
    }
    transitDate = json['transitDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaUrls != null) {
      data['mediaUrls'] = this.mediaUrls.map((v) => v.toJson()).toList();
    }
    data['transitDate'] = this.transitDate;
    return data;
  }
}

class MediaUrls {
  String thumbnailUrl350X350;
  String originalMediaUrl;
  String thumbnailUrl80X80;

  MediaUrls(
      {this.thumbnailUrl350X350,
        this.originalMediaUrl,
        this.thumbnailUrl80X80});

  MediaUrls.fromJson(Map<String, dynamic> json) {
    thumbnailUrl350X350 = json['thumbnailUrl350X350'];
    originalMediaUrl = json['originalMediaUrl'];
    thumbnailUrl80X80 = json['thumbnailUrl80X80'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumbnailUrl350X350'] = this.thumbnailUrl350X350;
    data['originalMediaUrl'] = this.originalMediaUrl;
    data['thumbnailUrl80X80'] = this.thumbnailUrl80X80;
    return data;
  }
}
