class ScheduleModel {
  final String id;
  final DateTime date;
  final String avatar;
  final String name;
  final String country;
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final String? behaviorComment;
  final String? listeningComment;
  final String? speakingComment;
  final String? vocabularyComment;
  final String? overallComment;
  final int? behaviorRating;
  final int? listeningRating;
  final int? speakingRating;
  final int? vocabularyRating;
  final String? lessonStatus;
  final String? studentRequest;
  final String? homeworkComment;
  final String? book;
  final String? unit;
  final String? lesson;
  final String? page;
  final String? lessonProgress;
  final String? scheduleDetailId;
  final bool classReview;
  final List<dynamic> feedbacks;

  ScheduleModel(
      {required this.id,
      required this.date,
      required this.avatar,
      required this.name,
      required this.country,
      required this.startTimestamp,
      required this.endTimestamp,
      required this.studentRequest,
      required this.lessonStatus,
      required this.behaviorRating,
      required this.listeningRating,
      required this.speakingRating,
      required this.vocabularyRating,
      required this.behaviorComment,
      required this.listeningComment,
      required this.speakingComment,
      required this.vocabularyComment,
      required this.overallComment,
      required this.classReview,
      required this.homeworkComment,
      required this.book,
      required this.unit,
      required this.lesson,
      required this.page,
      required this.lessonProgress,
      this.scheduleDetailId,
      this.feedbacks = const []});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      date: json['date'],
      avatar: json['avatar'],
      name: json['name'],
      country: json['country'],
      startTimestamp: json['startTimestamp'],
      endTimestamp: json['endTimestamp'],
      studentRequest: json['studentRequest'],
      lessonStatus: json['lessonStatus'],
      behaviorRating: json['behaviorRating'],
      listeningRating: json['listeningRating'],
      speakingRating: json['speakingRating'],
      vocabularyRating: json['vocabularyRating'],
      behaviorComment: json['behaviorComment'],
      listeningComment: json['listeningComment'],
      speakingComment: json['speakingComment'],
      vocabularyComment: json['vocabularyComment'],
      overallComment: json['overallComment'],
      homeworkComment: json['homeworkComment'],
      book: json['book'],
      unit: json['unit'],
      lesson: json['lesson'],
      page: json['page'],
      lessonProgress: json['lessonProgress'],
      classReview: json['classReview'],
      scheduleDetailId: json['scheduleDetailId'],
      feedbacks: json['feedbacks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'avatar': avatar,
      'name': name,
      'country': country,
      'startTimestamp': startTimestamp,
      'endTimestamp': endTimestamp,
      'studentRequest': studentRequest,
      'lessonStatus': lessonStatus,
      'behaviorRating': behaviorRating,
      'listeningRating': listeningRating,
      'speakingRating': speakingRating,
      'vocabularyRating': vocabularyRating,
      'behaviorComment': behaviorComment,
      'listeningComment': listeningComment,
      'speakingComment': speakingComment,
      'vocabularyComment': vocabularyComment,
      'overallComment': overallComment,
      'homeworkComment': homeworkComment,
      'book': book,
      'unit': unit,
      'lesson': lesson,
      'page': page,
      'lessonProgress': lessonProgress,
      'classReview': classReview,
      'scheduleDetailId': scheduleDetailId,
      'feedbacks': feedbacks,
    };
  }
}
