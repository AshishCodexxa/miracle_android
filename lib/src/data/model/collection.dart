class Collection {
  final int id;
  final String name;
  final int quotesCount;
  Collection({
    required this.id,
    required this.name,
    required this.quotesCount,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      quotesCount: json['quotes_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quotes_count': quotesCount,
    };
  }

  @override
  String toString() {
    return 'Collection(id: $id, name: $name, quoteCount: $quotesCount)';
  }
}
