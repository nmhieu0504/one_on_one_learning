class Course {
  String name;
  String description;
  String level;
  String imageUrl;
  int numberOfTopics;
  String categories;
  String id;
  List<Map<String, dynamic>> topics;
  String reason;
  String purpose;

  Course({
    required this.categories,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.id,
    required this.reason,
    required this.purpose,
    required this.level,
    required this.numberOfTopics,
    required this.topics,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        categories: json['categories'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        id: json['id'],
        reason: json['reason'],
        purpose: json['purpose'],
        level: json['level'],
        numberOfTopics: json['numberOfTopics'],
        topics: List<Map<String, dynamic>>.from(json['topics'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'categories': categories,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'id': id,
        'reason': reason,
        'purpose': purpose,
        'level': level,
        'numberOfTopics': numberOfTopics,
        'topics': List<dynamic>.from(topics.map((x) => x)),
      };
}
