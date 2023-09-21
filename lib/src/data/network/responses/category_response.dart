import 'package:miracle/src/data/model/category.dart';

class CategoryResponse {
  bool status;
  String message;

  List<Category> data;

  CategoryResponse(
      {required this.status, required this.data, required this.message});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final data = <Category>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Category.fromJson(v));
      });
    }
    final message = json['message'];

    return CategoryResponse(status: status, data: data, message: message);
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
      'CategoryResponse(status: $status, data: $data, message: $message)';
}
