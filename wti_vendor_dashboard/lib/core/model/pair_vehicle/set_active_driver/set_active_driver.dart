class SetActiveDriverResponse {
  final String message;

  SetActiveDriverResponse({required this.message});

  factory SetActiveDriverResponse.fromJson(Map<String, dynamic> json) {
    return SetActiveDriverResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
