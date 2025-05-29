class AssignDriverModel {
  final String? message;

  AssignDriverModel({this.message});

  factory AssignDriverModel.fromJson(Map<String, dynamic> json) {
    return AssignDriverModel(
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
