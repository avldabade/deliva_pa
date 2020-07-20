class RequestDetailResponse {
  String responseMessage;
  int status;
  PackageResourceData resourceData;
  String timestamp;
  String error;
  String message;
  String path;
  String errorDescription;

  RequestDetailResponse(
      {this.responseMessage,
      this.status,
      this.resourceData,
      this.timestamp,
      this.error,
      this.message,
      this.path,
      this.errorDescription});

  RequestDetailResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    status = json['status'];
    resourceData = json['resourceData'] != null
        ? new PackageResourceData.fromJson(json['resourceData'])
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

class PackageResourceData {
  int requestId;
  int numberOfBids;
  PAData sourcePa;
  PAData destiationPa;
  String dmUnit;
  String wtUnit;
  String currency;
  String dropOffDate; //DAte
  String dropOffTime; //Date//Date
  double weight;
  double value;
  double length;
  double width;
  double height;
  String description;
  String title;
  String expectedDeliveryDate; //Date
  List<MediaUrls> mediaUrls;
  List<BidDetails> bidDetails;
  int daId;
  String daName;
  double daRating;
  String dpcName;
  String dpcAddress;
  String dpcContactNo;
  double dpcRating;
  String dpcEmail;
  String currentLocation;
  String deliveryLabel;
  bool sourceLocFixed;
  bool insured;
  bool agree;

  String customer;
  String deliveryAgent;
  int deliveryAgentId;
  String currentDate;
  String destination;
  String recieverName;
  String recieverMobile;
  String docketNumber;


  PackageResourceData(
      {this.requestId,
      this.numberOfBids,
      this.sourcePa,
      this.destiationPa,
      this.dmUnit,
      this.wtUnit,
      this.currency,
      this.dropOffDate,
      this.dropOffTime,
      this.weight,
      this.value,
      this.length,
      this.width,
      this.height,
      this.description,
      this.title,
      this.expectedDeliveryDate,
      this.mediaUrls,
      this.bidDetails,
      this.daId,
      this.daName,
      this.daRating,
      this.dpcName,
      this.dpcAddress,
      this.dpcContactNo,
      this.dpcRating,
      this.dpcEmail,
      this.currentLocation,
      this.deliveryLabel,
      this.sourceLocFixed,
      this.insured,
      this.agree,

        this.customer,
        this.deliveryAgent,
        this.deliveryAgentId,
        this.currentDate,
        this.destination,
        this.recieverName,
        this.recieverMobile,
        this.docketNumber
      });

  PackageResourceData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    numberOfBids = json['numberOfBids'];
    sourcePa =
        json['sourcePa'] != null ? new PAData.fromJson(json['sourcePa']) : null;
    destiationPa = json['destiationPa'] != null
        ? new PAData.fromJson(json['destiationPa'])
        : null;
    dmUnit = json['dmUnit'];
    wtUnit = json['wtUnit'];
    currency = json['currency'];
    dropOffDate = json['dropOffDate'];
    dropOffTime = json['dropOffTime'];
    weight = json['weight'];
    value = json['value'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    description = json['description'];
    title = json['title'];
    expectedDeliveryDate = json['expectedDeliveryDate'];
    if (json['mediaUrls'] != null) {
      mediaUrls = new List<MediaUrls>();
      json['mediaUrls'].forEach((v) {
        mediaUrls.add(new MediaUrls.fromJson(v));
      });
    }
    if (json['bidDetails'] != null) {
      bidDetails = new List<BidDetails>();
      json['bidDetails'].forEach((v) {
        bidDetails.add(new BidDetails.fromJson(v));
      });
    }
    daId = json['daId'];
    daName = json['daName'];
    daRating = json['daRating'];
    dpcName = json['dpcName'];
    dpcAddress = json['dpcAddress'];
    dpcContactNo = json['dpcContactNo'];
    dpcRating = json['dpcRating'];
    dpcEmail = json['dpcEmail'];
    currentLocation = json['currentLocation'];
    deliveryLabel = json['deliveryLabel'];
    sourceLocFixed = json['sourceLocFixed'];
    insured = json['insured'];
    agree = json['agree'];

    customer = json['customer'];
    deliveryAgent = json['deliveryAgent'];
    deliveryAgentId = json['deliveryAgentId'];
    currentDate = json['currentDate'];
    destination = json['destination'];
    recieverName = json['recieverName'];
    recieverMobile = json['recieverMobile'];
    docketNumber = json['docketNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['numberOfBids'] = this.numberOfBids;
    if (this.sourcePa != null) {
      data['sourcePa'] = this.sourcePa.toJson();
    }
    if (this.destiationPa != null) {
      data['destiationPa'] = this.destiationPa.toJson();
    }
    data['dmUnit'] = this.dmUnit;
    data['wtUnit'] = this.wtUnit;
    data['currency'] = this.currency;
    data['dropOffDate'] = this.dropOffDate;
    data['dropOffTime'] = this.dropOffTime;
    data['weight'] = this.weight;
    data['value'] = this.value;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['description'] = this.description;
    data['title'] = this.title;
    data['expectedDeliveryDate'] = this.expectedDeliveryDate;
    if (this.mediaUrls != null) {
      data['mediaUrls'] = this.mediaUrls.map((v) => v.toJson()).toList();
    }
    if (this.bidDetails != null) {
      data['bidDetails'] = this.bidDetails.map((v) => v.toJson()).toList();
    }
    data['daId'] = this.daId;
    data['daName'] = this.daName;
    data['daRating'] = this.daRating;
    data['dpcName'] = this.dpcName;
    data['dpcAddress'] = this.dpcAddress;
    data['dpcContactNo'] = this.dpcContactNo;
    data['dpcRating'] = this.dpcRating;
    data['dpcEmail'] = this.dpcEmail;
    data['currentLocation'] = this.currentLocation;
    data['deliveryLabel'] = this.deliveryLabel;
    data['sourceLocFixed'] = this.sourceLocFixed;
    data['insured'] = this.insured;
    data['agree'] = this.agree;

    data['customer'] = this.customer;
    data['deliveryAgent'] = this.deliveryAgent;
    data['deliveryAgentId'] = this.deliveryAgentId;
    data['currentDate'] = this.currentDate;
    data['destination'] = this.destination;
    data['recieverName'] = this.recieverName;
    data['recieverMobile'] = this.recieverMobile;
    data['docketNumber'] = this.docketNumber;

    return data;
  }
}

class PAData {
  int paId;
  String address;
  String city;
  String country;
  String businessName;
  double distance; //check value for distance
  double latitude;
  double longitude; //check value for distance
  int zipcode;

  PAData(
      {this.paId,
      this.address,
      this.city,
      this.country,
      this.businessName,
      this.distance,
      this.latitude,
      this.longitude,
      this.zipcode});

  PAData.fromJson(Map<String, dynamic> json) {
    paId = json['paId'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    businessName = json['businessName'];
    distance = json['distance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paId'] = this.paId;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['businessName'] = this.businessName;
    data['distance'] = this.distance;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zipcode'] = this.zipcode;
    return data;
  }
}

class BidDetails {
  int bidId;
  String name;
  double rating;
  double value;
  String pickUpDate;
  String pickupTime;
  int daId;
  String currency;
  double insuranceAmount;
  String insuranceAmountCurrency;

  BidDetails(
      {this.bidId,
      this.name,
      this.rating,
      this.value,
      this.pickUpDate,
      this.pickupTime,
      this.daId,
        this.currency,
        this.insuranceAmount,
        this.insuranceAmountCurrency});

  BidDetails.fromJson(Map<String, dynamic> json) {
    bidId = json['bidId'];
    name = json['name'];
    rating = json['rating'];
    value = json['value'];
    pickUpDate = json['pickUpDate'];
    pickupTime = json['pickupTime'];
    daId = json['daId'];
    currency = json['currency'];
    insuranceAmount = json['insuranceAmount'];
    insuranceAmountCurrency = json['insuranceAmountCurrency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bidId'] = this.bidId;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['value'] = this.value;
    data['pickUpDate'] = this.pickUpDate;
    data['pickupTime'] = this.pickupTime;
    data['daId'] = this.daId;
    data['currency'] = this.currency;
    data['insuranceAmount'] = this.insuranceAmount;
    data['insuranceAmountCurrency'] = this.insuranceAmountCurrency;
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
