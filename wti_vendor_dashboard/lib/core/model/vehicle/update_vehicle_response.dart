import 'package:meta/meta.dart';

class UpdateVehicleResponse {
  final String message;
  final UpdatedVehicle? updatedVehicle;

  UpdateVehicleResponse({
    required this.message,
    required this.updatedVehicle,
  });

  factory UpdateVehicleResponse.fromJson(Map<String, dynamic> json) {
    return UpdateVehicleResponse(
      message: json['message'] ?? '',
      updatedVehicle: json['updatedVehicle'] != null
          ? UpdatedVehicle.fromJson(json['updatedVehicle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'updatedVehicle': updatedVehicle?.toJson(),
    };
  }
}

class UpdatedVehicle {
  final String? id;
  final String? vendorId;
  final String? driverId;
  final dynamic activeDriver;
  final List<dynamic> driverArray;
  final String? vehicleNumber;
  final String? brand;
  final String? fuelType;
  final String? insuranceValidUpto;
  final String? registrationDate;
  final String? carNumberPhoto;
  final String? vehicleCategory;
  final String? modelType;
  final String? vehicleOwnership;
  final String? insurancePhoto;
  final String? registerCertificateFrontLink;
  final String? registerCertificateBackLink;
  final String? leaseCertificate;
  final String? carStatus;
  final String? registerStatus;
  final String? message;
  final int? vehicleCurrentStatus;
  final dynamic modifyBy;
  final dynamic modifyAt;
  final List<dynamic> carOccupancy;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  UpdatedVehicle({
    this.id,
    this.vendorId,
    this.driverId,
    this.activeDriver,
    required this.driverArray,
    this.vehicleNumber,
    this.brand,
    this.fuelType,
    this.insuranceValidUpto,
    this.registrationDate,
    this.carNumberPhoto,
    this.vehicleCategory,
    this.modelType,
    this.vehicleOwnership,
    this.insurancePhoto,
    this.registerCertificateFrontLink,
    this.registerCertificateBackLink,
    this.leaseCertificate,
    this.carStatus,
    this.registerStatus,
    this.message,
    this.vehicleCurrentStatus,
    this.modifyBy,
    this.modifyAt,
    required this.carOccupancy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UpdatedVehicle.fromJson(Map<String, dynamic> json) {
    return UpdatedVehicle(
      id: json['_id'],
      vendorId: json['VendorId'],
      driverId: json['DriverId'],
      activeDriver: json['ActiveDriver'],
      driverArray: json['DriverArray'] ?? [],
      vehicleNumber: json['VehicleNumber'],
      brand: json['Brand'],
      fuelType: json['FuelType'],
      insuranceValidUpto: json['InsuranceValidUpto'],
      registrationDate: json['RegisterationDate'],
      carNumberPhoto: json['CarNumberPhoto'],
      vehicleCategory: json['vehicleCategory'],
      modelType: json['ModelType'],
      vehicleOwnership: json['VehicleOwnership'],
      insurancePhoto: json['InsurancePhoto'],
      registerCertificateFrontLink: json['RegistercertificateFrontLink'],
      registerCertificateBackLink: json['RegistercertificateBackLink'],
      leaseCertificate: json['Leasecertificate'],
      carStatus: json['CarStatus'],
      registerStatus: json['RegisterStatus'],
      message: json['message'],
      vehicleCurrentStatus: json['vehiclecurrentstatus'],
      modifyBy: json['modify_by'],
      modifyAt: json['modify_At'],
      carOccupancy: json['CarOccupancy'] ?? [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'VendorId': vendorId,
      'DriverId': driverId,
      'ActiveDriver': activeDriver,
      'DriverArray': driverArray,
      'VehicleNumber': vehicleNumber,
      'Brand': brand,
      'FuelType': fuelType,
      'InsuranceValidUpto': insuranceValidUpto,
      'RegisterationDate': registrationDate,
      'CarNumberPhoto': carNumberPhoto,
      'vehicleCategory': vehicleCategory,
      'ModelType': modelType,
      'VehicleOwnership': vehicleOwnership,
      'InsurancePhoto': insurancePhoto,
      'RegistercertificateFrontLink': registerCertificateFrontLink,
      'RegistercertificateBackLink': registerCertificateBackLink,
      'Leasecertificate': leaseCertificate,
      'CarStatus': carStatus,
      'RegisterStatus': registerStatus,
      'message': message,
      'vehiclecurrentstatus': vehicleCurrentStatus,
      'modify_by': modifyBy,
      'modify_At': modifyAt,
      'CarOccupancy': carOccupancy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
