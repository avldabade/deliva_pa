class DeliveryRequestsResponse {
  String responseMessage;
  int status;
  List<ResourceDataForAllDeliveryReq> resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  DeliveryRequestsResponse(
      {this.responseMessage, this.status, this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  DeliveryRequestsResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    if (json['resourceData'] != null) {
      resourceData = new List<ResourceDataForAllDeliveryReq>();
      json['resourceData'].forEach((v) {
        resourceData.add(new ResourceDataForAllDeliveryReq.fromJson(v));
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

class ResourceDataForAllDeliveryReq {
  int requestId;
  int sourcePaId;
  int destinationPaId;
  String title;
  String deliveryBeforeDate;
  bool isPublished;
  bool isActive;
  int customerId;
  int numberOfBids;

  String status;
  String dropOffDate;
  String deliveryDate;
  String daName;
  String currentLocation;


  ResourceDataForAllDeliveryReq(
      {this.requestId,
        this.sourcePaId,
        this.destinationPaId,
        this.title,
        this.deliveryBeforeDate,
        this.isPublished,
        this.isActive,
        this.customerId,
        this.numberOfBids,

        this.status,
        this.dropOffDate,
        this.deliveryDate,
        this.daName,
        this.currentLocation});

  ResourceDataForAllDeliveryReq.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    sourcePaId = json['sourcePaId'];
    destinationPaId = json['destinationPaId'];
    title = json['title'];
    deliveryBeforeDate = json['deliveryBeforeDate'];
    isPublished = json['isPublished'];
    isActive = json['isActive'];
    customerId = json['customerId'];
    numberOfBids = json['numberOfBids'];

    status = json['status'];
    dropOffDate = json['dropOffDate'];
    deliveryDate = json['deliveryDate'];
    daName = json['daName'];
    currentLocation = json['currentLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['sourcePaId'] = this.sourcePaId;
    data['destinationPaId'] = this.destinationPaId;
    data['title'] = this.title;
    data['deliveryBeforeDate'] = this.deliveryBeforeDate;
    data['isPublished'] = this.isPublished;
    data['isActive'] = this.isActive;
    data['customerId'] = this.customerId;
    data['numberOfBids'] = this.numberOfBids;

    data['status'] = this.status;
    data['dropOffDate'] = this.dropOffDate;
    data['deliveryDate'] = this.deliveryDate;
    data['daName'] = this.daName;
    data['currentLocation'] = this.currentLocation;
    return data;
  }
}
