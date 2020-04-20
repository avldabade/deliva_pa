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
  String city;
  String name;
  String mobile;
  String state;
  int userId;
  String profileImageUrl;
  String email;

  PAResourceData(
      {this.country,
        this.city,
        this.name,
        this.mobile,
        this.state,
        this.userId,
        this.profileImageUrl,
        this.email});

  PAResourceData.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    city = json['city'];
    name = json['name'];
    mobile = json['mobile'];
    state = json['state'];
    userId = json['userId'];
    profileImageUrl = json['profileImageUrl'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['city'] = this.city;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['state'] = this.state;
    data['userId'] = this.userId;
    data['profileImageUrl'] = this.profileImageUrl;
    data['email'] = this.email;
    return data;
  }
}
