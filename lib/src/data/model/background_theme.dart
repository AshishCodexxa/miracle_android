class BackgroundTheme {
  final int id;
  final String image;
  BackgroundTheme({
    required this.id,
    required this.image,
  });

  factory BackgroundTheme.fromJson(Map<String, dynamic> json) {
    return BackgroundTheme(
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'BackgroundTheme(id: $id, image: $image)';
  }
}
