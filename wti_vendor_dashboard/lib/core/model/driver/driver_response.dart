class DriversResponse {
  final List<Driver> drivers;
  final String currentPage;
  final int totalPages;

  DriversResponse({
    required this.drivers,
    required this.currentPage,
    required this.totalPages,
  });

  factory DriversResponse.fromJson(Map<String, dynamic> json) {
    return DriversResponse(
      drivers: List<Driver>.from(json['Drivers'].map((x) => Driver.fromJson(x))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Drivers': drivers.map((x) => x.toJson()).toList(),
    'currentPage': currentPage,
    'totalPages': totalPages,
  };
}

class Driver {
  final String id;
  final String vendorId;
  final String? vehicleId;
  final String driverName;
  final String mobileNumber;
  final String dob;
  final String driverPhoto;
  final String licenseIdNumber;
  final String licensePhotoFront;
  final String licensePhotoBack;
  final String licenseExpiryDate;
  final String idProofType;
  final String idProofFrontPhoto;
  final String idProofBackPhoto;
  final String pccPhoto;
  final String driverStatus;
  final String registerStatus;
  final String message;
  final int v;
  final List<dynamic> driverOccupancy;
  final String updatedAt;
  final String? rating;

  Driver({
    required this.id,
    required this.vendorId,
    this.vehicleId,
    required this.driverName,
    required this.mobileNumber,
    required this.dob,
    required this.driverPhoto,
    required this.licenseIdNumber,
    required this.licensePhotoFront,
    required this.licensePhotoBack,
    required this.licenseExpiryDate,
    required this.idProofType,
    required this.idProofFrontPhoto,
    required this.idProofBackPhoto,
    required this.pccPhoto,
    required this.driverStatus,
    required this.registerStatus,
    required this.message,
    required this.v,
    required this.driverOccupancy,
    required this.updatedAt,
    this.rating,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      vendorId: json['VendorId'],
      vehicleId: json['VehicleId'],
      driverName: json['DriverName'],
      mobileNumber: json['MobileNumber'],
      dob: json['DoB'],
      driverPhoto: json['Driverphoto'],
      licenseIdNumber: json['LicenseIdNumber'],
      licensePhotoFront: json['LicensePhotoFront'],
      licensePhotoBack: json['LicensePhotoBack'],
      licenseExpiryDate: json['LicenseExpiryDate'],
      idProofType: json['Idprooftype'],
      idProofFrontPhoto: json['IdproofFrontPhoto'],
      idProofBackPhoto: json['IdproofBackPhoto'],
      pccPhoto: json['pccPhoto'],
      driverStatus: json['DriverStatus'],
      registerStatus: json['RegisterStatus'],
      message: json['message'],
      v: json['__v'],
      driverOccupancy: List<dynamic>.from(json['DriverOccupancy']),
      updatedAt: json['updatedAt'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'VendorId': vendorId,
    'VehicleId': vehicleId,
    'DriverName': driverName,
    'MobileNumber': mobileNumber,
    'DoB': dob,
    'Driverphoto': driverPhoto,
    'LicenseIdNumber': licenseIdNumber,
    'LicensePhotoFront': licensePhotoFront,
    'LicensePhotoBack': licensePhotoBack,
    'LicenseExpiryDate': licenseExpiryDate,
    'Idprooftype': idProofType,
    'IdproofFrontPhoto': idProofFrontPhoto,
    'IdproofBackPhoto': idProofBackPhoto,
    'pccPhoto': pccPhoto,
    'DriverStatus': driverStatus,
    'RegisterStatus': registerStatus,
    'message': message,
    '__v': v,
    'DriverOccupancy': driverOccupancy,
    'updatedAt': updatedAt,
    if (rating != null) 'rating': rating,
  };
}
