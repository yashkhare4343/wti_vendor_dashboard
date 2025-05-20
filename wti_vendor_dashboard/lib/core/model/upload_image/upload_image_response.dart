class UploadImageResponse {
  final bool fileUploaded;
  final String name;

  UploadImageResponse({
    required this.fileUploaded,
    required this.name,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      fileUploaded: json['fileUploaded'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileUploaded': fileUploaded,
      'name': name,
    };
  }
}
