// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:one_on_one_learning/models/user.dart';
import '../utils/backend.dart';
import '../utils/share_pref.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<dynamic> loadUserInfo() async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.get(Uri.parse(API_URL.GET_USER_DETAIL),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      print(response.body);
      var res = jsonDecode(response.body);
      Map<String, dynamic> data = {};
      
      data["id"] = res["user"]["id"];
      data["email"] = res["user"]["email"];
      data["name"] = res["user"]["name"];
      data["avatar"] = res["user"]["avatar"];
      data["country"] = res["user"]["country"];
      data["phone"] = res["user"]["phone"];
      data["roles"] = res["user"]["roles"];
      data["language"] = res["user"]["language"];
      data["birthday"] = res["user"]["birthday"];
      data["isActivated"] = res["user"]["isActivated"];
      data["walletInfo"] = res["user"]["walletInfo"];
      data["courses"] = res["user"]["courses"];
      data["requireNote"] = res["user"]["requireNote"];
      data["level"] = res["user"]["level"];
      data["learnTopics"] = res["user"]["learnTopics"];
      data["testPreparations"] = res["user"]["testPreparations"];
      data["isPhoneActivated"] = res["user"]["isPhoneActivated"];
      data["timezone"] = res["user"]["timezone"];
      data["studySchedule"] = res["user"]["studySchedule"];
      data["canSendMessage"] = res["user"]["canSendMessage"];

      return User.fromJson(data);
    }
    return null;
  }
}
