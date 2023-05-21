import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/chat_message.dart';

import '../utils/backend.dart';
import '../utils/share_pref.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<dynamic> loadMessage(String id, int page, int perPage) async {
    final SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");

    DateTime now = DateTime.now();
    String queryURL =
        "$id?startTime=${now.millisecondsSinceEpoch}&page=$page&perPage=$perPage";

    final response = await http
        .get(Uri.parse(API_URL.GET_CHAT_MESSAGE + queryURL), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      List<Message> messagesList = [];
      var res = jsonDecode(response.body);
      for (var item in res["rows"]) {
        Map<String, dynamic> data = {};

        data["userID"] = item["fromInfo"]["id"];
        data["message"] = item["content"];
        data["date"] = item["createdAt"];
        data["sentByMe"] = item["fromInfo"]["id"] != id;

        messagesList.add(Message.fromJson(data));
      }
      return messagesList;
    }
    return null;
  }
}
