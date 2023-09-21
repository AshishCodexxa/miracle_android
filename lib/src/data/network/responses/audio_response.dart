import 'package:miracle/src/data/model/audio.dart';

class AudioResponse {
  bool status;
  String message;

  List<Audio> data;

  AudioResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AudioResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final data = <Audio>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Audio.fromJson(v));
      });
    }
    final message = json['message'];

    return AudioResponse(status: status, data: data, message: message);
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
      'AudioResponse(status: $status, data: $data, message: $message)';
}
