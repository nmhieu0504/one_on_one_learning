// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/backend.dart';
import '../utils/share_pref.dart';

class AuthService {
  static Future<bool> signIn(String email, String password) async {
    SharePref sharePref = SharePref();
    final response = await http.post(Uri.parse(API_URL.LOGIN),
        body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      sharePref.saveString("access_token", data["tokens"]["access"]["token"]);
      sharePref.saveString(
          "access_token_exp", data["tokens"]["access"]["expires"]);
      sharePref.saveString("refresh_token", data["tokens"]["refresh"]["token"]);
      sharePref.saveString(
          "refresh_token_exp", data["tokens"]["refresh"]["expires"]);

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    final response = await http.post(Uri.parse(API_URL.REGISTER),
        headers: {
          "Content-Type": "application/json",
          "Origin": "https://sandbox.app.lettutor.com",
          "Referer": "https://sandbox.app.lettutor.com",
        },
        body:
            jsonEncode({"email": email, "password": password, "source": null}));

    if (response.statusCode == 201) {
      debugPrint(response.body);
      return true;
    } else {
      debugPrint(response.body);
      return false;
    }
  }

  static Future<bool> forgetPass(String email) async {
    final response =
        await http.post(Uri.parse(API_URL.FORGET_PASSWORD), headers: {
      "Origin": "https://sandbox.app.lettutor.com",
      "Referer": "https://sandbox.app.lettutor.com",
    }, body: {
      "email": email
    });

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return true;
    } else {
      debugPrint(response.body);
      return false;
    }
  }

  static Future<bool> signInWithGoogle(String access_token) async {
    SharePref sharePref = SharePref();
    final response = await http.post(Uri.parse(API_URL.LOGIN_WITH_GOOGLE),
        body: {"access_token": access_token});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      sharePref.saveString("access_token", data["tokens"]["access"]["token"]);
      sharePref.saveString(
          "access_token_exp", data["tokens"]["access"]["expires"]);
      sharePref.saveString("refresh_token", data["tokens"]["refresh"]["token"]);
      sharePref.saveString(
          "refresh_token_exp", data["tokens"]["refresh"]["expires"]);

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }

  static Future<bool> signInWithFacebook(String access_token) async {
    SharePref sharePref = SharePref();
    final response = await http.post(Uri.parse(API_URL.LOGIN_WITH_FACEBOOK),
        body: {"access_token": access_token});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      sharePref.saveString("access_token", data["tokens"]["access"]["token"]);
      sharePref.saveString(
          "access_token_exp", data["tokens"]["access"]["expires"]);
      sharePref.saveString("refresh_token", data["tokens"]["refresh"]["token"]);
      sharePref.saveString(
          "refresh_token_exp", data["tokens"]["refresh"]["expires"]);

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }
}
