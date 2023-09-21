class Category {
  final int id;
  final String name;
  final String type;
  final String image;
  final int totalQuote;
  Category(
      {required this.id,
      required this.name,
      required this.type,
      required this.image,
      this.totalQuote = 0});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      totalQuote: json['totalQuotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'totalQuotes': totalQuote,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, type: $type, image: $image, totalQuote: $totalQuote)';
  }
}
