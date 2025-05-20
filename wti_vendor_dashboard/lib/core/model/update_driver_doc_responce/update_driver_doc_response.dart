class UpdateDriverDocResponse {
  final String? message;
  final Driver? driver;

  UpdateDriverDocResponse({this.message, this.driver});

  factory UpdateDriverDocResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDriverDocResponse(
      message: json['message'] as String?,
      driver:
      json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'driver': driver?.toJson(),
    };
  }
}

class Driver {
  final String? id;
  final String? vendorId;
  final String? vehicleId;
  final String? driverName;
  final String? mobileNumber;
  final String? doB;
  final String? driverPhoto;
  final String? licenseIdNumber;
  final String? licensePhotoFront;
  final String? licensePhotoBack;
  final String? licenseExpiryDate;
  final String? idProofType;
  final String? idProofFrontPhoto;
  final String? idProofBackPhoto;
  final String? pccPhoto;
  final String? driverStatus;
  final String? registerStatus;
  final String? message;
  final int? v;
  final List<dynamic>? driverOccupancy;
  final String? updatedAt;

  Driver({
    this.id,
    this.vendorId,
    this.vehicleId,
    this.driverName,
    this.mobileNumber,
    this.doB,
    this.driverPhoto,
    this.licenseIdNumber,
    this.licensePhotoFront,
    this.licensePhotoBack,
    this.licenseExpiryDate,
    this.idProofType,
    this.idProofFrontPhoto,
    this.idProofBackPhoto,
    this.pccPhoto,
    this.driverStatus,
    this.registerStatus,
    this.message,
    this.v,
    this.driverOccupancy,
    this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] as String?,
      vendorId: json['VendorId'] as String?,
      vehicleId: json['VehicleId'] as String?,
      driverName: json['DriverName'] as String?,
      mobileNumber: json['MobileNumber'] as String?,
      doB: json['DoB'] as String?,
      driverPhoto: json['Driverphoto'] as String?,
      licenseIdNumber: json['LicenseIdNumber'] as String?,
      licensePhotoFront: json['LicensePhotoFront'] as String?,
      licensePhotoBack: json['LicensePhotoBack'] as String?,
      licenseExpiryDate: json['LicenseExpiryDate'] as String?,
      idProofType: json['Idprooftype'] as String?,
      idProofFrontPhoto: json['IdproofFrontPhoto'] as String?,
      idProofBackPhoto: json['IdproofBackPhoto'] as String?,
      pccPhoto: json['pccPhoto'] as String?,
      driverStatus: json['DriverStatus'] as String?,
      registerStatus: json['RegisterStatus'] as String?,
      message: json['message'] as String?,
      v: json['__v'] as int?,
      driverOccupancy: json['DriverOccupancy'] as List<dynamic>?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'VendorId': vendorId,
      'VehicleId': vehicleId,
      'DriverName': driverName,
      'MobileNumber': mobileNumber,
      'DoB': doB,
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
    };
  }
}
