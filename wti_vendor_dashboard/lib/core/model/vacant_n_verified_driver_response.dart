class VacantNVerifiedDriverResponse {
  final List<VacantDriver>? vacantDrivers;

  VacantNVerifiedDriverResponse({this.vacantDrivers});

  factory VacantNVerifiedDriverResponse.fromJson(Map<String, dynamic> json) {
    return VacantNVerifiedDriverResponse(
      vacantDrivers: (json['vacantDrivers'] as List<dynamic>?)
          ?.map((e) => VacantDriver.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vacantDrivers': vacantDrivers?.map((e) => e.toJson()).toList(),
    };
  }
}

class VacantDriver {
  final String? id;
  final String? driverName;
  final String? mobileNumber;

  VacantDriver({
    this.id,
    this.driverName,
    this.mobileNumber,
  });

  factory VacantDriver.fromJson(Map<String, dynamic> json) {
    return VacantDriver(
      id: json['_id'] as String?,
      driverName: json['DriverName'] as String?,
      mobileNumber: json['MobileNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'DriverName': driverName,
      'MobileNumber': mobileNumber,
    };
  }
}
