class Subscription {
  int id;
  String name;
  int duration;
  int price;
  int discount;

  Subscription({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.discount,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      duration: json['duration'] ?? 0,
      price: json['price'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['price'] = price;
    data['discount'] = discount;
    return data;
  }

  @override
  String toString() {
    return 'Subscription(id: $id, name: $name, duration: $duration, price: $price, discount: $discount)';
  }

  Subscription copyWith({
    int? id,
    String? name,
    int? duration,
    int? price,
    int? discount,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }
}
