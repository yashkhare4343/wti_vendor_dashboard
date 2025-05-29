class ParticularVehicleResponse {
  final Vehicle? vehicle;

  ParticularVehicleResponse({this.vehicle});

  factory ParticularVehicleResponse.fromJson(Map<String, dynamic> json) {
    return ParticularVehicleResponse(
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle': vehicle?.toJson(),
    };
  }
}

class Vehicle {
  final String? id;
  final String? vendorId;
  final String? driverId;
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
  final int? v;
  final List<String>? driverArray;
  final String? activeDriver;
  final List<dynamic>? carOccupancy;
  final String? currentBookingid;
  final String? updatedAt;
  final int? vehicleCurrentStatus;

  Vehicle({
    this.id,
    this.vendorId,
    this.driverId,
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
    this.v,
    this.driverArray,
    this.activeDriver,
    this.carOccupancy,
    this.currentBookingid,
    this.updatedAt,
    this.vehicleCurrentStatus,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      vendorId: json['VendorId'],
      driverId: json['DriverId'],
      vehicleNumber: json['VehicleNumber'],
      brand: json['Brand'],
      fuelType: json['FuelType'],
      insuranceValidUpto: json['InsuranceValidUpto'],
      registerationDate: json['RegisterationDate'],
      carNumberPhoto: json['CarNumberPhoto'],
      vehicleCategory: json['vehicleCategory'],
      modelType: json['ModelType'],
      vehicleOwnership: json['VehicleOwnership'],
      insurancePhoto: json['InsurancePhoto'],
      registercertificateFrontLink: json['RegistercertificateFrontLink'],
      registercertificateBackLink: json['RegistercertificateBackLink'],
      leasecertificate: json['Leasecertificate'],
      carStatus: json['CarStatus'],
      registerStatus: json['RegisterStatus'],
      message: json['message'],
      v: json['__v'],
      driverArray: List<String>.from(json['DriverArray'] ?? []),
      activeDriver: json['ActiveDriver'],
      carOccupancy: json['CarOccupancy'] ?? [],
      currentBookingid: json['currentBookingid'],
      updatedAt: json['updatedAt'],
      vehicleCurrentStatus: json['vehiclecurrentstatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'VendorId': vendorId,
      'DriverId': driverId,
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
      '__v': v,
      'DriverArray': driverArray,
      'ActiveDriver': activeDriver,
      'CarOccupancy': carOccupancy,
      'currentBookingid': currentBookingid,
      'updatedAt': updatedAt,
      'vehiclecurrentstatus': vehicleCurrentStatus,
    };
  }
}
