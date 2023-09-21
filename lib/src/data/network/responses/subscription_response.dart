import 'package:miracle/src/data/model/subscription.dart';

class SubscriptionResponse {
  bool success;
  String message;
  List<Subscription> data;

  SubscriptionResponse(
      {required this.success, required this.message, required this.data});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    final success = json['success'];
    final message = json['message'];
    final data = <Subscription>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Subscription.fromJson(v));
      });
    }
    return SubscriptionResponse(success: success, message: message, data: data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }

  @override
  String toString() =>
      'SubscriptionResponse(success: $success, message: $message, data: $data)';
}
