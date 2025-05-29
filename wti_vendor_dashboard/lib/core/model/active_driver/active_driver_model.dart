class ActiveDriverModel {
  final String? activeDriver;

  ActiveDriverModel({this.activeDriver});

  factory ActiveDriverModel.fromJson(Map<String, dynamic> json) {
    return ActiveDriverModel(
      activeDriver: json['activeDriver'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeDriver': activeDriver,
    };
  }
}
