class Quote {
  final int id;
  final int categoryId;
  final bool isFree;
  final String quote;
  final String type;
  final String? author;
  final String image;
  final int? favorite;
  final DateTime? addedAt;
  final DateTime? createdAt;
  Quote({
    required this.id,
    required this.isFree,
    required this.quote,
    required this.type,
    required this.image,
    required this.categoryId,
    this.favorite,
    this.author,
    this.addedAt,
    this.createdAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      isFree: (json['is_free'] as int) == 1,
      quote: json['quote'],
      type: json['type'],
      author: json['author'],
      image: json['image'],
      favorite: json['favorite'] ?? 0,
      categoryId: json['category_id'],
      addedAt:
          json['added_at'] != null ? DateTime.parse(json['added_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'is_free': isFree,
      'quote': quote,
      'type': type,
      'author': author,
      'image': image,
      'favorite': favorite,
      'category_id': categoryId,
    };
  }

  @override
  String toString() {
    return 'Quote(id: $id, categoryId: $categoryId, isFree: $isFree, quote: $quote, type: $type, author: $author, image: $image, favorite: $favorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Quote &&
        other.id == id &&
        other.categoryId == categoryId &&
        other.isFree == isFree &&
        other.quote == quote &&
        other.type == type &&
        other.author == author &&
        other.image == image &&
        other.favorite == favorite &&
        other.addedAt == addedAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryId.hashCode ^
        isFree.hashCode ^
        quote.hashCode ^
        type.hashCode ^
        author.hashCode ^
        image.hashCode ^
        favorite.hashCode ^
        addedAt.hashCode ^
        createdAt.hashCode;
  }
}
