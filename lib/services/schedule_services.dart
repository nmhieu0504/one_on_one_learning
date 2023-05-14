// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/schedule.dart';
import '../utils/backend.dart';
import '../utils/share_pref.dart';

class ScheduleServices {
  static Future<List<Map<String, dynamic>>> loadTutorList(
      String selectedSpecialties,
      String searchKeyWord,
      Map<dynamic, dynamic> checkNationality,
      int page,
      int perPage) async {
    SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    String specialtiesChosen;
    if (selectedSpecialties == "ALL") {
      specialtiesChosen = "";
    } else {
      specialtiesChosen = selectedSpecialties;
    }
    var body = {
      "filters": {
        "specialties": [specialtiesChosen],
        "nationality": checkNationality,
        "tutoringTimeAvailable": []
      },
      "search": searchKeyWord,
      "page": page,
      "perPage": perPage
    };
    print("body: $body");
    final response = await http.post(Uri.parse(API_URL.SEARCH_TUTOR),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    List<Map<String, dynamic>> tutorList = [];

    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      for (int index = 0; index < data["rows"].length; index++) {
        tutorList.add({
          "userId": data["rows"][index]["userId"],
          "avatar": data["rows"][index]["avatar"],
          "name": data["rows"][index]["name"],
          "country": data["rows"][index]["country"],
          "rating": data["rows"][index]["rating"]?.toInt(),
          "specialties": data["rows"][index]["specialties"],
          "bio": data["rows"][index]["bio"],
          "isFavourite": data["rows"][index]["isfavoritetutor"] == "1"
        });
      }
    }
    return tutorList;
  }

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

        data["id"] = element["id"];
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

        data["id"] = element["id"];
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

  static Future<dynamic> loadNextScheduleData() async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    int date = DateTime.now().millisecondsSinceEpoch;
    final response = await http.get(
        Uri.parse("${API_URL.GET_NEXT_SCHEDULE}$date"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      Map<String, dynamic> data = {};
      if (res["data"].length == 0) return null;
      var element = res["data"][0];

      data["roomNameOrUrl"] = element["userId"] +
          "-" +
          element["scheduleDetailInfo"]["scheduleInfo"]["tutorId"];
      data["startTimestamp"] =
          element["scheduleDetailInfo"]["scheduleInfo"]["startTimestamp"];
      data["endTimestamp"] =
          element["scheduleDetailInfo"]["scheduleInfo"]["endTimestamp"];

      return data;
    }
    return null;
  }

  static Future<int> getTotalTimeLearn() async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http.get(Uri.parse(API_URL.GET_TOTAL_TIME_LEARN),
        headers: {"Authorization": "Bearer $token"});

    int totalTime = 0;
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      totalTime = res["total"];
    }
    return totalTime;
  }

  static Future<bool> bookAClass(String scheduleDetailIds, String note) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http.post(Uri.parse(API_URL.BOOK_A_CLASS),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "scheduleDetailIds": [scheduleDetailIds],
          "note": note
        }));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    }
    return false;
  }

  static Future<bool> updateScheduleRequest(
      String id, String studentRequest) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http.post(
        Uri.parse(API_URL.EDIT_SCHEDULE_REQUEST + id),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"studentRequest": studentRequest}));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    }
    return false;
  }
}
