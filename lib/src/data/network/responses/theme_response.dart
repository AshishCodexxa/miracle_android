import 'package:miracle/src/data/model/background_theme.dart';

class ThemeResponse {
  final bool status;
  final String message;
  final List<BackgroundTheme> data;

  ThemeResponse(
      {required this.status, required this.message, required this.data});

  factory ThemeResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as bool;
    final message = json['message'] as String;
    late List<BackgroundTheme> data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(BackgroundTheme.fromJson(v));
      });
    }
    return ThemeResponse(status: status, message: message, data: data);
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
      'ThemeResponse(status: $status, data: $data, message: $message)';
}
