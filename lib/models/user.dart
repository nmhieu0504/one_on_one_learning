class User {
  late final String id;
  late final String email;
  late final String name;
  late final String avatar;
  late final String country;
  late final String phone;
  late final List<String> roles;
  late final String language;
  late final String birthday;
  late final bool isActivated;
  late final Map<String, dynamic> walletInfo;
  late final List<Map<String, dynamic>> courses;
  late final String requireNote;
  late final String level;
  late final List<Map<String, dynamic>> learnTopics;
  late final List<Map<String, dynamic>> testPreparations;
  late final bool isPhoneActivated;
  late final double timezone;
  late final String studySchedule;
  late final bool canSendMessage;

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
      courses: List<Map<String, dynamic>>.from(json['courses']),
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
