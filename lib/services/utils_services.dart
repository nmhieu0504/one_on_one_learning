import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/backend.dart';
import '../utils/share_pref.dart';
import 'package:http/http.dart' as http;

class UtilsService {
  static Future<int> getSessionPrice() async {
    final response = await http.get(Uri.parse(API_URL.GET_PRICE_OF_SESSION));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var res = jsonDecode(response.body);
      return int.parse(res["price"]);
    }
    return 0;
  }
}
