class AcceptBookingResponse {
  final bool success;
  final String message;

  AcceptBookingResponse({
    required this.success,
    required this.message,
  });

  factory AcceptBookingResponse.fromJson(Map<String, dynamic> json) {
    return AcceptBookingResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
