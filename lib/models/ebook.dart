// ignore_for_file: prefer_collection_literals

class EBook {
  String name;
  String description;
  String imageUrl;
  String level;
  String fileUrl;

  EBook(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.level,
      required this.fileUrl});

  factory EBook.fromJson(Map<String, dynamic> json) => EBook(
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        level: json['level'],
        fileUrl: json['fileUrl'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['level'] = level;
    data['fileUrl'] = fileUrl;
    return data;
  }
}
