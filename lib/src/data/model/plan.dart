class Plan {
  String renewableDate;
  String planName;
  String dayRemains;
  Plan({
    required this.renewableDate,
    required this.planName,
    required this.dayRemains,
  });

  Map<String, dynamic> toJson() {
    return {
      'renewableDate': renewableDate,
      'planName': planName,
      'dayRemains': dayRemains,
    };
  }

  factory Plan.fromJson(Map<String, dynamic> map) {
    return Plan(
      renewableDate: map['renewableDate'] ?? '',
      planName: map['planName'] ?? '',
      dayRemains: map['dayRemains'] ?? '',
    );
  }
}
