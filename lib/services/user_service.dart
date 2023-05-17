import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/user.dart';
import '../utils/backend.dart';
import '../utils/share_pref.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<dynamic> loadUserInfo({bool isSocketCall = false}) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.get(Uri.parse(API_URL.USER_DETAIL_INFO),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      debugPrint(response.body);
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

      if (isSocketCall) {
        return data;
      }

      return User.fromJson(data);
    }
    return null;
  }

  static Future<dynamic> updateUserInfo(Map<String, dynamic> bodyInfo) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    final response = await http.put(Uri.parse(API_URL.USER_DETAIL_INFO),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(bodyInfo));
    debugPrint(jsonEncode(bodyInfo));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    }
    return false;
  }

  static Future<dynamic> updateUserAvatar(File imageFile) async {
    debugPrint("File selected: ${imageFile.path}");
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    var request =
        http.MultipartRequest('POST', Uri.parse(API_URL.UPDATE_USER_AVATAR));
    request.files
        .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type":
          "multipart/form-data; boundary=----WebKitFormBoundaryVx3opYIudlAppGP5",
      "origin": "https://sandbox.api.lettutor.com",
      "referer": "https://sandbox.api.lettutor.com/"
    });

    final response = await request.send();
    String responseBody = await response.stream.transform(utf8.decoder).join();
    debugPrint('Image uploaded with response body: $responseBody');

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
