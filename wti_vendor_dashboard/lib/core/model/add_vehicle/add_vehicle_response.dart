class AddVehicleResponse {
  final Vehicle? vehicle;

  AddVehicleResponse({this.vehicle});

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) {
    return AddVehicleResponse(
      vehicle: json['Vehicle'] != null ? Vehicle.fromJson(json['Vehicle']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Vehicle': vehicle?.toJson(),
    };
  }
}

class Vehicle {
  final String? vendorId;
  final String? driverId;
  final dynamic activeDriver;
  final List<dynamic>? driverArray;
  final String? vehicleNumber;
  final String? brand;
  final String? fuelType;
  final String? insuranceValidUpto;
  final String? registerationDate;
  final String? carNumberPhoto;
  final String? vehicleCategory;
  final String? modelType;
  final String? vehicleOwnership;
  final String? insurancePhoto;
  final String? registercertificateFrontLink;
  final String? registercertificateBackLink;
  final String? leasecertificate;
  final String? carStatus;
  final String? registerStatus;
  final String? message;
  final int? vehiclecurrentstatus;
  final String? id;
  final List<dynamic>? carOccupancy;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Vehicle({
    this.vendorId,
    this.driverId,
    this.activeDriver,
    this.driverArray,
    this.vehicleNumber,
    this.brand,
    this.fuelType,
    this.insuranceValidUpto,
    this.registerationDate,
    this.carNumberPhoto,
    this.vehicleCategory,
    this.modelType,
    this.vehicleOwnership,
    this.insurancePhoto,
    this.registercertificateFrontLink,
    this.registercertificateBackLink,
    this.leasecertificate,
    this.carStatus,
    this.registerStatus,
    this.message,
    this.vehiclecurrentstatus,
    this.id,
    this.carOccupancy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vendorId: json['VendorId'] as String?,
      driverId: json['DriverId'] as String?,
      activeDriver: json['ActiveDriver'],
      driverArray: json['DriverArray'] != null ? List<dynamic>.from(json['DriverArray']) : [],
      vehicleNumber: json['VehicleNumber'] as String?,
      brand: json['Brand'] as String?,
      fuelType: json['FuelType'] as String?,
      insuranceValidUpto: json['InsuranceValidUpto'] as String?,
      registerationDate: json['RegisterationDate'] as String?,
      carNumberPhoto: json['CarNumberPhoto'] as String?,
      vehicleCategory: json['vehicleCategory'] as String?,
      modelType: json['ModelType'] as String?,
      vehicleOwnership: json['VehicleOwnership'] as String?,
      insurancePhoto: json['InsurancePhoto'] as String?,
      registercertificateFrontLink: json['RegistercertificateFrontLink'] as String?,
      registercertificateBackLink: json['RegistercertificateBackLink'] as String?,
      leasecertificate: json['Leasecertificate'] as String?,
      carStatus: json['CarStatus'] as String?,
      registerStatus: json['RegisterStatus'] as String?,
      message: json['message'] as String?,
      vehiclecurrentstatus: json['vehiclecurrentstatus'] as int?,
      id: json['_id'] as String?,
      carOccupancy: json['CarOccupancy'] != null ? List<dynamic>.from(json['CarOccupancy']) : [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VendorId': vendorId,
      'DriverId': driverId,
      'ActiveDriver': activeDriver,
      'DriverArray': driverArray,
      'VehicleNumber': vehicleNumber,
      'Brand': brand,
      'FuelType': fuelType,
      'InsuranceValidUpto': insuranceValidUpto,
      'RegisterationDate': registerationDate,
      'CarNumberPhoto': carNumberPhoto,
      'vehicleCategory': vehicleCategory,
      'ModelType': modelType,
      'VehicleOwnership': vehicleOwnership,
      'InsurancePhoto': insurancePhoto,
      'RegistercertificateFrontLink': registercertificateFrontLink,
      'RegistercertificateBackLink': registercertificateBackLink,
      'Leasecertificate': leasecertificate,
      'CarStatus': carStatus,
      'RegisterStatus': registerStatus,
      'message': message,
      'vehiclecurrentstatus': vehiclecurrentstatus,
      '_id': id,
      'CarOccupancy': carOccupancy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
