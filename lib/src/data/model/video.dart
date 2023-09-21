class Video {
  final int id;
  final String title;
  final String video;
  final String image;
  final bool isFree;
  Video({
    required this.id,
    required this.title,
    required this.video,
    required this.image,
    required this.isFree,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      video: json['video'],
      image: json['image'],
      isFree: json['is_free'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'video': video,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Video(id: $id, title: $title, video: $video, image: $image)';
  }
}
