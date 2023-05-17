// ignore_for_file: unnecessary_null_comparison

class Tutor {
  String? video;
  String? bio;
  String? education;
  String? experience;
  dynamic accent;
  String? targetStudent;
  double? rating;
  dynamic isNative;
  late String profession;
  late String interests;
  late User user;
  late String languages;
  late String specialties;
  late bool isFavorite;
  late double avgRating;
  late int totalFeedback;

  Tutor(
      {this.video,
      this.bio,
      this.education,
      this.experience,
      this.accent,
      this.targetStudent,
      this.rating,
      this.isNative,
      required this.profession,
      required this.interests,
      required this.user,
      required this.languages,
      required this.specialties,
      required this.isFavorite,
      required this.avgRating,
      required this.totalFeedback});

  Tutor.fromJson(Map<String, dynamic> json) {
    video = json['video'];
    bio = json['bio'];
    education = json['education'];
    experience = json['experience'];
    profession = json['profession'];
    accent = json['accent'];
    targetStudent = json['targetStudent'];
    interests = json['interests'];
    languages = json['languages'];
    specialties = json['specialties'];
    rating = json['rating'];
    isNative = json['isNative'];
    user = (json['User'] != null ? User.fromJson(json['User']) : null) ??
        User(courses: [], id: "", name: "", country: "", isPublicRecord: false);
    isFavorite = json['isFavorite'];
    avgRating = json['avgRating'].toDouble();
    totalFeedback = json['totalFeedback'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video'] = video;
    data['bio'] = bio;
    data['education'] = education;
    data['experience'] = experience;
    data['profession'] = profession;
    data['accent'] = accent;
    data['targetStudent'] = targetStudent;
    data['interests'] = interests;
    data['languages'] = languages;
    data['specialties'] = specialties;
    data['rating'] = rating;
    data['isNative'] = isNative;
    if (user != null) {
      data['User'] = user.toJson();
    }
    data['isFavorite'] = isFavorite;
    data['avgRating'] = avgRating;
    data['totalFeedback'] = totalFeedback;
    return data;
  }
}

class User {
  String? level;
  String? language;
  String? avatar;
  String? caredByStaffId;
  String? studentGroupId;
  late bool isPublicRecord;
  late String country;
  late String name;
  late String id;
  late List<Courses> courses;

  User(
      {this.level,
      this.avatar,
      this.language,
      this.caredByStaffId,
      this.studentGroupId,
      required this.id,
      required this.name,
      required this.country,
      required this.isPublicRecord,
      required this.courses});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    avatar = json['avatar'];
    name = json['name'];
    country = json['country'];
    language = json['language'];
    isPublicRecord = json['isPublicRecord'];
    caredByStaffId = json['caredByStaffId'];
    studentGroupId = json['studentGroupId'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses.add(Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['avatar'] = avatar;
    data['name'] = name;
    data['country'] = country;
    data['language'] = language;
    data['isPublicRecord'] = isPublicRecord;
    data['caredByStaffId'] = caredByStaffId;
    data['studentGroupId'] = studentGroupId;
    if (courses != null) {
      data['courses'] = courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  String? id;
  String? name;
  TutorCourse? tutorCourse;

  Courses({this.id, this.name, this.tutorCourse});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tutorCourse = json['TutorCourse'] != null
        ? TutorCourse.fromJson(json['TutorCourse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (tutorCourse != null) {
      data['TutorCourse'] = tutorCourse!.toJson();
    }
    return data;
  }
}

class TutorCourse {
  String? userId;
  String? courseId;
  String? createdAt;
  String? updatedAt;

  TutorCourse({this.userId, this.courseId, this.createdAt, this.updatedAt});

  TutorCourse.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    courseId = json['CourseId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['CourseId'] = courseId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
