class User {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String phone;
  final List<String> roles;
  final bool isActivated;
  final Map<String, dynamic> walletInfo;
  final List<Map<String, dynamic>> learnTopics;
  final List<Map<String, dynamic>> testPreparations;
  final int timezone;
  final bool canSendMessage;
  final String? studySchedule;
  final String? birthday;
  final String? level;
  final String? country;
  final List<Map<String, dynamic>>? courses;
  final bool? isPhoneActivated;
  final String? language;
  final String? requireNote;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.country,
    required this.phone,
    required this.roles,
    required this.language,
    required this.birthday,
    required this.isActivated,
    required this.walletInfo,
    required this.courses,
    required this.requireNote,
    required this.level,
    required this.learnTopics,
    required this.testPreparations,
    required this.isPhoneActivated,
    required this.timezone,
    required this.studySchedule,
    required this.canSendMessage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      country: json['country'],
      phone: json['phone'],
      roles: List<String>.from(json['roles']),
      language: json['language'],
      birthday: json['birthday'],
      isActivated: json['isActivated'],
      walletInfo: json['walletInfo'],
      courses: json['courses'] == null
          ? null
          : List<Map<String, dynamic>>.from(json['courses']),
      requireNote: json['requireNote'],
      level: json['level'],
      learnTopics: List<Map<String, dynamic>>.from(json['learnTopics']),
      testPreparations:
          List<Map<String, dynamic>>.from(json['testPreparations']),
      isPhoneActivated: json['isPhoneActivated'],
      timezone: json['timezone'],
      studySchedule: json['studySchedule'],
      canSendMessage: json['canSendMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'country': country,
      'phone': phone,
      'roles': roles,
      'language': language,
      'birthday': birthday,
      'isActivated': isActivated,
      'walletInfo': walletInfo,
      'courses': courses,
      'requireNote': requireNote,
      'level': level,
      'learnTopics': learnTopics,
      'testPreparations': testPreparations,
      'isPhoneActivated': isPhoneActivated,
      'timezone': timezone,
      'studySchedule': studySchedule,
      'canSendMessage': canSendMessage,
    };
  }
}
