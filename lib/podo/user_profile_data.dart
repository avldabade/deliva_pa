class UserProfileData {
  String responseMessage;
  int status;
  UserProfileResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  UserProfileData({this.responseMessage, this.status, this.resourceData,
    this.timestamp,
    this.error,
    this.message,
    this.path,
    this.errorDescription});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new UserProfileResourceData.fromJson(json['resourceData'])
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
class UserProfileResourceData {
  String businessName;
  String businessType;
  String businessRegistrationNumber;
  String email;

  int userId;
  String name;
  String address;
  String mobile;
  String countryCode;
  String profileImageUrl;

  BussinessAddress bussinessAddress;
  BankingDetails bankingDetails;
  OperationalHours operationalHours;

  UserProfileResourceData(
      {this.businessName,
        this.businessType,
        this.businessRegistrationNumber,
        this.email,

        this.userId,
        this.name,
        this.address,
        this.mobile,
        this.countryCode,
        this.profileImageUrl,

        this.bussinessAddress,
        this.bankingDetails,
        this.operationalHours});

  UserProfileResourceData.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    businessType = json['businessType'];
    businessRegistrationNumber = json['businessRegistrationNumber'];
    email = json['email'];

    userId = json['userId'];
    name = json['name'];
    address = json['address'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    profileImageUrl = json['profileImageUrl'];

    bussinessAddress = json['bussinessAddress'] != null
        ? new BussinessAddress.fromJson(json['bussinessAddress'])
        : null;
    bankingDetails = json['bankingDetails'] != null
        ? new BankingDetails.fromJson(json['bankingDetails'])
        : null;
    operationalHours = json['operationalHours'] != null
        ? new OperationalHours.fromJson(json['operationalHours'])
        : null;


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['businessType'] = this.businessType;
    data['businessRegistrationNumber'] = this.businessRegistrationNumber;
    data['email'] = this.email;

    data['userId'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile'] = this.mobile;
    data['countryCode'] = this.countryCode;
    data['profileImageUrl'] = this.profileImageUrl;

    if (this.bussinessAddress != null) {
      data['bussinessAddress'] = this.bussinessAddress.toJson();
    }
    if (this.bankingDetails != null) {
      data['bankingDetails'] = this.bankingDetails.toJson();
    }
    if (this.operationalHours != null) {
      data['operationalHours'] = this.operationalHours.toJson();
    }
    return data;
  }
}

class BussinessAddress {
  String address;
  String state;
  int zipcode;
  String country;
  String city;
  String aptNumber;

  BussinessAddress(
      {this.address,
        this.state,
        this.zipcode,
        this.country,
        this.city,
        this.aptNumber});

  BussinessAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    zipcode = json['zipcode'];
    country = json['country'];
    city = json['city'];
    aptNumber = json['aptNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['country'] = this.country;
    data['city'] = this.city;
    data['aptNumber'] = this.aptNumber;
    return data;
  }
}

class BankingDetails {
  String fullName;
  String bankName;
  String bankLocation;
  String accountNumber;
  String abaNumber;

  BankingDetails(
      {this.fullName,
        this.bankName,
        this.bankLocation,
        this.accountNumber,
        this.abaNumber});

  BankingDetails.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    bankName = json['bankName'];
    bankLocation = json['bankLocation'];
    accountNumber = json['accountNumber'];
    abaNumber = json['abaNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['bankName'] = this.bankName;
    data['bankLocation'] = this.bankLocation;
    data['accountNumber'] = this.accountNumber;
    data['abaNumber'] = this.abaNumber;
    return data;
  }
}

class OperationalHours {
  bool allDays;
  Null startTime;
  Null endTime;
  List<Days> days;

  OperationalHours({this.allDays, this.startTime, this.endTime, this.days});

  OperationalHours.fromJson(Map<String, dynamic> json) {
    allDays = json['allDays'];
    startTime = json['startTime'];
    endTime = json['endTime'];
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
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    if (this.days != null) {
      data['days'] = this.days.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String dayName;
  bool open;
  String startTime;
  String endTime;

  Days({this.dayName, this.open, this.startTime, this.endTime});

  Days.fromJson(Map<String, dynamic> json) {
    dayName = json['dayName'];
    open = json['open'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayName'] = this.dayName;
    data['open'] = this.open;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
/*class UserProfileResourceData {
  int userId;
  String name;
  String address;
  String email;
  String mobile;
  String countryCode;
  String profileImageUrl;

  UserProfileResourceData(
      {this.userId,
        this.name,
        this.address,
        this.email,
        this.mobile,
        this.countryCode,
        this.profileImageUrl});

  UserProfileResourceData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    address = json['address'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['countryCode'] = this.countryCode;
    data['profileImageUrl'] = this.profileImageUrl;
    return data;
  }
}*/
