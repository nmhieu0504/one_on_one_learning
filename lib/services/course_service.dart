import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/course.dart';
import 'package:one_on_one_learning/models/ebook.dart';

import '../utils/backend.dart';
import '../utils/share_pref.dart';
import 'package:http/http.dart' as http;

class CoursesService {
  static Future<dynamic> loadCoursesList(
      {required int page,
      required int size,
      List<Map<String, dynamic>> courseContentCategories = const [],
      List<Map<String, dynamic>> levelList = const [],
      bool? sortingOrder,
      String q = ""}) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    String queryURL = "page=$page&size=$size";

    if (courseContentCategories.isNotEmpty) {
      for (var element in courseContentCategories) {
        if (element["isSelected"]) {
          queryURL += "&categoryId[]=${element["id"]}";
        }
      }
    }

    if (levelList.isNotEmpty) {
      for (int i = 0; i < levelList.length; i++) {
        if (levelList[i]["isSelected"]) {
          queryURL += "&level[]=$i";
        }
      }
    }

    if (sortingOrder != null) {
      queryURL += "&order[]=level";
      if (!sortingOrder) {
        queryURL += "&orderBy[]=ASC";
      } else {
        queryURL += "&orderBy[]=DESC";
      }
    }

    if (q.isNotEmpty) {
      q = q.trim();
      queryURL += "&q=$q";
    }

    debugPrint("queryURL: $queryURL");
    debugPrint("URL: ${Uri.parse(API_URL.GET_COURSES_LIST + queryURL)}");

    final response = await http
        .get(Uri.parse(API_URL.GET_COURSES_LIST + queryURL), headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      List<Course> dataList = [];
      for (var element in res["data"]["rows"]) {
        Map<String, dynamic> data = {};

        data["name"] = element["name"];
        data["description"] = element["description"];
        data["level"] = element["level"];
        data["imageUrl"] = element["imageUrl"];
        data["numberOfTopics"] = element["topics"].length;
        data["categories"] = element["categories"][0]["title"];
        data["id"] = element["id"];
        data["reason"] = element["reason"];
        data["purpose"] = element["purpose"];
        data["topics"] = element["topics"];

        dataList.add(Course.fromJson(data));
      }
      return dataList;
    }
    return null;
  }

  static Future<dynamic> loadContentCategory() async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response =
        await http.get(Uri.parse(API_URL.GET_COURSE_CATEGORY), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      List<Map<String, dynamic>> dataList = [];
      for (var element in res["rows"]) {
        Map<String, dynamic> data = {};

        data["title"] = element["title"];
        data["id"] = element["id"];
        data["key"] = element["key"];

        dataList.add(data);
      }
      return dataList;
    }
    return null;
  }

  static Future<dynamic> loadEbookList(
      {required int page,
      required int size,
      List<Map<String, dynamic>> courseContentCategories = const [],
      List<Map<String, dynamic>> levelList = const [],
      bool? sortingOrder,
      String q = ""}) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    String queryURL = "page=$page&size=$size";

    if (courseContentCategories.isNotEmpty) {
      for (var element in courseContentCategories) {
        if (element["isSelected"]) {
          queryURL += "&categoryId[]=${element["id"]}";
        }
      }
    }

    if (levelList.isNotEmpty) {
      for (int i = 0; i < levelList.length; i++) {
        if (levelList[i]["isSelected"]) {
          queryURL += "&level[]=$i";
        }
      }
    }

    if (sortingOrder != null) {
      queryURL += "&order[]=level";
      if (!sortingOrder) {
        queryURL += "&orderBy[]=ASC";
      } else {
        queryURL += "&orderBy[]=DESC";
      }
    }

    if (q.isNotEmpty) {
      q = q.trim();
      queryURL += "&q=$q";
    }

    debugPrint("queryURL: $queryURL");
    debugPrint("URL: ${Uri.parse(API_URL.GET_EBOOK_LIST + queryURL)}");

    final response =
        await http.get(Uri.parse(API_URL.GET_EBOOK_LIST + queryURL), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      List<EBook> dataList = [];
      for (var element in res["data"]["rows"]) {
        Map<String, dynamic> data = {};

        data["name"] = element["name"];
        data["description"] = element["description"];
        data["level"] = element["level"];
        data["imageUrl"] = element["imageUrl"];
        data["fileUrl"] = element["fileUrl"];

        dataList.add(EBook.fromJson(data));
      }
      return dataList;
    }
    return null;
  }

  static Future<dynamic> loadCourseByID(String id) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http
        .get(Uri.parse(API_URL.GET_COURSE_DETAIL_BY_ID + id), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      Map<String, dynamic> data = {};
      var element = res["data"];

      data["name"] = element["name"];
      data["description"] = element["description"];
      data["level"] = element["level"];
      data["imageUrl"] = element["imageUrl"];
      data["numberOfTopics"] = element["topics"].length;
      data["categories"] = "";
      data["id"] = element["id"];
      data["reason"] = element["reason"];
      data["purpose"] = element["purpose"];
      data["topics"] = element["topics"];

      return Course.fromJson(data);
    }
    return null;
  }
}
