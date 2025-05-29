class DriverDetailsResponse {
  final String? id;
  final String? driverName;
  final String? mobileNumber;

  DriverDetailsResponse({
    this.id,
    this.driverName,
    this.mobileNumber,
  });

  factory DriverDetailsResponse.fromJson(Map<String, dynamic> json) {
    final driverJson = json['Driver'];
    return DriverDetailsResponse(
      id: driverJson?['_id'],
      driverName: driverJson?['DriverName'],
      mobileNumber: driverJson?['MobileNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "DriverName": driverName,
      "MobileNumber": mobileNumber,
    };
  }
}
