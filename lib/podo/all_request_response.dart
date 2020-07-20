class PackageDataResoponse {
  String responseMessage;
  int status;
  List<RequestResourceData> resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  PackageDataResoponse(
      {this.responseMessage,
        this.status,
        this.resourceData,
        this.timestamp,
        this.error,
        this.message,
        this.path,
        this.errorDescription});

  PackageDataResoponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    if (json['resourceData'] != null) {
      resourceData = new List<RequestResourceData>();
      json['resourceData'].forEach((v) {
        resourceData.add(new RequestResourceData.fromJson(v));
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

class RequestResourceData {
  int requestId;
  int customerId;
  int daId;
  int paId;
  String title;
  String pickupDate;
  String pickupTime;
  String expectedPickupDate;
  String status;
  String daName;
  String customerName;
  String currentLocation;
  String destinationPaBusinessName;
  String deliveryLabel;
  String docketNumber;
  int receiverId;
  String receiverName;

  RequestResourceData(
      {this.requestId,
        this.customerId,
        this.daId,
        this.paId,
        this.title,
        this.pickupDate,
        this.pickupTime,
        this.expectedPickupDate,
        this.status,
        this.daName,
        this.customerName,
        this.currentLocation,
        this.destinationPaBusinessName,
        this.deliveryLabel,
        this.docketNumber,
        this.receiverId,
        this.receiverName
      });

  RequestResourceData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    customerId = json['customerId'];
    daId = json['daId'];
    paId = json['paId'];
    title = json['title'];
    pickupDate = json['pickupDate'];
    pickupTime = json['pickupTime'];
    expectedPickupDate = json['expectedPickupDate'];
    status = json['status'];
    daName = json['daName'];
    customerName = json['customerName'];
    currentLocation = json['currentLocation'];
    destinationPaBusinessName = json['destinationPaBusinessName'];
    deliveryLabel = json['deliveryLabel'];
    docketNumber = json['docketNumber'];
    receiverId = json['receiverId'];
    receiverName = json['receiverName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['customerId'] = this.customerId;
    data['daId'] = this.daId;
    data['paId'] = this.paId;
    data['title'] = this.title;
    data['pickupDate'] = this.pickupDate;
    data['pickupTime'] = this.pickupTime;
    data['expectedPickupDate'] = this.expectedPickupDate;
    data['status'] = this.status;
    data['daName'] = this.daName;
    data['customerName'] = this.customerName;
    data['currentLocation'] = this.currentLocation;
    data['destinationPaBusinessName'] = this.destinationPaBusinessName;
    data['deliveryLabel'] = this.deliveryLabel;
    data['docketNumber'] = this.docketNumber;
    data['receiverId'] = this.receiverId;
    data['receiverName'] = this.receiverName;
    return data;
  }
}
