// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/schedule.dart';
import '../utils/backend.dart';
import '../utils/share_pref.dart';

class ScheduleServices {
  static Future<dynamic> loadHistoryData(int page, int perPage) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    int date = DateTime.now().millisecondsSinceEpoch;
    final response = await http.get(
        Uri.parse(
            "${API_URL.GET_SCHEDULE_INFO}page=$page&perPage=$perPage&dateTimeLte=$date&orderBy=meeting&sortBy=desc"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      print(response.body);
      var res = jsonDecode(response.body);
      List<ScheduleModel> dataList = [];
      for (var element in res["data"]["rows"]) {
        Map<String, dynamic> data = {};

        data["studentRequest"] = element["studentRequest"];
        data["date"] = DateTime.parse(
            element["scheduleDetailInfo"]["scheduleInfo"]["date"]);
        data["startTimestamp"] = DateTime.fromMillisecondsSinceEpoch(
            element["scheduleDetailInfo"]["scheduleInfo"]["startTimestamp"]);
        data["endTimestamp"] = DateTime.fromMillisecondsSinceEpoch(
            element["scheduleDetailInfo"]["scheduleInfo"]["endTimestamp"]);
        data["avatar"] = element["scheduleDetailInfo"]["scheduleInfo"]
            ["tutorInfo"]["avatar"];
        data["name"] =
            element["scheduleDetailInfo"]["scheduleInfo"]["tutorInfo"]["name"];
        data["country"] = element["scheduleDetailInfo"]["scheduleInfo"]
            ["tutorInfo"]["country"];
        data["lessonStatus"] =
            element["classReview"]?["lessonStatus"]["status"];
        data["behaviorRating"] = element["classReview"]?["behaviorRating"];
        data["listeningRating"] = element["classReview"]?["listeningRating"];
        data["speakingRating"] = element["classReview"]?["speakingRating"];
        data["vocabularyRating"] = element["classReview"]?["vocabularyRating"];
        data["behaviorComment"] = element["classReview"]?["behaviorComment"];
        data["listeningComment"] = element["classReview"]?["listeningComment"];
        data["speakingComment"] = element["classReview"]?["speakingComment"];
        data["vocabularyComment"] =
            element["classReview"]?["vocabularyComment"];
        data["homeworkComment"] = element["classReview"]?["homeworkComment"];
        data["overallComment"] = element["classReview"]?["overallComment"];
        data["book"] = element["classReview"]?["book"];
        data["unit"] = element["classReview"]?["unit"];
        data["lesson"] = element["classReview"]?["lesson"];
        data["page"] = element["classReview"]?["page"];
        data["lessonProgress"] = element["classReview"]?["lessonProgress"];
        data["classReview"] = element["classReview"] != null;

        dataList.add(ScheduleModel.fromJson(data));
      }
      return dataList;
    }
    return null;
  }

  static Future<dynamic> loadScheduleData(int page, int perPage) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    int date = DateTime.now().millisecondsSinceEpoch;
    final response = await http.get(
        Uri.parse(
            "${API_URL.GET_SCHEDULE_INFO}page=$page&perPage=$perPage&dateTimeGte=$date&orderBy=meeting&sortBy=asc"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      print(response.body);
      var res = jsonDecode(response.body);
      List<ScheduleModel> dataList = [];
      for (var element in res["data"]["rows"]) {
        Map<String, dynamic> data = {};

        data["scheduleDetailId"] = element["id"];
        data["studentRequest"] = element["studentRequest"];
        data["date"] = DateTime.parse(
            element["scheduleDetailInfo"]["scheduleInfo"]["date"]);
        data["startTimestamp"] = DateTime.fromMillisecondsSinceEpoch(
            element["scheduleDetailInfo"]["scheduleInfo"]["startTimestamp"]);
        data["endTimestamp"] = DateTime.fromMillisecondsSinceEpoch(
            element["scheduleDetailInfo"]["scheduleInfo"]["endTimestamp"]);
        data["avatar"] = element["scheduleDetailInfo"]["scheduleInfo"]
            ["tutorInfo"]["avatar"];
        data["name"] =
            element["scheduleDetailInfo"]["scheduleInfo"]["tutorInfo"]["name"];
        data["country"] = element["scheduleDetailInfo"]["scheduleInfo"]
            ["tutorInfo"]["country"];
        data["lessonStatus"] =
            element["classReview"]?["lessonStatus"]["status"];
        data["behaviorRating"] = element["classReview"]?["behaviorRating"];
        data["listeningRating"] = element["classReview"]?["listeningRating"];
        data["speakingRating"] = element["classReview"]?["speakingRating"];
        data["vocabularyRating"] = element["classReview"]?["vocabularyRating"];
        data["behaviorComment"] = element["classReview"]?["behaviorComment"];
        data["listeningComment"] = element["classReview"]?["listeningComment"];
        data["speakingComment"] = element["classReview"]?["speakingComment"];
        data["vocabularyComment"] =
            element["classReview"]?["vocabularyComment"];
        data["homeworkComment"] = element["classReview"]?["homeworkComment"];
        data["overallComment"] = element["classReview"]?["overallComment"];
        data["book"] = element["classReview"]?["book"];
        data["unit"] = element["classReview"]?["unit"];
        data["lesson"] = element["classReview"]?["lesson"];
        data["page"] = element["classReview"]?["page"];
        data["lessonProgress"] = element["classReview"]?["lessonProgress"];
        data["classReview"] = element["classReview"] != null;

        dataList.add(ScheduleModel.fromJson(data));
      }
      return dataList;
    }
    return null;
  }

  static Future<bool> deleteSchdule(
      String scheduleDetailId, String note, int cancelReasonId) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http.delete(Uri.parse(API_URL.DELETE_SCHEDULE),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "scheduleDetailId": scheduleDetailId,
          "cancelInfo": {"cancelReasonId": cancelReasonId, "note": note}
        }));

    print("delete: $scheduleDetailId");
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    }
    return false;
  }
}
