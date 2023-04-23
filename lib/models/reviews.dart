class Reviews {
  final String avatar;
  final String name;
  final String createdAt;
  final String content;
  final int rating;

  Reviews(
      {required this.avatar,
      required this.name,
      required this.createdAt,
      required this.content,
      required this.rating});

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
        avatar: json['avatar'],
        name: json['name'],
        createdAt: json['createdAt'],
        content: json['content'],
        rating: json['rating']);
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'createdAt': createdAt,
      'content': content,
      'rating': rating,
    };
  }
}
