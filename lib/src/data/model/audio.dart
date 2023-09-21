class Audio {
  final int id;
  final String title;
  final String content;
  final String image;
  final String audioFile;
  final bool isFree;
  Audio({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.audioFile,
    required this.isFree,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      audioFile: json['audio_file'],
      isFree: json['is_free'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Audio(id: $id, title: $title, content: $content, image: $image)';
  }
}
