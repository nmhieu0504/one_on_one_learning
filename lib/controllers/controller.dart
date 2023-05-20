// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  late bool isEnglish;
  late bool isDarkTheme;
  var bannerBackground = Colors.blue[900].obs;
  var blue_700_and_white = Colors.blue[700].obs;
  var black_and_white_card = Colors.white.obs;
  var black_and_grey_200 = Colors.grey[200].obs;
  var black_and_white_text = Colors.white.obs;
  var grey_100_and_grey_850 = Colors.grey[100].obs;
  var blue_700_and_black = Colors.blue[700].obs;
  var black_and_grey_50 = Colors.grey[100].obs;
  var blue_100_and_blue_400 = Colors.blue[100].obs;

  void onChangeTheme() {
    if (isDarkTheme) {
      bannerBackground.value = const Color.fromARGB(255, 30, 30, 30);
      blue_700_and_white.value = Colors.white;
      black_and_white_card.value = const Color.fromARGB(255, 25, 25, 26);
      black_and_grey_200.value = Colors.black;
      black_and_white_text.value = Colors.white;
      grey_100_and_grey_850.value = Colors.grey[850];
      blue_700_and_black.value = Colors.black;
      black_and_grey_50.value = Colors.black;
      blue_100_and_blue_400.value = Colors.blue[400];
    } else {
      bannerBackground.value = Colors.blue[900];
      blue_700_and_white.value = Colors.blue[700];
      black_and_white_card.value = Colors.white;
      black_and_grey_200.value = Colors.grey[200];
      black_and_white_text.value = Colors.black;
      grey_100_and_grey_850.value = Colors.grey[100];
      blue_700_and_black.value = Colors.blue[700];
      black_and_grey_50.value = Colors.grey[50];
      blue_100_and_blue_400.value = Colors.blue[100];
    }
  }
}
