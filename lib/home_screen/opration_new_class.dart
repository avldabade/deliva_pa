class OperationNewClass {
  String startTime, endTime, dayName;

  bool isSelect = false;

  OperationNewClass(this.startTime, this.endTime, this.dayName, this.isSelect);



  Map<String, dynamic> toJson() => {
    "dayName": dayName,
    "startTime": startTime,
    "endTime": endTime,
    "open": isSelect
  };


}