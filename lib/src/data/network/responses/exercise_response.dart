import 'package:miracle/src/data/model/exercise.dart';

class ExerciseResponse {
  bool status;
  String message;

  List<Exercise> data;

  ExerciseResponse(
      {required this.status, required this.data, required this.message});

  factory ExerciseResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final data = <Exercise>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Exercise.fromJson(v));
      });
    }
    final message = json['message'];

    return ExerciseResponse(status: status, data: data, message: message);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['message'] = message;
    return data;
  }

  @override
  String toString() =>
      'ExerciseResponse(status: $status, data: $data, message: $message)';
}
