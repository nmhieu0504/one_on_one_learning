import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_on_one_learning/models/reviews.dart';
import 'package:one_on_one_learning/models/tutor.dart';

import '../utils/backend.dart';
import '../utils/share_pref.dart';

class TutorServices {
  static Future<List<Map<String, dynamic>>> loadTutorList(
      String selectedSpecialties,
      String searchKeyWord,
      Map<dynamic, dynamic> checkNationality,
      int page,
      int perPage,
      {DateTime? pickedDate}) async {
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
        "tutoringTimeAvailable": pickedDate == null
            ? []
            : [
                DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0,
                        0, 0)
                    .millisecondsSinceEpoch,
                DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23,
                        59, 59)
                    .millisecondsSinceEpoch
              ]
      },
      "search": searchKeyWord,
      "page": page,
      "perPage": perPage
    };
    debugPrint("body: $body");
    final response = await http.post(Uri.parse(API_URL.SEARCH_TUTOR),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    List<Map<String, dynamic>> tutorList = [];

    if (response.statusCode == 200) {
      debugPrint(response.body);
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

  static Future<dynamic> loadReviews(
      String userID, int page, int perPage) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.get(
        Uri.parse("${API_URL.GET_REVIEWS}$userID?page=$page&perPage=$perPage"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      List<Reviews> dataList = [];
      for (var element in res["data"]["rows"]) {
        Map<String, dynamic> data = {};
        DateTime date = DateTime.parse(element["createdAt"]);
        data["avatar"] = element["firstInfo"]["avatar"];
        data["name"] = element["firstInfo"]["name"];
        data["content"] = element["content"];
        data["rating"] = element["rating"];
        data["createdAt"] = "${date.day}/${date.month}/${date.year}";

        dataList.add(Reviews.fromJson(data));
      }
      return dataList;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getTutorSchedule(
      {required DateTime startTimestamp,
      required DateTime endTimestamp,
      required String tutorId}) async {
    final response = await http.get(Uri.parse(
        "${API_URL.GET_TUTOR_SCHEDULE}tutorId=$tutorId&startTimestamp=${startTimestamp.millisecondsSinceEpoch}&endTimestamp=${endTimestamp.millisecondsSinceEpoch}"));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      List<Map<String, dynamic>> dataList = [];
      for (var element in res["scheduleOfTutor"]) {
        Map<String, dynamic> data = {};

        data["startTimestamp"] = element["startTimestamp"];
        data["endTimestamp"] = element["endTimestamp"];
        data["isBooked"] = element["isBooked"];
        data["scheduleDetailIds"] = element["scheduleDetails"][0]["id"];

        dataList.add(data);
      }
      return dataList;
    }
    return null;
  }

  static Future<Tutor> loadData(String userId) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.get(
        Uri.parse(API_URL.GET_TUTOR_DETAIL + userId),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      Tutor tutor = Tutor.fromJson(data);
      return tutor;
    }
    return Tutor(
        profession: "",
        interests: "",
        user: User(
            courses: [], id: "", name: "", country: "", isPublicRecord: false),
        languages: "",
        avgRating: 0,
        totalFeedback: 0,
        isFavorite: false,
        specialties: "");
  }

  static Future<bool> sendReport(
      String userId, List<String> selectedRepotItems) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.post(Uri.parse(API_URL.REPORT_TUTOR),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
            {"tutorId": userId, "content": selectedRepotItems.join("\n")}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    }
    return false;
  }

  static Future<bool> modifyFavourite(String userId) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.post(Uri.parse(API_URL.ADD_TO_FAVOURITE),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"tutorId": userId}));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    }
    return false;
  }
}
