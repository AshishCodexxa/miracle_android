import 'package:miracle/src/data/model/video.dart';

class VideoResponse {
  bool status;
  String message;

  List<Video> data;

  VideoResponse(
      {required this.status, required this.data, required this.message});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final data = <Video>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Video.fromJson(v));
      });
    }
    final message = json['message'];

    return VideoResponse(status: status, data: data, message: message);
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
      'VideoResponse(status: $status, data: $data, message: $message)';
}
