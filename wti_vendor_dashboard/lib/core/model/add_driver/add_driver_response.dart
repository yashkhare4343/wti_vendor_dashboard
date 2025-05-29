class AddDriverResponse {
  final String? vendorId;
  final String? driverName;
  final String? mobileNumber;
  final String? dob;
  final String? driverPhoto;
  final String? licenseIdNumber;
  final String? licensePhotoFront;
  final String? licensePhotoBack;
  final String? licenseExpiryDate;
  final String? idProofType;
  final String? idProofFrontPhoto;
  final String? idProofBackPhoto;
  final String? pccPhoto;

  AddDriverResponse({
    this.vendorId,
    this.driverName,
    this.mobileNumber,
    this.dob,
    this.driverPhoto,
    this.licenseIdNumber,
    this.licensePhotoFront,
    this.licensePhotoBack,
    this.licenseExpiryDate,
    this.idProofType,
    this.idProofFrontPhoto,
    this.idProofBackPhoto,
    this.pccPhoto,
  });

  factory AddDriverResponse.fromJson(Map<String, dynamic> json) {
    return AddDriverResponse(
      vendorId: json['VendorId'] as String?,
      driverName: json['DriverName'] as String?,
      mobileNumber: json['MobileNumber'] as String?,
      dob: json['DoB'] as String?,
      driverPhoto: json['Driverphoto'] as String?,
      licenseIdNumber: json['LicenseIdNumber'] as String?,
      licensePhotoFront: json['LicensePhotoFront'] as String?,
      licensePhotoBack: json['LicensePhotoBack'] as String?,
      licenseExpiryDate: json['LicenseExpiryDate'] as String?,
      idProofType: json['Idprooftype'] as String?,
      idProofFrontPhoto: json['IdproofFrontPhoto'] as String?,
      idProofBackPhoto: json['IdproofBackPhoto'] as String?,
      pccPhoto: json['pccPhoto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VendorId': vendorId,
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
    };
  }
}
