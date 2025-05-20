class AuthResponse {
  final bool? userExists;
  final String? accessToken;
  final String? role;
  final String? userid;

  AuthResponse({
    this.userExists,
    this.accessToken,
    this.role,
    this.userid,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userExists: json['userExists'] as bool?,
      accessToken: json['accessToken'] as String?,
      role: json['role'] as String?,
      userid: json['userid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userExists': userExists,
      'accessToken': accessToken,
      'role': role,
      'userid': userid,
    };
  }
}
