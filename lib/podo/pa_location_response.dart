class PALocationResponse {
  String responseMessage;
  int status;
  List<PAResourceData> resourceData;
  String timestamp;
  String error;
  String message;
  String path;

  PALocationResponse({this.responseMessage, this.status, this.resourceData,this.timestamp, this.error, this.message, this.path});

  PALocationResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    if (json['resourceData'] != null) {
      resourceData = new List<PAResourceData>();
      json['resourceData'].forEach((v) {
        resourceData.add(new PAResourceData.fromJson(v));
      });
    }
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
      data['resourceData'] = this.resourceData.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    return data;
  }
}

class PAResourceData {
  String country;
  String address;
  String distance;
  String city;
  String name;
  String businessName;
  String state;
  int userId;

  PAResourceData(
      {this.country,
        this.address,
        this.distance,
        this.city,
        this.name,
        this.businessName,
        this.state,
        this.userId});

  PAResourceData.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    address = json['address'];
    distance = json['distance'];
    city = json['city'];
    name = json['name'];
    businessName = json['businessName'];
    state = json['state'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['address'] = this.address;
    data['distance'] = this.distance;
    data['city'] = this.city;
    data['name'] = this.name;
    data['businessName'] = this.businessName;
    data['state'] = this.state;
    data['userId'] = this.userId;
    return data;
  }
}
