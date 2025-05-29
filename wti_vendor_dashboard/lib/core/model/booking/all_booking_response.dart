class AllBookingResponse {
  final num currentPage;
  final num totalPages;
  final num totalItems;
  final List<Booking> bookings;

  AllBookingResponse({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.bookings,
  });

  factory AllBookingResponse.fromJson(Map<String, dynamic> json) {
    print('AllBookingResponse JSON: $json'); // Debug
    return AllBookingResponse(
      currentPage: json['currentPage'] as num? ?? 0,
      totalPages: json['totalPages'] as num? ?? 0,
      totalItems: json['totalItems'] as num? ?? 0,
      bookings: (json['bookings'] as List<dynamic>?)
          ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

// Model for each booking
class Booking {
  final FareDetails fareDetails;
  final VehicleDetails vehicleDetails;
  final Location source;
  final Location destination;
  final TripTypeDetails tripTypeDetails;
  final Passenger passenger;
  final CalendarPrice calendarPrice;
  final OtherData otherData;
  final String id;
  final String referenceNumber;
  final String partnerName;
  final String? paymentId;
  final DateTime startTime;
  final DateTime endTime;
  final num platformFee;
  final num bookingGst;
  final num oneWayDistance;
  final num distance;
  final List<String> flags;
  final String vehicleType;
  final String vehicleSubcategory;
  final String verificationCode;
  final List<Stopover> stopovers;
  final bool paid;
  final num amountToBeCollected;
  final String? cancelledBy;
  final String? cancellationReason;
  final String? cancelTime;
  final String bookingStatus;
  final String? driverAllocated;
  final String? carAllocated;
  final String vendorAllocation;
  final String? startLatitude;
  final String? startLongitude;
  final String? startTimeString;
  final String? guestPickLatitude;
  final String? guestPickLongitude;
  final String? guestPickTime;
  final String? guestBoardedTime;
  final String? guestBoardedLatitude;
  final String? guestBoardedLongitude;
  final num? odometerStartReading;
  final num? odometerEndReading;
  final String? odometerStartImage;
  final String? odometerEndImage;
  final String? guestNotBoardedLatitude;
  final String? guestNotBoardedLongitude;
  final String? guestNotBoardedTime;
  final String? guestNotBoardedReason;
  final String? currentLatitude;
  final String? currentLongitude;
  final String? currentTime;
  final String? currentLocationId;
  final String? deviceId;
  final String? guestDropLatitude;
  final String? guestDropLongitude;
  final String? guestDropTime;
  final String? stopLatitude;
  final String? stopLongitude;
  final String? stopTime;
  final bool startBySystem;
  final bool arrivedBySystem;
  final bool boardedBySystem;
  final bool alightBySystem;
  final bool notBoardedBySystem;
  final String tripState;
  final String? version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num v;
  final String orderReferenceNumber;
  final num totalFare;
  final bool guestBoarded;

  Booking({
    required this.fareDetails,
    required this.vehicleDetails,
    required this.source,
    required this.destination,
    required this.tripTypeDetails,
    required this.passenger,
    required this.calendarPrice,
    required this.otherData,
    required this.id,
    required this.referenceNumber,
    required this.partnerName,
    this.paymentId,
    required this.startTime,
    required this.endTime,
    required this.platformFee,
    required this.bookingGst,
    required this.oneWayDistance,
    required this.distance,
    required this.flags,
    required this.vehicleType,
    required this.vehicleSubcategory,
    required this.verificationCode,
    required this.stopovers,
    required this.paid,
    required this.amountToBeCollected,
    this.cancelledBy,
    this.cancellationReason,
    this.cancelTime,
    required this.bookingStatus,
    this.driverAllocated,
    this.carAllocated,
    required this.vendorAllocation,
    this.startLatitude,
    this.startLongitude,
    this.startTimeString,
    this.guestPickLatitude,
    this.guestPickLongitude,
    this.guestPickTime,
    this.guestBoardedTime,
    this.guestBoardedLatitude,
    this.guestBoardedLongitude,
    this.odometerStartReading,
    this.odometerEndReading,
    this.odometerStartImage,
    this.odometerEndImage,
    this.guestNotBoardedLatitude,
    this.guestNotBoardedLongitude,
    this.guestNotBoardedTime,
    this.guestNotBoardedReason,
    this.currentLatitude,
    this.currentLongitude,
    this.currentTime,
    this.currentLocationId,
    this.deviceId,
    this.guestDropLatitude,
    this.guestDropLongitude,
    this.guestDropTime,
    this.stopLatitude,
    this.stopLongitude,
    this.stopTime,
    required this.startBySystem,
    required this.arrivedBySystem,
    required this.boardedBySystem,
    required this.alightBySystem,
    required this.notBoardedBySystem,
    required this.tripState,
    this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.orderReferenceNumber,
    required this.totalFare,
    required this.guestBoarded,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    print('Booking JSON: $json');
    return Booking(
      fareDetails: FareDetails.fromJson(json['fare_details'] as Map<String, dynamic>? ?? {}),
      vehicleDetails: VehicleDetails.fromJson(json['vehicle_details'] as Map<String, dynamic>? ?? {}),
      source: Location.fromJson(json['source'] as Map<String, dynamic>? ?? {}),
      destination: Location.fromJson(json['destination'] as Map<String, dynamic>? ?? {}),
      tripTypeDetails: TripTypeDetails.fromJson(json['trip_type_details'] as Map<String, dynamic>? ?? {}),
      passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>? ?? {}),
      calendarPrice: CalendarPrice.fromJson(json['CalendarPrice'] as Map<String, dynamic>? ?? {}),
      otherData: OtherData.fromJson(json['otherdata'] as Map<String, dynamic>? ?? {}),
      id: json['_id'] as String? ?? '',
      referenceNumber: json['reference_number'] as String? ?? '',
      partnerName: json['partnername'] as String? ?? '',
      paymentId: json['payment_id'] as String?,
      startTime: DateTime.tryParse(json['start_time'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['end_time'] as String? ?? '') ?? DateTime.now(),
      platformFee: json['platform_fee'] as num? ?? 0,
      bookingGst: json['booking_gst'] as num? ?? 0,
      oneWayDistance: json['one_way_distance'] as num? ?? 0,
      distance: json['distance'] as num? ?? 0,
      flags: (json['flags'] as List<dynamic>?)?.cast<String>() ?? [],
      vehicleType: json['vehicle_type'] as String? ?? '',
      vehicleSubcategory: json['vehicle_subcategory'] as String? ?? '',
      verificationCode: json['verification_code'] as String? ?? '',
      stopovers: (json['stopovers'] as List<dynamic>?)
          ?.map((e) => Stopover.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      paid: json['paid'] as bool? ?? false,
      amountToBeCollected: json['amount_to_be_collected'] as num? ?? 0,
      cancelledBy: json['cancelled_by'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelTime: json['canceltime'] as String?,
      bookingStatus: json['BookingStatus'] as String? ?? 'UNKNOWN',
      driverAllocated: json['DriverAllocated'] as String?,
      carAllocated: json['CarAllocated'] as String?,
      vendorAllocation: json['VendorAllocation'] as String? ?? '',
      startLatitude: json['StartLatitude'] as String?,
      startLongitude: json['StartLongitude'] as String?,
      startTimeString: json['StartTime'] as String?,
      guestPickLatitude: json['GuestPickLatitude'] as String?,
      guestPickLongitude: json['GuestPickLongitude'] as String?,
      guestPickTime: json['GuestPickTime'] as String?,
      guestBoardedTime: json['GuestBoardedTime'] as String?,
      guestBoardedLatitude: json['GuestBoardedLatitude'] as String?,
      guestBoardedLongitude: json['GuestBoardedLongitude'] as String?,
      odometerStartReading: json['OdometerStartReading'] as num?,
      odometerEndReading: json['OdometerEndReading'] as num?,
      odometerStartImage: json['OdometerStartImage'] as String?,
      odometerEndImage: json['OdometerEndImage'] as String?,
      guestNotBoardedLatitude: json['GuestNotBoardedLatitude'] as String?,
      guestNotBoardedLongitude: json['GuestNotBoardedLongitude'] as String?,
      guestNotBoardedTime: json['GuestNotBoardedTime'] as String?,
      guestNotBoardedReason: json['GuestNotBoardedReason'] as String?,
      currentLatitude: json['CurrentLatitude'] as String?,
      currentLongitude: json['CurrentLongitude'] as String?,
      currentTime: json['CurrentTime'] as String?,
      currentLocationId: json['currentLocationID'] as String?,
      deviceId: json['device_id'] as String?,
      guestDropLatitude: json['GuestDropLatitude'] as String?,
      guestDropLongitude: json['GuestDropLongitude'] as String?,
      guestDropTime: json['GuestDropTime'] as String?,
      stopLatitude: json['StopLatitude'] as String?,
      stopLongitude: json['StopLongitude'] as String?,
      stopTime: json['StopTime'] as String?,
      startBySystem: json['StartBySystem'] as bool? ?? false,
      arrivedBySystem: json['ArrivedBySystem'] as bool? ?? false,
      boardedBySystem: json['BoardedBySystem'] as bool? ?? false,
      alightBySystem: json['AlightBySystem'] as bool? ?? false,
      notBoardedBySystem: json['NotBoardedBySystem'] as bool? ?? false,
      tripState: json['trip_state'] as String? ?? 'UNKNOWN',
      version: json['version'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      v: json['__v'] as num? ?? 0,
      orderReferenceNumber: json['order_reference_number'] as String? ?? '',
      totalFare: json['total_fare'] as num? ?? 0,
      guestBoarded: json['GuestBoarded'] as bool? ?? false,
    );
  }
}
class FareDetails {
  final RouteFareDetails routeFareDetails;
  final num addOnPercent;
  final num holidayHike;
  final num baseFare;
  final num totalDriverCharges;
  final num stateTax;
  final num tollCharges;
  final num nightCharges;
  final num totalFare;
  final num airportEntryFee;
  final num baseKm;

  FareDetails({
    required this.routeFareDetails,
    required this.addOnPercent,
    required this.holidayHike,
    required this.baseFare,
    required this.totalDriverCharges,
    required this.stateTax,
    required this.tollCharges,
    required this.nightCharges,
    required this.totalFare,
    required this.airportEntryFee,
    required this.baseKm,
  });

  factory FareDetails.fromJson(Map<String, dynamic> json) {
    return FareDetails(
      routeFareDetails: RouteFareDetails.fromJson(json['Route_fare_Details'] as Map<String, dynamic>? ?? {}),
      addOnPercent: json['addOnPercent'] as num? ?? 0,
      holidayHike: json['holidayhike'] as num? ?? 0,
      baseFare: json['base_fare'] as num? ?? 0,
      totalDriverCharges: json['total_driver_charges'] as num? ?? 0,
      stateTax: json['state_tax'] as num? ?? 0,
      tollCharges: json['toll_charges'] as num? ?? 0,
      nightCharges: json['night_charges'] as num? ?? 0,
      totalFare: json['total_fare'] as num? ?? 0,
      airportEntryFee: json['airport_entry_fee'] as num? ?? 0,
      baseKm: json['base_km'] as num? ?? 0,
    );
  }
}

class RouteFareDetails {
  final ExtraTimeFare extraTimeFare;
  final ExtraCharges extraCharges;
  final num perKmCharge;
  final num perKmExtraCharge;
  final num driverChargePerDay;

  RouteFareDetails({
    required this.extraTimeFare,
    required this.extraCharges,
    required this.perKmCharge,
    required this.perKmExtraCharge,
    required this.driverChargePerDay,
  });

  factory RouteFareDetails.fromJson(Map<String, dynamic> json) {
    return RouteFareDetails(
      extraTimeFare: ExtraTimeFare.fromJson(json['extra_time_fare'] as Map<String, dynamic>? ?? {}),
      extraCharges: ExtraCharges.fromJson(json['extra_charges'] as Map<String, dynamic>? ?? {}),
      perKmCharge: json['per_km_charge'] as num? ?? 0,
      perKmExtraCharge: json['per_km_extra_charge'] as num? ?? 0,
      driverChargePerDay: json['Driver_charge_perday'] as num? ?? 0,
    );
  }
}

class ExtraTimeFare {
  final num rate;
  final num applicableTime;

  ExtraTimeFare({
    required this.rate,
    required this.applicableTime,
  });

  factory ExtraTimeFare.fromJson(Map<String, dynamic> json) {
    return ExtraTimeFare(
      rate: json['rate'] as num? ?? 0,
      applicableTime: json['applicable_time'] as num? ?? 0,
    );
  }
}

class ExtraCharges {
  final NightCharges nightCharges;
  final TollCharges tollCharges;
  final StateTax stateTax;
  final ParkingCharges parkingCharges;
  final WaitingCharges waitingCharges;

  ExtraCharges({
    required this.nightCharges,
    required this.tollCharges,
    required this.stateTax,
    required this.parkingCharges,
    required this.waitingCharges,
  });

  factory ExtraCharges.fromJson(Map<String, dynamic> json) {
    return ExtraCharges(
      nightCharges: NightCharges.fromJson(json['night_charges'] as Map<String, dynamic>? ?? {}),
      tollCharges: TollCharges.fromJson(json['toll_charges'] as Map<String, dynamic>? ?? {}),
      stateTax: StateTax.fromJson(json['state_tax'] as Map<String, dynamic>? ?? {}),
      parkingCharges: ParkingCharges.fromJson(json['parking_charges'] as Map<String, dynamic>? ?? {}),
      waitingCharges: WaitingCharges.fromJson(json['waiting_charges'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class NightCharges {
  final num amount;
  final bool isIncludedInBaseFare;
  final bool isIncludedInGrandTotal;
  final num applicableTimeFrom;
  final num applicableTimeTill;

  NightCharges({
    required this.amount,
    required this.isIncludedInBaseFare,
    required this.isIncludedInGrandTotal,
    required this.applicableTimeFrom,
    required this.applicableTimeTill,
  });

  factory NightCharges.fromJson(Map<String, dynamic> json) {
    return NightCharges(
      amount: json['amount'] as num? ?? 0,
      isIncludedInBaseFare: json['is_included_in_base_fare'] as bool? ?? false,
      isIncludedInGrandTotal: json['is_included_in_grand_total'] as bool? ?? false,
      applicableTimeFrom: json['applicable_time_from'] as num? ?? 0,
      applicableTimeTill: json['applicable_time_till'] as num? ?? 0,
    );
  }
}

class TollCharges {
  final num amount;
  final bool isIncludedInBaseFare;
  final bool isIncludedInGrandTotal;

  TollCharges({
    required this.amount,
    required this.isIncludedInBaseFare,
    required this.isIncludedInGrandTotal,
  });

  factory TollCharges.fromJson(Map<String, dynamic> json) {
    return TollCharges(
      amount: json['amount'] as num? ?? 0,
      isIncludedInBaseFare: json['is_included_in_base_fare'] as bool? ?? false,
      isIncludedInGrandTotal: json['is_included_in_grand_total'] as bool? ?? false,
    );
  }
}

class StateTax {
  final num amount;
  final bool isIncludedInBaseFare;
  final bool isIncludedInGrandTotal;

  StateTax({
    required this.amount,
    required this.isIncludedInBaseFare,
    required this.isIncludedInGrandTotal,
  });

  factory StateTax.fromJson(Map<String, dynamic> json) {
    return StateTax(
      amount: json['amount'] as num? ?? 0,
      isIncludedInBaseFare: json['is_included_in_base_fare'] as bool? ?? false,
      isIncludedInGrandTotal: json['is_included_in_grand_total'] as bool? ?? false,
    );
  }
}

class ParkingCharges {
  final num amount;
  final bool isIncludedInBaseFare;
  final bool isIncludedInGrandTotal;

  ParkingCharges({
    required this.amount,
    required this.isIncludedInBaseFare,
    required this.isIncludedInGrandTotal,
  });

  factory ParkingCharges.fromJson(Map<String, dynamic> json) {
    return ParkingCharges(
      amount: json['amount'] as num? ?? 0,
      isIncludedInBaseFare: json['is_included_in_base_fare'] as bool? ?? false,
      isIncludedInGrandTotal: json['is_included_in_grand_total'] as bool? ?? false,
    );
  }
}

class WaitingCharges {
  final num amount;
  final num freeWaitingTime;
  final num applicableTime;

  WaitingCharges({
    required this.amount,
    required this.freeWaitingTime,
    required this.applicableTime,
  });

  factory WaitingCharges.fromJson(Map<String, dynamic> json) {
    return WaitingCharges(
      amount: json['amount'] as num? ?? 0,
      freeWaitingTime: json['free_waiting_time'] as num? ?? 0,
      applicableTime: json['applicable_time'] as num? ?? 0,
    );
  }
}

class VehicleDetails {
  final String skuId;
  final String type;
  final String subcategory;
  final String combustionType;
  final String model;
  final bool carrier;
  final String makeYearType;

  VehicleDetails({
    required this.skuId,
    required this.type,
    required this.subcategory,
    required this.combustionType,
    required this.model,
    required this.carrier,
    required this.makeYearType,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      skuId: json['sku_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      subcategory: json['subcategory'] as String? ?? '',
      combustionType: json['combustion_type'] as String? ?? '',
      model: json['model'] as String? ?? '',
      carrier: json['carrier'] as bool? ?? false,
      makeYearType: json['make_year_type'] as String? ?? '',
    );
  }
}

class Location {
  final String address;
  final num latitude;
  final num longitude;
  final String city;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.city,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String? ?? '',
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      city: json['city'] as String? ?? '',
    );
  }
}

class TripTypeDetails {
  final String basicTripType;
  final String tripType;
  final String airportType;
  final String tripTypeCamel;

  TripTypeDetails({
    required this.basicTripType,
    required this.tripType,
    required this.airportType,
    required this.tripTypeCamel,
  });

  factory TripTypeDetails.fromJson(Map<String, dynamic> json) {
    return TripTypeDetails(
      basicTripType: json['basic_trip_type'] as String? ?? '',
      tripType: json['trip_type'] as String? ?? '',
      airportType: json['airport_type'] as String? ?? '',
      tripTypeCamel: json['trip_type'] as String? ?? '',
    );
  }
}

class Passenger {
  final String name;
  final String email;
  final num phoneNumber;
  final num countryCode;
  final bool messageSend;

  Passenger({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.messageSend,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as num? ?? 0,
      countryCode: json['country_code'] as num? ?? 0,
      messageSend: json['messagesend'] as bool? ?? false,
    );
  }
}

class CalendarPrice {
  final num? calendarBaseFare;

  CalendarPrice({
    this.calendarBaseFare,
  });

  factory CalendarPrice.fromJson(Map<String, dynamic> json) {
    return CalendarPrice(
      calendarBaseFare: json['calendarBaseFare'] as num?,
    );
  }
}

class OtherData {
  final String? countryName;
  final String? searchId;
  final List<dynamic> extrasSelected;

  OtherData({
    this.countryName,
    this.searchId,
    required this.extrasSelected,
  });

  factory OtherData.fromJson(Map<String, dynamic> json) {
    return OtherData(
      countryName: json['countryName'] as String?,
      searchId: json['search_id'] as String?,
      extrasSelected: json['extrasSelected'] as List<dynamic>? ?? [],
    );
  }
}

class Stopover {
  final String address;
  final num latitude;
  final num longitude;
  final String id;

  Stopover({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.id,
  });

  factory Stopover.fromJson(Map<String, dynamic> json) {
    return Stopover(
      address: json['address'] as String? ?? '',
      latitude: json['latitude'] as num? ?? 0,
      longitude: json['longitude'] as num? ?? 0,
      id: json['_id'] as String? ?? '',
    );
  }
}