class VehicleListResponse {
  final List<Vehicle> vehicles;

  VehicleListResponse({required this.vehicles});

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    var vehicleList = json['vehicles'] as List;
    List<Vehicle> vehicles = vehicleList.map((i) => Vehicle.fromJson(i)).toList();
    return VehicleListResponse(vehicles: vehicles);
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicles': vehicles.map((v) => v.toJson()).toList(),
    };
  }
}

class Vehicle {
  final String id;
  final String vehicleNumber;
  final String activeDriver;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.activeDriver,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] as String,
      vehicleNumber: json['VehicleNumber'] as String,
      activeDriver: json['ActiveDriver'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'VehicleNumber': vehicleNumber,
      'ActiveDriver': activeDriver,
    };
  }
}