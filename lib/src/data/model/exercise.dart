class Exercise {
  final int id;
  final String title;
  final String exercise;
  final String image;
  final bool isFree;
  Exercise({
    required this.id,
    required this.title,
    required this.exercise,
    required this.image,
    required this.isFree,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      exercise: json['exercise'],
      image: json['image'],
      isFree: json['is_free'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'exercise': exercise,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, exercise: $exercise, image: $image)';
  }
}
