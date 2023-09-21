import 'package:miracle/src/data/model/collection.dart';

class CollectionResponse {
  bool status;
  List<Collection> data;
  String message;

  CollectionResponse(
      {required this.status, required this.data, required this.message});

  factory CollectionResponse.fromJson(Map<String, dynamic> json) {
    final success = json['status'];
    final data = <Collection>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Collection.fromJson(v));
      });
    }
    final message = json['message'];
    return CollectionResponse(status: success, data: data, message: message);
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
      'CollectionResponse(status: $status, data: $data, message: $message)';
}
