class VehicleResponse {
  final List<Vehicle> vehicles;
  final String currentPage;
  final int totalPages;

  VehicleResponse({
    required this.vehicles,
    required this.currentPage,
    required this.totalPages,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      vehicles: List<Vehicle>.from(json['vehicles'].map((x) => Vehicle.fromJson(x))),
      currentPage: json['currentPage'] ?? '',
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicles': vehicles.map((x) => x.toJson()).toList(),
    'currentPage': currentPage,
    'totalPages': totalPages,
  };
}

class Vehicle {
  final String id;
  final String vendorId;
  final String? driverId;
  final String? activeDriver;
  final List<String> driverArray;
  final String vehicleNumber;
  final String brand;
  final String fuelType;
  final String insuranceValidUpto;
  final String registerationDate;
  final String carNumberPhoto;
  final String vehicleCategory;
  final String modelType;
  final String vehicleOwnership;
  final String insurancePhoto;
  final String registercertificateFrontLink;
  final String registercertificateBackLink;
  final String leasecertificate;
  final String carStatus;
  final String registerStatus;
  final String message;
  final int v;
  final List<CarOccupancy> carOccupancy;
  final String? currentBookingid;
  final DateTime updatedAt;
  final int vehicleCurrentStatus;
  final String? rating;
  final String? modifyBy;

  Vehicle({
    required this.id,
    required this.vendorId,
    this.driverId,
    this.activeDriver,
    required this.driverArray,
    required this.vehicleNumber,
    required this.brand,
    required this.fuelType,
    required this.insuranceValidUpto,
    required this.registerationDate,
    required this.carNumberPhoto,
    required this.vehicleCategory,
    required this.modelType,
    required this.vehicleOwnership,
    required this.insurancePhoto,
    required this.registercertificateFrontLink,
    required this.registercertificateBackLink,
    required this.leasecertificate,
    required this.carStatus,
    required this.registerStatus,
    required this.message,
    required this.v,
    required this.carOccupancy,
    this.currentBookingid,
    required this.updatedAt,
    required this.vehicleCurrentStatus,
    this.rating,
    this.modifyBy,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      vendorId: json['VendorId'],
      driverId: json['DriverId'],
      activeDriver: json['ActiveDriver'],
      driverArray: List<String>.from(json['DriverArray']),
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
      message: json['message'] ?? '',
      v: json['__v'],
      carOccupancy: (json['CarOccupancy'] as List)
          .map((e) => CarOccupancy.fromJson(e))
          .toList(),
      currentBookingid: json['currentBookingid'],
      updatedAt: DateTime.parse(json['updatedAt']),
      vehicleCurrentStatus: json['vehiclecurrentstatus'],
      rating: json['rating'],
      modifyBy: json['modify_by'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
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
    '__v': v,
    'CarOccupancy': carOccupancy.map((x) => x.toJson()).toList(),
    'currentBookingid': currentBookingid,
    'updatedAt': updatedAt.toIso8601String(),
    'vehiclecurrentstatus': vehicleCurrentStatus,
    'rating': rating,
    'modify_by': modifyBy,
  };
}

class CarOccupancy {
  final String referenceNumber;
  final String startTime;
  final String endTime;
  final String id;

  CarOccupancy({
    required this.referenceNumber,
    required this.startTime,
    required this.endTime,
    required this.id,
  });

  factory CarOccupancy.fromJson(Map<String, dynamic> json) {
    return CarOccupancy(
      referenceNumber: json['reference_number'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reference_number': referenceNumber,
    'startTime': startTime,
    'endTime': endTime,
    '_id': id,
  };
}
