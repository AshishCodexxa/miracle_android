class Reminder {
  final int id;
  final String howMany;
  final String startAt;
  final String endAt;
  Reminder({
    required this.id,
    required this.howMany,
    required this.startAt,
    required this.endAt,
  });

  @override
  String toString() {
    return 'Reminder(id: $id, howMany: $howMany, startAt: $startAt, endAt: $endAt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'howMany': howMany,
      'startAt': startAt,
      'endAt': endAt,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      howMany: json['howMany'],
      startAt: json['startAt'],
      endAt: json['endAt'],
    );
  }
}
