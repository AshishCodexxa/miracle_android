import 'package:miracle/src/data/model/quote.dart';

class QuoteResponse {
  bool status;
  List<Quote> data;
  String message;

  QuoteResponse(
      {required this.status, required this.data, required this.message});

  factory QuoteResponse.fromJson(Map<String, dynamic> json) {
    final success = json['status'];
    final data = <Quote>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Quote.fromJson(v));
      });
    }
    final message = json['message'];
    return QuoteResponse(status: success, data: data, message: message);
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
      'QuoteResponse(status: $status, data: $data, message: $message)';
}
