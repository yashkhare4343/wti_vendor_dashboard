class ProfileDetailResponse {
  final Vendor vendor;

  ProfileDetailResponse({required this.vendor});

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailResponse(
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor': vendor.toJson(),
    };
  }
}

class Vendor {
  final String id;
  final String vendorName;
  final String mobile;
  final String email;
  final String baseCity;
  final String gender;
  final String doB;
  final String partnerType;
  final String vehicleNumber;
  final String vehicleRegisterCertificateLink;
  final String photograph;
  final String panCard;
  final String pancardLink;
  final String address;
  final String addressProofType;
  final String addressProofNumber;
  final String addressProofFrontPhoto;
  final String addressProofBackPhoto;
  final String bankName;
  final String ifscCode;
  final String accountNumber;
  final String bankProofType;
  final String accountHolderName;
  final String bankProofDocumentLink;
  final String registerStatus;
  final String message;
  final int v;
  final int billingCycle;
  final int commissionPercentage;
  final String modifyBy;
  final String updatedAt;

  Vendor({
    required this.id,
    required this.vendorName,
    required this.mobile,
    required this.email,
    required this.baseCity,
    required this.gender,
    required this.doB,
    required this.partnerType,
    required this.vehicleNumber,
    required this.vehicleRegisterCertificateLink,
    required this.photograph,
    required this.panCard,
    required this.pancardLink,
    required this.address,
    required this.addressProofType,
    required this.addressProofNumber,
    required this.addressProofFrontPhoto,
    required this.addressProofBackPhoto,
    required this.bankName,
    required this.ifscCode,
    required this.accountNumber,
    required this.bankProofType,
    required this.accountHolderName,
    required this.bankProofDocumentLink,
    required this.registerStatus,
    required this.message,
    required this.v,
    required this.billingCycle,
    required this.commissionPercentage,
    required this.modifyBy,
    required this.updatedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['_id'] as String? ?? '',
      vendorName: json['VendorName'] as String? ?? '',
      mobile: json['Mobile'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      baseCity: json['BaseCity'] as String? ?? '',
      gender: json['Gender'] as String? ?? '',
      doB: json['DoB'] as String? ?? '',
      partnerType: json['PartnerType'] as String? ?? '',
      vehicleNumber: json['VehicleNumber'] as String? ?? '',
      vehicleRegisterCertificateLink: json['VehicleRegisterCertificateLink'] as String? ?? '',
      photograph: json['Photograph'] as String? ?? '',
      panCard: json['panCard'] as String? ?? '',
      pancardLink: json['pancardLink'] as String? ?? '',
      address: json['address'] as String? ?? '',
      addressProofType: json['addressProofType'] as String? ?? '',
      addressProofNumber: json['AdressProofNumber'] as String? ?? '',
      addressProofFrontPhoto: json['addressProofFrontPhoto'] as String? ?? '',
      addressProofBackPhoto: json['addressProofBackPhoto'] as String? ?? '',
      bankName: json['BankName'] as String? ?? '',
      ifscCode: json['IfscCode'] as String? ?? '',
      accountNumber: json['AccountNumber'] as String? ?? '',
      bankProofType: json['BankProofType'] as String? ?? '',
      accountHolderName: json['AccountholderName'] as String? ?? '',
      bankProofDocumentLink: json['BankProofDocumentLink'] as String? ?? '',
      registerStatus: json['RegisterStatus'] as String? ?? '',
      message: json['message'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
      billingCycle: json['BillingCycle'] as int? ?? 0,
      commissionPercentage: json['Commission_Percentage'] as int? ?? 0,
      modifyBy: json['modify_by'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'VendorName': vendorName,
      'Mobile': mobile,
      'Email': email,
      'BaseCity': baseCity,
      'Gender': gender,
      'DoB': doB,
      'PartnerType': partnerType,
      'VehicleNumber': vehicleNumber,
      'VehicleRegisterCertificateLink': vehicleRegisterCertificateLink,
      'Photograph': photograph,
      'panCard': panCard,
      'pancardLink': pancardLink,
      'address': address,
      'addressProofType': addressProofType,
      'AdressProofNumber': addressProofNumber,
      'addressProofFrontPhoto': addressProofFrontPhoto,
      'addressProofBackPhoto': addressProofBackPhoto,
      'BankName': bankName,
      'IfscCode': ifscCode,
      'AccountNumber': accountNumber,
      'BankProofType': bankProofType,
      'AccountholderName': accountHolderName,
      'BankProofDocumentLink': bankProofDocumentLink,
      'RegisterStatus': registerStatus,
      'message': message,
      '__v': v,
      'BillingCycle': billingCycle,
      'Commission_Percentage': commissionPercentage,
      'modify_by': modifyBy,
      'updatedAt': updatedAt,
    };
  }
}